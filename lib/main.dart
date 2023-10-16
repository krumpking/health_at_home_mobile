import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/screens/doctor/appointment/doctor_appointment_summary.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';
import 'package:mobile/ui/screens/home.dart';
import 'package:mobile/ui/screens/patient_appointment_summary_tracking/patient_appointment_summary.dart';
import 'package:mobile/utils/no_internet.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_aware_state/visibility_aware_state.dart';

import 'config/app.dart';
import 'models/user/user.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await Hive.openBox('app');
  await Firebase.initializeApp();
  var prefs = await SharedPreferences.getInstance();

  if (prefs.getBool('first_run') ?? true) {
    FlutterSecureStorage storage = FlutterSecureStorage();

    await storage.deleteAll();

    prefs.setBool('first_run', false);
  }
  try {
    ApiProvider _provider = new ApiProvider();

    App.init();
    var userData = await App.loadUser();
    if (userData != null) {
      App.currentUser = User.fromJson(jsonDecode(userData));
      if (App.isLoggedIn) {
        await _provider.refreshUser();

        if (App.currentUser.userType == UserTypes.DOCTOR) {
          var activeTravel = await _provider.getActiveTravel();
          if (activeTravel != null) {
            App.enRouteBooking = activeTravel;
          }
        }
      }
    }

    bool setupSuccess = await App.getSetupComplete();
    if (setupSuccess) {
      App.setupComplete = true;
    }
    bool patientOnboardingSuccess = await App.getPatientOnboardingComplete();
    if (patientOnboardingSuccess) {
      App.patientOnboardingComplete = true;
    }

    bool doctorOnboardingComplete = await App.getDoctorOnboardingComplete();
    if (doctorOnboardingComplete) {
      App.doctorOnboardingComplete = true;
    }
    bool biometricsComplete = await App.getBiometricsSet();
    if (biometricsComplete) {
      App.biometricsSet = true;
    }
    String? code = await App.getPasscode();
    if (code != null) {
      App.passcode = code;
    }
    var settings = await _provider.getAppSettings();
    if (settings != null) {
      App.settings = settings;
    }

    var key = await FirebaseMessaging.instance.getToken();
    App.deviceKey = key!;
  } catch (_error) {
    print(_error.toString());
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(HatHApp());
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  handleRefreshMessage(message);
}

void handleRefreshMessage(RemoteMessage message) {
  if (message.data['notificationType'] != null &&
      message.data['notificationType'] == 'refresh') {
    Navigator.pop(navigatorKey.currentState!.context);
    if (message.data['subscriptionId'] != null &&
        int.tryParse(message.data["subscriptionId"]) != null) {
      int id = int.parse(message.data["subscriptionId"]);
      // Navigator.push(
      //   navigatorKey.currentState!.context,
      //   MaterialPageRoute(
      //     builder: (context) => SubscriptionDetails(
      //       subscriptionId: id,
      //     ),
      //   ),
      // );
    }
    if (message.data['bookingId'] != null &&
        int.tryParse(message.data["bookingId"]) != null) {
      int id = int.parse(message.data["bookingId"]);
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => PatientAppointmentSummary(
            bookingId: id,
          ),
        ),
      );
    }
  }
}

class HatHApp extends StatefulWidget {
  @override
  _HatHAppState createState() => _HatHAppState();
}

class _HatHAppState extends VisibilityAwareState<HatHApp> {
  static late final FirebaseMessaging _firebaseMessaging;
  UniqueKey _key = UniqueKey();
  String messageTitle = "Empty";
  String notificationAlert = "alert";
  bool _hasInternetConnection = true;

  @override
  void initState() {
    _initPage();
    checkForInitialMessage();
    super.initState();
  }

  Future<void> _initPage() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      await registerNotification();
      doCurrentLocation();
    } else {
      _hasInternetConnection = false;
      setState(() {});
    }
  }

  Future<void> doCurrentLocation() async {
    await Utilities.handleGeoPermissions();
    var _loc = await Utilities.getUserLocation();
    if (_loc != null) {
      App.currentLocation = _loc;
    }
  }

  Future<void> registerNotification() async {
    _firebaseMessaging = FirebaseMessaging.instance;
    App.deviceKey = await FirebaseMessaging.instance.getToken();

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        showNotification(message);
      });
      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        handleNavigation(message);
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      showNotification(initialMessage);
    }
  }

  void showNotification(RemoteMessage message) {
    showSimpleNotification(
      InkWell(
        onTap: () {
          setState(() {});
          handleNavigation(message);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.notification!.title!,
                    style: TextStyle(
                      color: App.theme.turquoise,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    message.notification!.body!,
                    style: TextStyle(
                      color: App.theme.darkText,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              SvgPicture.asset(
                'assets/icons/icon_right_arrow.svg',
                width: 24,
              ),
            ],
          ),
        ),
      ),
      duration: Duration(seconds: 8),
      elevation: 150,
      autoDismiss: true,
      slideDismissDirection: DismissDirection.up,
      background: App.theme.white,
    );
    handleRefreshMessage(message);
  }

  void handleNavigation(RemoteMessage message) {
    if (message.data['bookingId'] != null &&
        int.tryParse(message.data["bookingId"]) != null) {
      int id = int.tryParse(message.data["bookingId"]) ?? 0;
      if (message.data['for'] != null &&
          message.data['for'].toString().toLowerCase() == 'patient') {
        App.setActiveApp(ActiveApp.PATIENT);

        Navigator.push(
          navigatorKey.currentState!.context,
          MaterialPageRoute(
            builder: (context) => PatientAppointmentSummary(
              bookingId: id,
            ),
          ),
        );
      } else if (message.data['for'] != null &&
          message.data['for'].toString().toLowerCase() == 'doctor') {
        App.setActiveApp(ActiveApp.DOCTOR);
        Navigator.push(
          navigatorKey.currentState!.context,
          MaterialPageRoute(
            builder: (context) => DoctorAppointmentSummary(
              bookingId: id,
            ),
          ),
        );
      }
    }
    if (message.data['subscriptionId'] != null &&
        int.tryParse(message.data["subscriptionId"]) != null) {
      int id = int.tryParse(message.data["subscriptionId"]) ?? 0;
      // Navigator.push(
      //   navigatorKey.currentState!.context,
      //   MaterialPageRoute(
      //     builder: (context) => SubscriptionDetails(
      //       subscriptionId: id,
      //     ),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return OverlaySupport.global(
      child: MaterialApp(
        key: _key,
        navigatorKey: navigatorKey,
        title: 'Health At Home',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Jost',
          scaffoldBackgroundColor: App.theme.turquoise50,
          textTheme: App.theme.textTheme!.apply(
              bodyColor: App.theme.lightText,
              displayColor: App.theme.lightText),
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          }),
        ),
        home: _hasInternetConnection
            ? App.currentUser.userType == UserTypes.DOCTOR
                ? DoctorHome()
                : Home(0)
            : NoInternet(),
      ),
    );
  }
}
