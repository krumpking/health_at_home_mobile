import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/auth/register_details.dart';
import 'package:validators/validators.dart';

import 'login.dart';

class Register extends StatefulWidget {
  final String? email;
  const Register({Key? key, this.email}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  ApiProvider apiProvider = new ApiProvider();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();
  late bool _showEmailError = false;
  late bool _showPasswordError = false;
  late String error = "";
  late String emailError = ' Email is required';
  late String passwordError = ' Password is required';
  bool _obscureText = true;
  bool _loading = false;

  @override
  void dispose() {
    App.onAuthPage = false;
    emailController.dispose();
    passwordController.dispose();
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

    if (widget.email != null && widget.email!.isNotEmpty) {
      setState(() {
        emailController.text = widget.email!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return LightStatusNavigationBarWidget(
      child: Scaffold(
          backgroundColor: App.theme.turquoise50,
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16, top: 16, right: 16),
                  decoration: BoxDecoration(
                    color: App.theme.turquoise50,
                  ),
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
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      height: height,
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
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
                            'Patient Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
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
                                          style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.016, color: Colors.red),
                                        ),
                                        SizedBox(height: 16),
                                      ],
                                    ),
                                  Text(
                                    'Email Address',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: App.theme.grey600),
                                  ),
                                  SizedBox(height: 4),
                                  Form(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          style: TextStyle(fontSize: 18, color: App.theme.darkText),
                                          controller: emailController,
                                          key: _emailFieldKey,
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
                                                _showEmailError = true;
                                              });
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            fillColor: App.theme.white,
                                            filled: true,
                                            hintText: 'john.doe@gmail.com',
                                            hintStyle: TextStyle(fontSize: 18, color: App.theme.mutedLightColor),
                                            contentPadding: EdgeInsets.only(left: 15, right: 15),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0),
                                                borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                            errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.red, width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0),
                                                borderRadius: BorderRadius.circular(10.0)),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0),
                                                borderRadius: BorderRadius.circular(10.0)),
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
                                          'Create Password',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: App.theme.grey600),
                                        ),
                                        SizedBox(height: 4),
                                        TextFormField(
                                          style: TextStyle(fontSize: 18, color: App.theme.darkText),
                                          controller: passwordController,
                                          obscureText: _obscureText,
                                          autofocus: (widget.email != null && widget.email!.isNotEmpty),
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
                                                borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0),
                                                borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0),
                                                borderRadius: BorderRadius.circular(10.0)),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0),
                                                borderRadius: BorderRadius.circular(10.0)),
                                          ),
                                        ),
                                      ],
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
                                  SizedBox(height: 24),
                                  _loading
                                      ? PrimaryButtonLoading()
                                      : PrimaryLargeButton(
                                          title: 'Sign Up',
                                          onPressed: () async {
                                            if (_emailFieldKey.currentState!.validate() && _passwordFieldKey.currentState!.validate()) {
                                              FocusScope.of(context).unfocus();
                                              setState(() {
                                                _loading = true;
                                              });
                                              if (_showEmailError) {
                                                setState(() {
                                                  _loading = false;
                                                });
                                                return;
                                              }
                                              bool emailAvailable = await apiProvider.checkEmail(emailController.value.text);
                                              if (!emailAvailable) {
                                                setState(() {
                                                  _showEmailError = true;
                                                  emailError = "Email already taken";
                                                  _loading = false;
                                                });
                                              } else {
                                                setState(() {
                                                  _showEmailError = false;
                                                });
                                              }

                                              if (_showEmailError || _showPasswordError) {
                                                setState(() {
                                                  _loading = false;
                                                });
                                                return;
                                              }

                                              App.signUpUser!.email = emailController.value.text;
                                              App.signUpUser!.password = passwordController.value.text;
                                              setState(() {
                                                _loading = false;
                                              });
                                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                return RegisterDetails();
                                              }));
                                            }
                                          },
                                          iconWidget: Container(),
                                        ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: App.theme.turquoise50,
            child: Container(
              margin: EdgeInsets.all(32),
              child: SecondaryLargeButton(
                  title: 'Login',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Login();
                    }));
                  }),
            ),
            elevation: 0,
          )),
    );
  }
}
