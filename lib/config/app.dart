import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mobile/config/theme.dart';
import 'package:mobile/models/app_setting.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/models/booking_report.dart';
import 'package:mobile/models/language.dart';
import 'package:mobile/models/patient_report.dart';
import 'package:mobile/models/service.dart';
import 'package:mobile/models/specialisation.dart';
import 'package:mobile/models/user/doctorProfile.dart';
import 'package:mobile/models/user/signup_user.dart';
import 'package:mobile/models/user/user.dart';
import 'package:mobile/providers/doctor_search.dart';
import 'package:mobile/providers/social_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class App {
  static Mode mode = Mode.LIGHT;
  static ActiveApp activeApp = ActiveApp.GUEST;
  static AppTheme theme = new AppTheme();
  static User currentUser = new User();
  static bool isLoggedIn = false;
  static bool onAuthPage = false;
  static bool isLocked = false;
  static bool resumed = true;
  static bool isFromViewPractioners = false;
  static bool setupComplete = false;
  static bool patientOnboardingComplete = false;
  static bool doctorOnboardingComplete = false;
  static bool biometricsSet = false;
  static String passcode = '';
  static String? sessionMessage;
  static String? deviceKey = '';
  static Booking? progressBooking = Booking.init();
  static Booking? enRouteBooking;
  static List<Language> languages = <Language>[];
  static List<Specialisation> specialisations = <Specialisation>[];
  static List<Service> services = <Service>[];
  static List<Booking> bookings = <Booking>[];
  static List<Booking> doctorBookings = <Booking>[];
  static SignUpUser? signUpUser = SignUpUser.init();
  static DoctorSearch doctorSearch = new DoctorSearch();
  static AppSetting? settings;
  static LatLng? currentLocation;
  static List<DoctorProfile> doctors = <DoctorProfile>[];
  static BookingReport progressReport = BookingReport.init();
  static PatientReport patientReport = PatientReport.init();
  static bool resumedFromMain = false;
  static int notificationCounter = 0;
  static int gpServiceId = 1;
  static int covidServiceId = 2;
  static int pediaServiceId = 3;
  static int dietServiceId = 4;
  static int physioServiceId = 5;
  static String newLineDelimiter = '<br/>';

  static Future<void> init() async {
    activeApp = ActiveApp.GUEST;
    final _storage = FlutterSecureStorage();
    var app = await _storage.read(key: 'activeApp');
    if (app != null) {
      if (app == 'ActiveApp.DOCTOR') {
        activeApp = ActiveApp.DOCTOR;
        mode = Mode.DARK;
      } else {
        activeApp = ActiveApp.PATIENT;
        mode = Mode.LIGHT;
      }
    } else {
      activeApp = ActiveApp.GUEST;
      mode = Mode.LIGHT;
    }

    var logged = await _storage.read(key: 'isLoggedIn');
    if (logged != null) {
      App.isLoggedIn = true;
    }
    setActiveApp(activeApp);
  }

  static Size size(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static Future loadUser() async {
    final _storage = FlutterSecureStorage();
    return await _storage.read(key: 'currentUser');
  }

  static setActiveApp(ActiveApp activeApp) {
    final _storage = FlutterSecureStorage();
    App.activeApp = activeApp;
    _storage.write(key: 'activeApp', value: activeApp.toString());
    App.theme = AppTheme();
  }

  static Future<bool> logout() async {
    SocialAuth _socialAuth = SocialAuth();
    final _storage = FlutterSecureStorage();
    _storage.delete(key: 'activeApp');
    _storage.delete(key: 'isLoggedIn');
    App.isLoggedIn = false;
    setActiveApp(ActiveApp.GUEST);
    await _socialAuth.signOut();
    return true;
  }

  static Future<bool> deleteAccount() async {
    SocialAuth _socialAuth = SocialAuth();
    final _storage = FlutterSecureStorage();
    _storage.delete(key: 'activeApp');
    _storage.delete(key: 'isLoggedIn');
    _storage.delete(key: 'currentUser');
    App.isLoggedIn = false;
    App.currentUser = new User();
    setActiveApp(ActiveApp.GUEST);
    await _socialAuth.signOut();
    return true;
  }

  static Future<String?> getToken() async {
    final _storage = FlutterSecureStorage();
    return await _storage.read(key: 'token');
  }

  static Future<String?> getTempPasscode() async {
    final _storage = FlutterSecureStorage();
    return await _storage.read(key: 'tempPasscode');
  }

  static void setTempPasscode(String code) async {
    final _storage = FlutterSecureStorage();
    await _storage.write(key: 'tempPasscode', value: code);
  }

  static Future<bool> getBiometricsSet() async {
    final _storage = FlutterSecureStorage();
    return await _storage.read(key: 'biometricsEnrolled') != null
        ? true
        : false;
  }

  static Future<bool> getSetupComplete() async {
    final _storage = FlutterSecureStorage();
    return await _storage.read(key: 'setupComplete') != null ? true : false;
  }

  static Future<bool> getPatientOnboardingComplete() async {
    final _storage = FlutterSecureStorage();
    return await _storage.read(key: 'patientOnboardingComplete') != null
        ? true
        : false;
  }

  static Future<bool> getDoctorOnboardingComplete() async {
    final _storage = FlutterSecureStorage();
    return await _storage.read(key: 'doctorOnboardingComplete') != null
        ? true
        : false;
  }

  static Future<String?> getPasscode() async {
    final _storage = FlutterSecureStorage();
    return await _storage.read(key: 'passcode');
  }

  static Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(
          url,
          forceSafariVC: true,
        );
      }
    } else {
      throw 'Could not launch $url';
    }
  }

  static void makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> sendDebugMail(String subject, String body) async {
    final String from = 'no-reply@netpeya.com';
    final SmtpServer _server = SmtpServer(
      'smtp.postmarkapp.com',
      port: 587,
      allowInsecure: true,
      username: 'b23b3039-b253-4e00-80a9-710d3c05046e',
      password: 'b23b3039-b253-4e00-80a9-710d3c05046e',
      ignoreBadCertificate: true,
      ssl: false,
    );
    final message = Message()
      ..from = Address(from, 'HealthAtHome Mobile')
      ..recipients = ['ati2ude1@gmail.com']
      ..subject = subject
      ..text = body;

    try {
      await send(message, _server);
    } catch (_err) {
      print("============= mailer failed =============");
      print(_err.toString());
    }
  }
}

enum Mode { LIGHT, DARK }

enum ActiveApp { DOCTOR, PATIENT, GUEST }
