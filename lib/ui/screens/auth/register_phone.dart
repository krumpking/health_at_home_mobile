import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/auth/verify.code.dart';

import 'login.dart';

class RegisterPhone extends StatefulWidget {
  const RegisterPhone({Key? key}) : super(key: key);

  @override
  _RegisterPhoneState createState() => _RegisterPhoneState();
}

class _RegisterPhoneState extends State<RegisterPhone> {
  ApiProvider apiProvider = new ApiProvider();
  final phoneController = TextEditingController();
  final _phoneCodeFieldKey = GlobalKey<FormFieldState>();
  final _phoneFieldKey = GlobalKey<FormFieldState>();
  late String error = "";
  late String phoneCode = "+263";
  late String _phoneError = ' Phone number is required';
  late bool _showPhoneCodeError = false;
  late bool _showPhoneError = false;
  late bool _loading = false;

  @override
  void dispose() {
    phoneController.dispose();
    App.onAuthPage = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    App.onAuthPage = true;
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
                            'Phone Number',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: App.theme.grey600),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: App.theme.white,
                                  border: Border.all(color: Color(0xFF94A3B8), width: 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: CountryCodePicker(
                                  onChanged: (CountryCode countryCode) {
                                    setState(() {
                                      phoneCode = countryCode.toString();
                                    });
                                    print("===================");
                                    print(countryCode.toString());
                                  },
                                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                  initialSelection: 'ZW',
                                  favorite: ['UK'],
                                  // optional. Shows only country name and flag
                                  showCountryOnly: false,
                                  // optional. Shows only country name and flag when popup is closed.
                                  showOnlyCountryWhenClosed: false,
                                  // optional. aligns the flag and the Text left
                                  alignLeft: false,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.01,
                              ),
                              Container(
                                child: Expanded(
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 18, color: App.theme.darkText),
                                    controller: phoneController,
                                    key: _phoneFieldKey,
                                    validator: (value) {
                                      setState(() {
                                        _showPhoneError = false;
                                      });
                                      if (value!.isEmpty) {
                                        setState(() {
                                          _showPhoneError = true;
                                          _phoneError = "Phone number is required";
                                        });
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      fillColor: App.theme.white,
                                      filled: true,
                                      hintText: '712345678',
                                      hintStyle: TextStyle(fontSize: 18, color: App.theme.mutedLightColor),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                      errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red, width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF94A3B8), width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          if (_showPhoneError || _showPhoneCodeError)
                            Column(
                              children: [
                                SizedBox(height: 6),
                                Text(
                                  " $_phoneError",
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
                                  title: 'Complete Account',
                                  onPressed: () {
                                    if (phoneCode.isNotEmpty && _phoneFieldKey.currentState!.validate()) {
                                      FocusScope.of(context).unfocus();

                                      setState(() {
                                        _loading = true;
                                      });

                                      if (phoneCode.isEmpty) {
                                        setState(() {
                                          _showPhoneCodeError = true;
                                          error = "Phone code is required";
                                        });
                                      }

                                      if (_showPhoneError || _showPhoneCodeError) {
                                        _loading = false;
                                        return;
                                      }

                                      App.signUpUser!.phone = phoneController.value.text;
                                      App.signUpUser!.phoneCode = phoneCode;

                                      try {
                                        apiProvider.register().then(
                                          (uuid) async {
                                            if (uuid != null) {
                                              bool success = await apiProvider.login(App.signUpUser!.email, App.signUpUser!.password);
                                              if (success) {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => VerifyCode(uuid: uuid)),
                                                );
                                              }
                                            } else {
                                              setState(
                                                () => {
                                                  error = ApiResponse.message,
                                                  _loading = false,
                                                },
                                              );
                                            }
                                          },
                                        );
                                      } catch (err) {
                                        setState(() {
                                          _loading = false;
                                          error = "Failed, please try again";
                                        });
                                      }

                                      // Navigator.push(context,
                                      //     MaterialPageRoute(builder: (context) {
                                      //       return RegisterDetails();
                                      //     }));
                                    }
                                  },
                                  iconWidget: Container(),
                                ),
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
              child: SecondaryStandardButton(
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
