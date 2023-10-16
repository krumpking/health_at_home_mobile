import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/auth/reset_password_link.dart';
import 'package:validators/validators.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  ApiProvider apiProvider = new ApiProvider();
  final emailController = TextEditingController();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  late bool _showEmailError = false;
  late String emailError = ' Email field is required';
  late String error = "";
  bool loading = false;

  @override
  void initState() {
    super.initState();
    App.onAuthPage = true;
  }

  @override
  void dispose() {
    App.onAuthPage = false;
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.lightGreyColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/logo_light.svg'),
                    ],
                  ),
                  SizedBox(height: 48),
                  Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      letterSpacing: 0.27,
                      color: App.theme.darkText,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'You’ll receive an email with password reset code within 1-2 minutes if an account is linked to this address.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: App.theme.mutedLightColor,
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
                    'Email Address',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: App.theme.grey600),
                  ),
                  SizedBox(height: 4),
                  TextFormField(
                    style: TextStyle(fontSize: 16, color: App.theme.darkText),
                    controller: emailController,
                    key: _emailFieldKey,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      setState(() {
                        _showEmailError = false;
                      });
                      if (value!.isEmpty || !isEmail(value)) {
                        setState(() {
                          emailError = " Email field is required";
                          _showEmailError = true;
                        });
                      }

                      if (value.isNotEmpty && !isEmail(value)) {
                        setState(() {
                          _showEmailError = true;
                          emailError = " Enter a valid email";
                        });
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        fillColor: App.theme.white,
                        filled: true,
                        hintText: 'john.doe@gmail.com',
                        hintStyle: TextStyle(fontSize: 16, color: App.theme.mutedLightColor),
                        contentPadding: EdgeInsets.only(left: 15, right: 15),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0), borderRadius: BorderRadius.circular(10.0))),
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
                  SizedBox(height: 24),
                  loading
                      ? PrimaryButtonLoading()
                      : PrimaryLargeButton(
                          title: 'Submit',
                          iconWidget: SizedBox(),
                          onPressed: () async {
                            if (_emailFieldKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();

                              if (_showEmailError) return;

                              setState(() {
                                loading = true;
                              });
                              var uuid = await apiProvider.forgotPassword(emailController.text);
                              if (uuid != null) {
                                loading = false;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ResetPasswordLink(email: emailController.text, uuid: uuid);
                                    },
                                  ),
                                );
                              } else {
                                setState(() => {
                                      error = ApiResponse.message,
                                      ApiResponse.message = '',
                                      loading = false,
                                    });
                              }
                            }
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: App.theme.turquoise50,
          child: Container(
            margin: EdgeInsets.all(24),
            child: SecondaryStandardButton(
              title: 'Login',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
