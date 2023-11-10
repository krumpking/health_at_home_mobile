// ignore_for_file: unused_catch_clause

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/user/user.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/providers/social_auth.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/auth/register.dart';
import 'package:mobile/ui/screens/auth/verify.code.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';
import 'package:mobile/ui/screens/home.dart';
import 'package:validators/validators.dart';

import 'forgot_password.dart';

class Login extends StatefulWidget {
  final bool? goBack;
  const Login({Key? key, this.goBack}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _storage = FlutterSecureStorage();
  SocialAuth _socialAuth = SocialAuth();
  ApiProvider apiProvider = new ApiProvider();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();
  bool loading = false;
  bool googleLoading = false;
  bool appleLoading = false;
  late String error = "";
  final LocalAuthentication auth = LocalAuthentication();
  late bool _showEmailError = false;
  late bool _showPasswordError = false;
  late String emailError = ' Email field is required';
  bool _obscureText = true;
  bool _goBack = true;
  bool _hasBiometrics = false;
  bool _isLocked = App.isLocked;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    App.onAuthPage = false;
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    App.onAuthPage = true;

    setState(() {
      emailController.text =
          User.isAuthentic(App.currentUser) ? App.currentUser.email : '';
      _goBack = (widget.goBack == null || widget.goBack!);
    });
    _initPage();
  }

  Future<void> _initPage() async {
    bool bio = await App.getBiometricsSet();
    setState(() {
      _hasBiometrics = bio;
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    bool isBiometricSupported = await auth.isDeviceSupported();
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    bool authenticated = false;
    if (isBiometricSupported && canCheckBiometrics && !loading) {
      try {
        authenticated = await auth.authenticate(
            localizedReason: 'Confirm biometrics to authenticate',
            options: const AuthenticationOptions(
              useErrorDialogs: true,
              stickyAuth: true,
              biometricOnly: true,
            ));
      } on PlatformException catch (e) {
        setState(() {
          loading = false;
          googleLoading = false;
        });
      }
    }
    if (!mounted) return;

    if (authenticated) {
      await auth.stopAuthentication();
      _loginByUuid(App.currentUser.uuid);
    } else {
      setState(() {
        loading = false;
        googleLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
        child: LightStatusNavigationBarWidget(
          child: Scaffold(
              backgroundColor: App.theme.turquoise50,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/logo_light.svg',
                                height: 60),
                          ],
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: App.theme.darkerText,
                          ),
                        ),
                        SizedBox(height: 24),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (error.isNotEmpty)
                                Column(
                                  children: [
                                    Text(
                                      error,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.016,
                                          color: Colors.red),
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              Text(
                                'Email Address',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: App.theme.grey600),
                              ),
                              SizedBox(height: 4),
                              TextFormField(
                                style: TextStyle(
                                    fontSize: 18, color: App.theme.darkText),
                                controller: emailController,
                                key: _emailFieldKey,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  setState(() {
                                    emailError = " Field Required";
                                    _showEmailError = false;
                                  });
                                  if (value!.isEmpty || !isEmail(value)) {
                                    setState(() {
                                      _showEmailError = true;
                                    });
                                  }

                                  if (value.isNotEmpty && !isEmail(value)) {
                                    setState(() {
                                      emailError = " Enter a valid email";
                                    });
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  fillColor: App.theme.white,
                                  filled: true,
                                  hintText: 'john.doe@gmail.com',
                                  hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: App.theme.mutedLightColor),
                                  contentPadding:
                                      EdgeInsets.only(left: 15, right: 15),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF94A3B8), width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF94A3B8), width: 1.0),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF94A3B8), width: 1.0),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                              ),
                              if (_showEmailError)
                                Column(
                                  children: [
                                    SizedBox(height: 6),
                                    Text(
                                      emailError,
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
                              Text(
                                'Password',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: App.theme.grey600),
                              ),
                              SizedBox(height: 4),
                              TextFormField(
                                style: TextStyle(
                                    fontSize: 18, color: App.theme.darkText),
                                controller: passwordController,
                                key: _passwordFieldKey,
                                obscureText: _obscureText,
                                validator: (value) {
                                  setState(() {
                                    _showPasswordError = false;
                                  });
                                  if (value!.isEmpty) {
                                    setState(() {
                                      _showPasswordError = true;
                                    });
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: _obscureText
                                        ? Icon(Icons.visibility_rounded,
                                            color: App.theme.mutedLightColor)
                                        : Icon(Icons.visibility_off_rounded,
                                            color: App.theme.turquoise),
                                    onPressed: () => {_toggle()},
                                  ),
                                  fillColor: App.theme.white,
                                  filled: true,
                                  hintText: 'Input text here',
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: App.theme.mutedLightColor),
                                  contentPadding:
                                      EdgeInsets.only(left: 15, right: 15),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF94A3B8), width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF94A3B8), width: 1.0),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF94A3B8), width: 1.0),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                              ),
                              if (_showPasswordError)
                                Column(
                                  children: [
                                    SizedBox(height: 6),
                                    Text(
                                      " Password field is required",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: loading
                                          ? PrimaryButtonLoading()
                                          : PrimaryLargeButton(
                                              title: 'Log In',
                                              onPressed: () async {
                                                if (_emailFieldKey.currentState!
                                                        .validate() &&
                                                    _passwordFieldKey
                                                        .currentState!
                                                        .validate()) {
                                                  FocusScope.of(context)
                                                      .unfocus();

                                                  if (_showEmailError ||
                                                      _showPasswordError)
                                                    return;
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  try {
                                                    var success =
                                                        await apiProvider.login(
                                                            emailController
                                                                .text,
                                                            passwordController
                                                                .text,
                                                            context);
                                                    if (success) {
                                                      _storage.write(
                                                          key: 'isLoggedIn',
                                                          value: '1');

                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              (App.currentUser
                                                                          .userType ==
                                                                      UserTypes
                                                                          .DOCTOR
                                                                  ? DoctorHome()
                                                                  : Home(0)),
                                                        ),
                                                      );
                                                    } else {
                                                      setState(
                                                        () => {
                                                          error = ApiResponse
                                                              .message,
                                                          ApiResponse.message =
                                                              '',
                                                          loading = false,
                                                        },
                                                      );
                                                    }
                                                  } catch (_error, stack) {
                                                    setState(
                                                      () => {
                                                        error = _error
                                                                .toString() +
                                                            "\n" +
                                                            stack.toString(),
                                                        ApiResponse.message =
                                                            '',
                                                        loading = false,
                                                      },
                                                    );
                                                  }
                                                }
                                              },
                                              iconWidget: Container(),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Forgot your Password?',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: App.theme.grey600),
                                    ),
                                    GestureDetector(
                                      child: Text(
                                        'Reset Password',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color: App.theme.orange,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ForgotPassword();
                                        }));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                color: App.theme.turquoise50,
                child: Container(
                  margin: EdgeInsets.all(16),
                  child: SecondaryLargeButton(
                      title: 'Create an Account',
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Register();
                        }));
                      }),
                ),
                elevation: 0,
              )),
        ),
        onWillPop: () async => _goBack);
  }

  Future<void> _loginByUuid(String uuid) async {
    setState(() {
      loading = true;
    });
    var success = await apiProvider.loginWithUUID(uuid);
    if (success) {
      _storage.write(key: 'isLoggedIn', value: '1');
      if (App.currentUser.userType == UserTypes.DOCTOR) {
        App.setActiveApp(ActiveApp.DOCTOR);
      } else {
        App.setActiveApp(ActiveApp.PATIENT);
      }
      if (!App.setupComplete) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => (App.currentUser.userType == UserTypes.DOCTOR
                ? DoctorHome()
                : Home(0)),
          ),
        );
      } else {
        if (User.isAuthentic(App.currentUser) && !App.currentUser.isActive) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyCode(uuid: App.currentUser.uuid)),
          );
          return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => App.currentUser.userType == UserTypes.DOCTOR
                  ? DoctorHome()
                  : Home(0)),
        );
      }
    } else {
      setState(() {
        error = ApiResponse.message;
        ApiResponse.message = '';
      });
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> _loginByEmail(String email, String displayName) async {
    setState(() {
      loading = true;
    });
    var firstName = displayName.split(' ')[0];
    var lastName = displayName.split(' ')[1];
    bool emailAvailable = await apiProvider.checkEmail(email);
    if (emailAvailable) {
      _socialAuth.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Register(email: email);
      }));
    } else {
      var success =
          await apiProvider.loginWithSocial(email, firstName, lastName);
      if (success) {
        _storage.write(key: 'isLoggedIn', value: '1');
        if (App.currentUser.userType == UserTypes.DOCTOR) {
          App.setActiveApp(ActiveApp.DOCTOR);
        } else {
          App.setActiveApp(ActiveApp.PATIENT);
        }

        if (User.isAuthentic(App.currentUser) && !App.currentUser.isActive) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyCode(uuid: App.currentUser.uuid)),
          );
          return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => App.currentUser.userType == UserTypes.DOCTOR
                  ? DoctorHome()
                  : Home(0)),
        );
      } else {
        setState(() {
          error = ApiResponse.message;
          ApiResponse.message = '';
        });
      }
    }
    setState(() {
      loading = false;
    });
  }
}
