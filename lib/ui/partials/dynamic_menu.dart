import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/user/user.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/auth/login.dart';
import 'package:mobile/ui/screens/contact_us.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';
import 'package:mobile/ui/screens/doctor/menu/doctor_menu_communication_preferences.dart';
import 'package:mobile/ui/screens/home.dart';
import 'package:mobile/ui/screens/patient_communication_preferences.dart';
import 'package:mobile/ui/screens/patient_medical_profile/patient_home_address.dart';
import 'package:share/share.dart';

import '../screens/login_details.dart';
import 'button.dart';
import 'menu_text.dart';

class DynamicMenu extends StatefulWidget {
  const DynamicMenu({Key? key}) : super(key: key);

  @override
  _DynamicMenuState createState() => _DynamicMenuState();
}

class _DynamicMenuState extends State<DynamicMenu> {
  ActiveApp _activeApp = App.activeApp;
  final oCcy = new NumberFormat("#,##0", "en_US");

  @override
  Widget build(BuildContext context) {
    if (_activeApp == ActiveApp.DOCTOR) {
      return DarkStatusNavigationBarWidget(
        child: getMenu(),
      );
    }
    return LightStatusNavigationBarWidget(
      child: getMenu(),
    );
  }

  Widget getMenu() {
    return WillPopScope(child: Scaffold(
      backgroundColor: _activeApp == ActiveApp.DOCTOR ? App.theme.darkBackground : App.theme.turquoise50,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Text(
                'Menu',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 23,
                  color: _activeApp == ActiveApp.DOCTOR ? App.theme.white : App.theme.darkText,
                ),
              ),
              SizedBox(height: 16),
              Divider(color: App.theme.lightGreyColor!.withOpacity(0.2)),
              (!App.isLoggedIn)
                  ? MyMenuItem(
                  menuTitle: 'Login or Sign Up',
                  menuSubtitle: '',
                  enabled: true,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return Login(goBack: true);
                      }),
                    );
                  })
                  : MyMenuItem(
                  menuTitle: 'Login Details',
                  menuSubtitle: '',
                  enabled: true,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return LoginDetails();
                      }),
                    );
                  }),
              if (_activeApp != ActiveApp.DOCTOR)
                MyMenuItem(
                  menuTitle: 'Home Address:',
                  menuSubtitle: (App.currentUser.patientProfile != null &&
                      App.currentUser.patientProfile!.savedAddress != null &&
                      App.currentUser.patientProfile!.savedAddress!.address.isNotEmpty)
                      ? App.currentUser.patientProfile!.savedAddress!.address +
                      ((App.currentUser.patientProfile!.savedAddress!.unit.isNotEmpty)
                          ? ' (' + App.currentUser.patientProfile!.savedAddress!.unit + ')'
                          : '')
                      : 'Tap to add',
                  enabled: App.isLoggedIn,
                  onPressed: () async {
                    if (App.currentUser.patientProfile!.savedAddress!.lat.isNotEmpty &&
                        App.currentUser.patientProfile!.savedAddress!.lng.isNotEmpty) {
                      App.currentLocation = LatLng(double.parse(App.currentUser.patientProfile!.savedAddress!.lat),
                          double.parse(App.currentUser.patientProfile!.savedAddress!.lng));
                    } else {
                      Utilities.getUserLocation();
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return PatientHomeAddress();
                      }),
                    );
                  },
                ),
              MyMenuItem(
                  menuTitle: 'Communication Preferences',
                  menuSubtitle: '',
                  enabled: App.isLoggedIn,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return (_activeApp == ActiveApp.DOCTOR) ? DoctorMenuCommunicationPreferences() : PatientMenuCommunicationPreferences();
                      }),
                    );
                  }),
              if (_activeApp != ActiveApp.DOCTOR)
                MyMenuItem(
                    menuTitle: 'Get Prescriptions Delivered by MedOrange',
                    menuSubtitle: '',
                    enabled: true,
                    onPressed: () {
                      App.launchURL("https://medorange.com/contact-us");
                    }),
              if (_activeApp != ActiveApp.DOCTOR)
                MyMenuItem(
                    menuTitle: 'Share Health At Home',
                    menuSubtitle: '',
                    enabled: (App.isLoggedIn &&
                        (App.currentUser.patientProfile!.referralCode != null && !App.currentUser.patientProfile!.referralCode!.isUsed)),
                    onPressed: () {
                      String iosLink = "https://apps.apple.com/us/app/health-at-home-mobile/id1601263619";
                      String androidLink = "https://play.google.com/store/apps/details?id=zw.co.healthathome.mobile";
                      Share.share(
                          'Try Health At Home\nOrder a doctor, physio and more to your doorstep! Use referral code ${App.currentUser.patientProfile!.referralCode!.code} for \$${oCcy.format(App.settings!.shareDiscount)} off your first visit.\nIOS: $iosLink\nAndroid: $androidLink');
                    }),
              MyMenuItem(
                  menuTitle: 'Contact Us',
                  menuSubtitle: '',
                  enabled: true,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ContactUs();
                      }),
                    );
                  }),
              MyMenuItem(
                  menuTitle: 'Give Feedback',
                  menuSubtitle: '',
                  enabled: true,
                  onPressed: () {
                    App.launchURL("https://docs.google.com/forms/d/e/1FAIpQLScL5tEgEYNYYNhomKVuApW4yR6VwCg7UsQ2FAuSVsUasqevBg/viewform?usp=sf_link");
                  }),
              App.isLoggedIn && App.currentUser.userType == UserTypes.DOCTOR && App.activeApp != ActiveApp.DOCTOR
                  ? MyMenuItem(
                  menuTitle: 'Switch To Doctor\'s App',
                  menuSubtitle: '',
                  enabled: true,
                  onPressed: () async {
                    App.setActiveApp(ActiveApp.DOCTOR);
                    setState(() {
                      _activeApp = ActiveApp.DOCTOR;
                    });
                    Navigator.of(context)
                        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => DoctorHome()), (Route<dynamic> route) => false);
                  })
                  : (App.isLoggedIn && App.currentUser.userType == UserTypes.DOCTOR && App.activeApp == ActiveApp.DOCTOR
                  ? MyMenuItem(
                  menuTitle: 'Switch To Patient\'s App',
                  menuSubtitle: '',
                  enabled: true,
                  onPressed: () {
                    App.setActiveApp(ActiveApp.PATIENT);
                    setState(() {
                      _activeApp = ActiveApp.PATIENT;
                    });
                    Navigator.of(context)
                        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home(0)), (Route<dynamic> route) => false);
                  })
                  : MyMenuItem(
                  menuTitle: 'Apply For A Doctor\'s Account',
                  menuSubtitle: '',
                  enabled: true,
                  onPressed: () {
                    App.launchURL(
                        "https://docs.google.com/forms/d/e/1FAIpQLSfVEdqCtOYA7Lh9Uf-egRMShmdwr1rYMJMfRjBWKTxGiCL5cg/viewform?usp=sf_link");
                  })),
              MyMenuItem(
                  menuTitle: 'Privacy Policy',
                  menuSubtitle: '',
                  enabled: true,
                  onPressed: () {
                    App.launchURL("https://healthathome.co.zw/privacy_policy");
                  }),
              if (App.isLoggedIn)
                MyMenuItem(
                    menuTitle: 'Logout',
                    menuSubtitle: '',
                    enabled: true,
                    onPressed: () {
                      _logOutDialog();
                    }),
              if (App.isLoggedIn)
                MyMenuItem(
                  menuTitle: 'Delete my Account',
                  menuSubtitle: '',
                  color: Colors.redAccent,
                  enabled: true,
                  onPressed: () async {
                    _deleteAccountDialog();
                  },
                ),
            ],
          ),
        ),
      ),
    ), onWillPop: () async => false,);
  }

  Future<void> _logOutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: App.activeApp == ActiveApp.DOCTOR ? App.theme.darkGrey : App.theme.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
          contentPadding: EdgeInsets.all(16),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 8),
                SvgPicture.asset(App.activeApp == ActiveApp.DOCTOR ? 'assets/icons/icon_exit.svg' : 'assets/icons/icon_exit_dark.svg'),
                SizedBox(height: 24),
                Text(
                  'Are you sure you want to logout?',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: App.activeApp == ActiveApp.DOCTOR ? App.theme.white : App.theme.darkText),
                ),
                SizedBox(height: 24),
                PrimaryRegularButton(
                    title: 'Logout',
                    onPressed: () {
                      App.logout();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => Home(0),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    }),
                SizedBox(height: 16),
                GestureDetector(
                  child: Text(
                    'Stay Logged In',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: App.activeApp == ActiveApp.DOCTOR ? App.theme.turquoiseLight : App.theme.turquoise),
                  ),
                  onTap: () => {Navigator.pop(context)},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteAccountDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: App.activeApp == ActiveApp.DOCTOR ? App.theme.darkGrey : App.theme.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
          contentPadding: EdgeInsets.all(16),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 8),
                SvgPicture.asset(
                  'assets/icons/icon_error.svg',
                  width: 50,
                ),
                SizedBox(height: 24),
                Text(
                  'Are you sure you want to delete your account?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: App.activeApp == ActiveApp.DOCTOR ? App.theme.white : App.theme.darkText),
                ),
                SizedBox(height: 12),
                Text(
                  'Deleting your account will also delete all profile and appointment data.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: App.activeApp == ActiveApp.DOCTOR ? App.theme.white : App.theme.darkText),
                ),
                SizedBox(height: 24),
                SuccessRegularButton(
                    title: 'Keep my account',
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                SizedBox(height: 16),
                GestureDetector(
                  child: Text(
                    'Yes, Delete Account',
                    style: TextStyle(
                      fontSize: 14,
                      height: 2,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () async {
                    ApiProvider _api = ApiProvider();
                    bool success = await _api.deleteAccount(App.currentUser.id);
                    if (success) {
                      App.deleteAccount();
                      Navigator.pop(context);
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => Home(0),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
