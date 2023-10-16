import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/user/user.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/auth/reset_complete.dart';

import 'login.dart';

class ResetPassword extends StatefulWidget {
  final String? email;

  const ResetPassword({Key? key, this.email}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  ApiProvider apiProvider = new ApiProvider();
  final passwordController = TextEditingController();
  final _passwordFieldKey = GlobalKey<FormFieldState>();
  late bool _showPasswordError = false;
  late String passwordError = ' Password field is required';
  late String error = "";
  bool loading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    App.onAuthPage = false;
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    App.onAuthPage = true;
    super.initState();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/logo_light.svg'),
                    ],
                  ),
                  SizedBox(height: 48),
                  Text(
                    'Reset Password',
                    style: TextStyle(
                      // h5 -> headline

                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      letterSpacing: 0.27,
                      color: App.theme.darkText,
                    ),
                  ),
                  SizedBox(height: 24),
                  if (error.isNotEmpty)
                    Column(
                      children: [
                        Text(
                          error,
                          style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.016, color: Colors.red),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  SizedBox(height: 6),
                  Text(
                    'New Password',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: App.theme.grey600),
                  ),
                  SizedBox(height: 4),
                  TextFormField(
                    style: TextStyle(fontSize: 18, color: App.theme.darkText),
                    controller: passwordController,
                    obscureText: _obscureText,
                    key: _passwordFieldKey,
                    validator: (value) {
                      setState(() {
                        _showPasswordError = false;
                      });
                      if (value!.isEmpty) {
                        setState(() {
                          _showPasswordError = true;
                          passwordError = " Password field is required.";
                        });
                      } else if (value.length < 6 || value.length > 20) {
                        setState(() {
                          _showPasswordError = true;
                          passwordError = " Password must be 6-20 characters.";
                        });
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: _obscureText
                            ? Icon(Icons.visibility_rounded, color: App.theme.mutedLightColor)
                            : Icon(Icons.visibility_off_rounded, color: App.theme.turquoise),
                        onPressed: () => {_toggle()},
                      ),
                      fillColor: App.theme.white,
                      filled: true,
                      hintText: 'Type your password',
                      hintStyle: TextStyle(fontSize: 16, color: App.theme.mutedLightColor),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                  if (_showPasswordError)
                    Column(
                      children: [
                        SizedBox(height: 6),
                        Text(
                          passwordError,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 16),
                  loading
                      ? PrimaryButtonLoading()
                      : PrimaryLargeButton(
                          title: 'Reset Password',
                          iconWidget: SizedBox(),
                          onPressed: () {
                            if (_passwordFieldKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();

                              if (_showPasswordError) return;

                              setState(() {
                                loading = true;
                                apiProvider.resetPassword(passwordController.text).then(
                                  (success) async {
                                    if (success) {
                                      if (widget.email != null) {
                                        bool success = await apiProvider.login(widget.email!, passwordController.value.text);
                                        if (success) {
                                          if (App.currentUser.userType == UserTypes.DOCTOR) {
                                            App.setActiveApp(ActiveApp.DOCTOR);
                                          } else {
                                            App.setActiveApp(ActiveApp.PATIENT);
                                          }
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return ResetComplete();
                                              },
                                            ),
                                          );
                                        }
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ResetComplete();
                                            },
                                          ),
                                        );
                                      }
                                    } else {
                                      setState(
                                        () => {
                                          error = ApiResponse.message,
                                          ApiResponse.message = '',
                                          loading = false,
                                        },
                                      );
                                    }
                                  },
                                );
                              });
                            }
                          },
                        ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: App.isLoggedIn
              ? Container(height: 2)
              : BottomAppBar(
                  color: App.theme.turquoise50,
                  child: Container(
                    margin: EdgeInsets.all(32),
                    child: SecondaryStandardButton(
                        title: 'Login',
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        }),
                  ),
                  elevation: 0,
                )),
    );
  }
}
