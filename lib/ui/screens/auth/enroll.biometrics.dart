import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/user/user.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';
import 'package:mobile/ui/screens/home.dart';

class EnrollBiometrics extends StatefulWidget {
  const EnrollBiometrics({Key? key}) : super(key: key);

  @override
  _EnrollBiometricsState createState() => _EnrollBiometricsState();
}

class _EnrollBiometricsState extends State<EnrollBiometrics> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  final _storage = FlutterSecureStorage();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    App.onAuthPage = true;
    auth.isDeviceSupported().then((isSupported) => {
          setState(() => _supportState = isSupported ? _SupportState.supported : _SupportState.unsupported),
          if (_supportState == _SupportState.unsupported || _supportState == _SupportState.unknown)
            {
              _storage.write(key: 'setupComplete', value: 'yes'),
              App.setupComplete = true,
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => App.currentUser.userType == UserTypes.DOCTOR ? DoctorHome() : Home(0)),
              ),
            },
        });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    App.onAuthPage = false;
    super.dispose();
  }

  Future<void> _authenticateWithBiometrics() async {
    bool isBiometricSupported = await auth.isDeviceSupported();
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    bool authenticated = false;
    if (isBiometricSupported && canCheckBiometrics) {
      try {
        authenticated = await auth.authenticate(
            localizedReason: 'Confirm biometrics to authenticate',
            options: const AuthenticationOptions(
              useErrorDialogs: true,
              stickyAuth: true,
              biometricOnly: true,
            ));
        await auth.stopAuthentication();
      } on PlatformException catch (_err) {
        print(_err.message);
      }
    }
    if (!mounted) return;

    if (authenticated) {
      _storage.write(key: 'biometricsEnrolled', value: 'yes');
      _storage.write(key: 'setupComplete', value: 'yes');
      App.setupComplete = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => App.currentUser.userType == UserTypes.DOCTOR ? DoctorHome() : Home(0)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LightStatusNavigationBarWidget(
        child: Scaffold(
          backgroundColor: App.theme.lightGreyColor,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Use Biometrics',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: App.theme.darkerText,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add more security to your account.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: App.theme.darkText,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [SvgPicture.asset('assets/icons/icon_fingerprint.svg')],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Biometrics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: App.theme.darkText,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Would you like to use your device’s biometrics such as FaceID or fingerprint scanner to sign in?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: App.theme.mutedLightColor,
                    ),
                  ),
                  Spacer(),
                  PrimaryLargeButton(
                    title: 'Yes, Set Up Biometrics',
                    onPressed: () => {_authenticateWithBiometrics()},
                    iconWidget: Container(),
                  ),
                  SizedBox(height: 10),
                  SecondaryLargeButton(
                    title: 'No, Continue',
                    onPressed: () {
                      _storage.write(key: 'setupComplete', value: 'yes');
                      App.setupComplete = true;
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home(0)), (Route<dynamic> route) => false);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
