import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/config/theme.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/screens/auth/login.dart';
import 'package:mobile/ui/screens/patient/booking/new_booking_someone_else.dart';
import 'package:mobile/ui/screens/patient_medical_profile/patient_medical_profile_visit_history.dart';
import 'package:mobile/ui/screens/subsctriptions/subscription.list.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/booking/booking.dart';
import '../../models/user/user.dart';
import '../../providers/api.dart';
import '../partials/patient_appointment_card.dart';
import 'auth/verify.code.dart';
import 'home.dart';

class GuestHomePage extends StatefulWidget {
  GuestHomePage({Key? key}) : super(key: key);

  @override
  _GuestHomePage createState() => _GuestHomePage();
}

class _GuestHomePage extends State<GuestHomePage> {
  ApiProvider _provider = new ApiProvider();
  final oCcy = new NumberFormat("#,##0", "en_US");
  late List<Booking> _bookings = <Booking>[];
  bool _bookingsLoading = false;
  bool _servicesLoading = true;
  late String _bookingsError = '';
  bool _locationPermission = false;

  @override
  void initState() {
    App.setActiveApp(ActiveApp.PATIENT);
    if (App.isLoggedIn) {
      setState(() {
        _bookingsLoading = true;
      });
    }
    initPage();
    super.initState();
  }

  Future<void> initPage() async {
    loadBookings();
    if (await Permission.location.isGranted) {
      _locationPermission = true;
      setState(() {});
    }
  }

  Future<void> loadBookings() async {
    setState(() {
      _bookingsLoading = true;
    });
    if (App.isLoggedIn && User.isAuthentic(App.currentUser)) {
      try {
        List<Booking>? bookings = await _provider.getPatientBookings();
        if (bookings != null) {
          setState(() {
            _bookings = bookings;
          });
        }
        setState(() {
          _bookingsLoading = false;
        });
      } catch (_err) {
        print(_err.toString());
        if (mounted) {
          setState(() {
            _bookingsError = 'Failed to load visits.';
            _bookingsLoading = false;
          });
        }
      }
    } else {
      setState(() {
        _bookingsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    App.theme = new AppTheme();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: 16, top: 60, right: 16, bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _locationPermission
                          ? "Hi${App.isLoggedIn ? ' ' + App.currentUser.firstName : ''}, Welcome!"
                          : "ENABLE LOCATION PERMISSIONS",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: _locationPermission ? 20 : 18,
                        color: _locationPermission
                            ? App.theme.grey800
                            : Colors.red,
                      ),
                    ),
                    //SvgPicture.asset("assets/icons/logo_small.svg"),
                  ],
                ),
                Text(
                  _locationPermission
                      ? 'Get a doctor to your door step.'
                      : 'For best app experience',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color:
                        _locationPermission ? App.theme.turquoise : Colors.red,
                  ),
                ),
                SizedBox(height: 16),
                !App.isLoggedIn
                    ? Column(
                        children: [
                          _locationPermission
                              ? PrimaryRegularButton(
                                  title: "Login / Register",
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()),
                                    );
                                  })
                              : PrimaryRegularButton(
                                  title: "Open App permissions settings",
                                  onPressed: () {
                                    AppSettings.openAppSettings(
                                        type: AppSettingsType.location);
                                  }),
                        ],
                      )
                    : _bookingsLoading
                        ? Center(
                            child: SizedBox(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    App.theme.turquoise!.withOpacity(0.5)),
                              ),
                              height: MediaQuery.of(context).size.height * 0.03,
                              width: MediaQuery.of(context).size.height * 0.03,
                            ),
                          )
                        : MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _bookings.length,
                                itemBuilder: (context, index) {
                                  Booking booking = _bookings[index];
                                  if (index > 1) return Container();
                                  return PatientAppointmentCard(
                                      booking: booking, callBack: loadBookings);
                                }),
                          ),
                SizedBox(height: 8),
                if (_bookings.length > 2)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PatientMedicalProfileVisitHistory()),
                          );
                        },
                        child: Text(
                          "View All",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            color: App.theme.turquoise,
                          ),
                        ),
                      )
                    ],
                  )
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0XFFF8FAFC),
              boxShadow: [
                BoxShadow(
                  color: App.theme.grey!.withOpacity(0.05),
                  spreadRadius: 8,
                  blurRadius: 10,
                  offset: Offset(-2, -2), // changes position of shadow
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    if (App.isLoggedIn) {
                      if (User.isAuthentic(App.currentUser) &&
                          !App.currentUser.isActive) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  VerifyCode(uuid: App.currentUser.uuid)),
                        );
                      } else {
                        App.progressBooking!.bookingFlow =
                            BookingFlow.HOME_PLUS;
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PatientAppointmentSomeoneElse();
                        }));
                      }
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Login();
                      }));
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 28),
                    decoration: BoxDecoration(
                        color: App.theme.turquoise!,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: App.theme.turquoise!.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(2, 2), // changes position of shadow
                          ),
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Book a Home Visit',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: App.theme.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    Box box = Hive.box('app');
                    box.put('home_index', 2);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 28),
                    decoration: BoxDecoration(
                        color: App.theme.turquoise!,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: App.theme.turquoise!.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(2, 2), // changes position of shadow
                          ),
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'View Practitioners',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: App.theme.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SubscriptionList();
                    }));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 28),
                    decoration: BoxDecoration(
                        color: App.theme.turquoise!,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: App.theme.turquoise!.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(2, 2), // changes position of shadow
                          ),
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Medical Plans',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: App.theme.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 85),
        ],
      ),
    );
  }
}
