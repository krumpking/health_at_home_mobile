import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/auth/register_phone.dart';

import 'login.dart';

class RegisterDetails extends StatefulWidget {
  const RegisterDetails({Key? key}) : super(key: key);

  @override
  _RegisterDetailsState createState() => _RegisterDetailsState();
}

class _RegisterDetailsState extends State<RegisterDetails> {
  ApiProvider apiProvider = new ApiProvider();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _firstNameFieldKey = GlobalKey<FormFieldState>();
  final _lastNameFieldKey = GlobalKey<FormFieldState>();
  bool loading = false;
  late String error = "";
  late bool _showDobError = false;
  late bool _showGenderError = false;
  late bool _showFirstNameError = false;
  late bool _showLastNameError = false;
  late String genderError = '';
  late String firstNameError = ' First Name is required';
  late String lastNameError = ' Last Name is required';
  DateTime today = DateTime.now();
  DateTime selectedDate = DateTime.now();

  String _genderHint = 'Select';
  late String _gender = '';
  late String _dob = '';
  List<String> gender = ['Male', 'Female'];

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    App.onAuthPage = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    App.onAuthPage = true;
    selectedDate = new DateTime(today.year - 16, today.month, today.day);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: new DateTime(today.year - 100, today.month, today.day),
      lastDate: new DateTime(today.year - 16, today.month, today.day),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primaryColor: App.theme.turquoise!,
            colorScheme: ColorScheme.light(primary: App.theme.turquoise!),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dob = DateFormat.y().format(selectedDate) + '-' + DateFormat.M().format(selectedDate) + '-' + DateFormat.d().format(selectedDate);
      });
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
                                    'First Name',
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
                                          controller: firstNameController,
                                          key: _firstNameFieldKey,
                                          validator: (value) {
                                            setState(() {
                                              _showFirstNameError = false;
                                            });
                                            if (value!.isEmpty) {
                                              setState(() {
                                                _showFirstNameError = true;
                                                firstNameError = " First Name is required.";
                                              });
                                            } else {
                                              RegExp regex = new RegExp(r'[a-zA-Z]');
                                              if (!regex.hasMatch(value)) {
                                                setState(() {
                                                  _showFirstNameError = true;
                                                  firstNameError = 'First Name must contain letters only';
                                                });
                                                return;
                                              }

                                              if (value.length < 2 || value.length > 50) {
                                                setState(() {
                                                  _showFirstNameError = true;
                                                  firstNameError = " First Name must be two or more characters.";
                                                });
                                              }
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            fillColor: App.theme.white,
                                            filled: true,
                                            hintText: 'John',
                                            hintStyle: TextStyle(fontSize: 15, color: App.theme.mutedLightColor),
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
                                        if (_showFirstNameError)
                                          Column(
                                            children: [
                                              SizedBox(height: 6),
                                              Text(
                                                firstNameError,
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
                                          'Last Name',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: App.theme.grey600),
                                        ),
                                        SizedBox(height: 4),
                                        TextFormField(
                                          style: TextStyle(fontSize: 18, color: App.theme.darkText),
                                          controller: lastNameController,
                                          key: _lastNameFieldKey,
                                          validator: (value) {
                                            setState(() {
                                              _showLastNameError = false;
                                            });
                                            if (value!.isEmpty) {
                                              setState(() {
                                                _showLastNameError = true;
                                                lastNameError = " Last Name is required.";
                                              });
                                            } else {
                                              RegExp regex = new RegExp(r'[a-zA-Z]');
                                              if (!regex.hasMatch(value)) {
                                                setState(() {
                                                  _showLastNameError = true;
                                                  lastNameError = 'Last Name must contain letters only';
                                                });
                                                return;
                                              }

                                              if (value.length < 2 || value.length > 50) {
                                                setState(() {
                                                  _showLastNameError = true;
                                                  lastNameError = " Last Name must be two or more characters.";
                                                });
                                              }
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            fillColor: App.theme.white,
                                            filled: true,
                                            hintText: 'Doe',
                                            hintStyle: TextStyle(fontSize: 15, color: App.theme.mutedLightColor),
                                            contentPadding: EdgeInsets.only(left: 15, right: 15),
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
                                        if (_showLastNameError)
                                          Column(
                                            children: [
                                              SizedBox(height: 6),
                                              Text(
                                                lastNameError,
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
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'D.O.B.',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: App.theme.grey600),
                                            ),
                                            SizedBox(height: 8),
                                            GestureDetector(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12.0),
                                                      decoration: BoxDecoration(
                                                        color: App.theme.white,
                                                        borderRadius: BorderRadius.circular(12.0),
                                                        border: Border.all(color: App.theme.grey300!, style: BorderStyle.solid, width: 0.1),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(_dob.isEmpty ? 'Select' : "${selectedDate.toLocal()}".split(' ')[0],
                                                              style: TextStyle(fontSize: 16, color: App.theme.mutedLightColor)),
                                                          SvgPicture.asset('assets/icons/icon_calendar.svg'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                _selectDate(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Sex',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: App.theme.grey600),
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                                                    decoration: BoxDecoration(
                                                      color: App.theme.white,
                                                      borderRadius: BorderRadius.circular(12.0),
                                                      border: Border.all(color: (App.theme.white)!, style: BorderStyle.solid, width: 0.1),
                                                    ),
                                                    child: DropdownButton(
                                                      isDense: false,
                                                      dropdownColor: App.theme.white,
                                                      underline: SizedBox(),
                                                      items: gender
                                                          .map((value) => DropdownMenuItem(
                                                                child: Text(value, style: TextStyle(fontSize: 14, color: App.theme.grey800)),
                                                                value: value,
                                                              ))
                                                          .toList(),
                                                      isExpanded: true,
                                                      icon: SvgPicture.asset('assets/icons/icon_down_caret.svg', color: App.theme.turquoise),
                                                      hint: Row(
                                                        children: [
                                                          Text(_genderHint, style: TextStyle(fontSize: 16, color: App.theme.grey600)),
                                                        ],
                                                      ),
                                                      onChanged: (String? value) {
                                                        _genderHint = value!;
                                                        setState(() {
                                                          _genderHint = value;
                                                          _gender = value == 'Select' ? '' : value;
                                                        });
                                                      },
                                                      // value: _dropdownValues.first,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (_showDobError)
                                        Container(
                                          width: MediaQuery.of(context).size.width / 2 - 24,
                                          child: Text(
                                            " DOB is required",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      if (_showGenderError)
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 6),
                                          width: MediaQuery.of(context).size.width / 2 - 24,
                                          child: Text(
                                            " Sex is required",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  PrimaryLargeButton(
                                    title: 'Next',
                                    onPressed: () {
                                      if (_firstNameFieldKey.currentState!.validate() && _lastNameFieldKey.currentState!.validate()) {
                                        FocusScope.of(context).unfocus();
                                        setState(() {
                                          loading = true;
                                          _showDobError = false;
                                          _showGenderError = false;
                                        });

                                        App.signUpUser!.firstName = firstNameController.value.text;
                                        App.signUpUser!.lastName = lastNameController.value.text;

                                        if (_dob.isEmpty) {
                                          setState(() {
                                            _showDobError = true;
                                          });
                                        }

                                        if (_gender.isEmpty) {
                                          setState(() {
                                            _showGenderError = true;
                                          });
                                        }

                                        if (_showGenderError || _showDobError || _showFirstNameError || _showLastNameError) return;

                                        App.signUpUser!.firstName = firstNameController.value.text;
                                        App.signUpUser!.lastName = lastNameController.value.text;
                                        App.signUpUser!.dob = _dob;
                                        App.signUpUser!.gender = _gender;
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return RegisterPhone();
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
