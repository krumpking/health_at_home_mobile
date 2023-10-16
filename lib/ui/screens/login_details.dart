// ignore_for_file: unused_catch_clause

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/auth/reset_password.dart';

import '../../providers/api_response.dart';
import '../partials/button.dart';

class LoginDetails extends StatefulWidget {
  final bool? goBack;
  const LoginDetails({Key? key, this.goBack}) : super(key: key);

  @override
  _LoginDetailsState createState() => _LoginDetailsState();
}

class _LoginDetailsState extends State<LoginDetails> {
  ApiProvider apiProvider = new ApiProvider();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  bool googleLoading = false;
  bool appleLoading = false;
  late String error = "";
  final LocalAuthentication auth = LocalAuthentication();
  late String emailError = ' Email field is required';
  bool _goBack = true;
  ActiveApp _activeApp = App.activeApp;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    App.onAuthPage = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_activeApp == ActiveApp.DOCTOR) {
      return DarkStatusNavigationBarWidget(
        child: getContent(),
      );
    } else {
      return LightStatusNavigationBarWidget(
        child: getContent(),
      );
    }
  }

  Widget getContent() {
    return Scaffold(
      backgroundColor: _activeApp == ActiveApp.DOCTOR ? App.theme.darkBackground : App.theme.turquoise50,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (_goBack)
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: App.theme.turquoise,
                                size: 24,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                SizedBox(height: 24),
                Text(
                  'Login Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: _activeApp == ActiveApp.DOCTOR ? App.theme.white : App.theme.darkText,
                  ),
                ),
                SizedBox(height: 24),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _activeApp == ActiveApp.DOCTOR ? App.theme.white : App.theme.darkText,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        App.currentUser.email,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: App.theme.lightText,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    //
                  },
                ),
                Divider(color: _activeApp == ActiveApp.DOCTOR ? App.theme.white : App.theme.darkText),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _activeApp == ActiveApp.DOCTOR ? App.theme.white : App.theme.darkText,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '************',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: App.theme.lightText,
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    "Change",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: App.theme.turquoise,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ResetPassword();
                      }),
                    );
                  },
                ),
                Divider(color: _activeApp == ActiveApp.DOCTOR ? App.theme.white : App.theme.darkText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
