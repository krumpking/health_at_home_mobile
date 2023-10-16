import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/auth/reset_password.dart';

class ResetPasswordLink extends StatefulWidget {
  final String uuid;
  final String email;

  const ResetPasswordLink({Key? key, required this.email, required this.uuid}) : super(key: key);

  @override
  _ResetPasswordLinkState createState() => _ResetPasswordLinkState();
}

class _ResetPasswordLinkState extends State<ResetPasswordLink> {
  ApiProvider apiProvider = new ApiProvider();
  final codeController = TextEditingController();
  final _codeFieldKey = GlobalKey<FormFieldState>();
  late bool _showCodeError = false;
  late String error = "";
  late String codeError = ' Field Required';
  late bool _loading = false;
  late bool loading = false;
  late bool _resendSuccess = false;

  @override
  void dispose() {
    codeController.dispose();
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
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/logo_light.svg'),
                  ],
                ),
                SizedBox(height: 48),
                Text(
                  'Check your Inbox',
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
                  'We have sent an email with a six digit code to your inbox. Please provide the code to reset your password.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: App.theme.mutedLightColor,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Verification Code',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: App.theme.grey600),
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
                TextFormField(
                  style: TextStyle(fontSize: 18, color: App.theme.darkText),
                  controller: codeController,
                  key: _codeFieldKey,
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
                  textInputAction: TextInputAction.done,
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
                        borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0), borderRadius: BorderRadius.circular(10.0)),
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
                      loading = true;
                    });
                    if (widget.email != null) {
                      var uuid = await apiProvider.forgotPassword(widget.email!);
                      if (uuid != null) {
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
                        loading = true;
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: App.theme.turquoise50,
          child: Container(
            margin: EdgeInsets.all(32),
            child: _loading
                ? PrimaryButtonLoading()
                : PrimaryLargeButton(
                    title: 'Verify Code',
                    iconWidget: SizedBox(),
                    onPressed: () {
                      setState(
                        () {
                          _loading = true;
                        },
                      );
                      if (_codeFieldKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();

                        if (_showCodeError) {
                          _loading = false;
                          return;
                        }

                        try {
                          apiProvider.verifyCode(codeController.value.text, widget.uuid, 2).then((success) {
                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => ResetPassword(email: widget.email)),
                              );
                            } else {
                              setState(() {
                                _loading = false;
                                error = ApiResponse.message;
                              });
                            }
                            ApiResponse.message = '';
                          });
                        } catch (err) {
                          setState(
                            () {
                              _loading = false;
                              error = "Something went wrong, please try again.";
                            },
                          );
                        }
                      } else {
                        setState(
                          () {
                            _loading = false;
                          },
                        );
                      }
                    },
                  ),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
