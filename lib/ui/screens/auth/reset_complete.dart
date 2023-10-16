import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/user/user.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';

import '../home.dart';
import 'login.dart';

class ResetComplete extends StatefulWidget {
  final String? email;
  final String? password;
  const ResetComplete({Key? key, this.email, this.password}) : super(key: key);

  @override
  _ResetCompleteState createState() => _ResetCompleteState();
}

class _ResetCompleteState extends State<ResetComplete> {
  @override
  void dispose() {
    App.onAuthPage = false;
    super.dispose();
  }

  @override
  void initState() {
    App.onAuthPage = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.lightGreyColor,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/icon_big_check.svg',
                      height: 80,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Password Reset Successful!',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 23,
                        color: App.theme.grey900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Text(
                  'Your password has been updated successfully. Remember to use the new password when signing into the app',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: App.theme.mutedLightColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: App.theme.turquoise50,
          child: Container(
              margin: EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  App.isLoggedIn
                      ? PrimaryLargeButton(
                          title: 'Go to Home',
                          iconWidget: SizedBox(),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => App.currentUser.userType == UserTypes.DOCTOR ? DoctorHome() : Home(0)),
                            );
                          },
                        )
                      : PrimaryLargeButton(
                          title: 'Login',
                          iconWidget: SizedBox(),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                        ),
                ],
              )),
          elevation: 0,
        ),
      ),
    );
  }
}
