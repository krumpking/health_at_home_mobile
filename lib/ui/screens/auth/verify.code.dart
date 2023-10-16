import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/user/user.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';

import '../home.dart';

class VerifyCode extends StatefulWidget {
  final String uuid;
  final bool? goBack;
  const VerifyCode({Key? key, required this.uuid, this.goBack}) : super(key: key);

  @override
  _VerifyCodeState createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  ApiProvider apiProvider = new ApiProvider();
  final codeController = TextEditingController();
  final _codeFieldKey = GlobalKey<FormFieldState>();
  late bool _showCodeError = false;
  late String error = "";
  late String codeError = ' Activation code is required';
  late bool _loading = false;
  late bool loading = false;
  late bool _resendSuccess = false;

  @override
  void initState() {
    App.onAuthPage = true;
    App.resumed = false;
    super.initState();
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: LightStatusNavigationBarWidget(
          child: Scaffold(
            backgroundColor: App.theme.lightGreyColor,
            body: SafeArea(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/icons/logo_light.svg'),
                              ],
                            ),
                            SizedBox(height: 48),
                            Text(
                              'Activate your Account',
                              style: TextStyle(
                                // h5 -> headline

                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                letterSpacing: 0.27,
                                color: App.theme.darkText,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'We have sent an email with a six digit activation code to your inbox. Please provide the code to activate your account.',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: App.theme.mutedLightColor,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Please make sure to check other email folders if you don\'t see it the first time.',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: App.theme.red,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Activation Code',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: App.theme.darkGrey),
                            ),
                            SizedBox(height: 6),
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
                            Form(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    key: _codeFieldKey,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: App.theme.darkText,
                                      letterSpacing: 2.0,
                                    ),
                                    controller: codeController,
                                    validator: (value) {
                                      setState(() {
                                        _showCodeError = false;
                                      });
                                      if (value!.isEmpty) {
                                        setState(() {
                                          _showCodeError = true;
                                        });
                                      } else {
                                        if (num.tryParse(value) == null) {
                                          setState(() {
                                            codeError = ' Code must be numbers only';
                                            _showCodeError = true;
                                          });
                                        } else if (value.length != 6) {
                                          setState(() {
                                            codeError = ' Enter a valid 6 digit activation code';
                                            _showCodeError = true;
                                          });
                                        }
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.go,
                                    onFieldSubmitted: (newThingTitle) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    decoration: InputDecoration(
                                      fillColor: App.theme.white,
                                      filled: true,
                                      hintText: 'Enter code',
                                      hintStyle: TextStyle(fontSize: 15, color: App.theme.mutedLightColor),
                                      contentPadding: EdgeInsets.only(left: 15, right: 15),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                                    ),
                                  ),
                                  if (_showCodeError)
                                    Column(
                                      children: [
                                        SizedBox(height: 6),
                                        Text(
                                          codeError,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                            GestureDetector(
                              child: Row(
                                children: [
                                  Text(
                                    'Re-send Code',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: App.theme.orange,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  if (loading)
                                    SizedBox(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(App.theme.green!),
                                        strokeWidth: 2,
                                      ),
                                      height: 14,
                                      width: 14,
                                    ),
                                  if (!loading && _resendSuccess)
                                    Icon(
                                      Icons.check,
                                      color: App.theme.green,
                                    )
                                ],
                              ),
                              onTap: () async {
                                setState(() {
                                  error = '';
                                  loading = true;
                                });
                                String? uuid = (widget.uuid != null) ? widget.uuid : App.currentUser.uuid;
                                if (uuid != null) {
                                  App.signUpUser!.uuid = uuid;
                                  App.signUpUser!.purpose = 1;
                                  String? dbUuid = await apiProvider.resendRegistrationCode(uuid);
                                  if (dbUuid != null) {
                                    setState(() {
                                      loading = false;
                                      _resendSuccess = true;
                                    });
                                  } else {
                                    setState(
                                      () {
                                        error = ApiResponse.message;
                                        ApiResponse.message = '';
                                        loading = false;
                                      },
                                    );
                                  }
                                } else {
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: App.theme.turquoise50,
              child: Container(
                margin: EdgeInsets.all(32),
                color: App.theme.turquoise50,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _loading
                        ? PrimaryButtonLoading()
                        : PrimaryLargeButton(
                            title: 'Verify Code',
                            iconWidget: SizedBox(),
                            onPressed: () {
                              setState(() {
                                _loading = true;
                              });
                              if (_codeFieldKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();

                                if (_showCodeError) {
                                  setState(() {
                                    _loading = false;
                                  });
                                  return;
                                }

                                try {
                                  apiProvider.verifyCode(codeController.value.text, widget.uuid, 1).then((success) async {
                                    if (success) {
                                      apiProvider.loginWithUUID(widget.uuid).then((value) {
                                        Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) => App.currentUser.userType == UserTypes.DOCTOR ? DoctorHome() : Home(0),
                                          ),
                                          (Route<dynamic> route) => false,
                                        );
                                      });
                                    } else {
                                      setState(() {
                                        _loading = false;
                                        error = ApiResponse.message;
                                        ApiResponse.message = '';
                                      });
                                    }
                                  });
                                } catch (err) {
                                  setState(() {
                                    _loading = false;
                                    error = "Something went wrong, please try again.";
                                  });
                                }
                              } else {
                                setState(() {
                                  _loading = false;
                                });
                              }
                            }),
                  ],
                ),
              ),
              elevation: 0,
            ),
          ),
        ),
        onWillPop: () async => false);
  }
}
