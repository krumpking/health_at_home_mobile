import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/contact_us.dart';
import 'package:mobile/ui/screens/home.dart';

class PatientMedicalProfilePersonalDetails extends StatefulWidget {
  const PatientMedicalProfilePersonalDetails({Key? key}) : super(key: key);

  @override
  _PatientMedicalProfilePersonalDetailsState createState() => _PatientMedicalProfilePersonalDetailsState();
}

class _PatientMedicalProfilePersonalDetailsState extends State<PatientMedicalProfilePersonalDetails> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final countryCodeController = TextEditingController();
  final _phoneCodeFieldKey = GlobalKey<FormFieldState>();
  final _phoneFieldKey = GlobalKey<FormFieldState>();
  late String _phoneError = 'Field Required';
  late bool _showPhoneCodeError = false;
  late bool _showPhoneError = false;
  late String _error = '';

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    phoneNumberController.text = App.currentUser.patientProfile!.phone != null ? App.currentUser.patientProfile!.phone! : '';
    countryCodeController.text = App.currentUser.patientProfile!.phoneCode != null ? App.currentUser.patientProfile!.phoneCode! : '';
  }

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.turquoise50,
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(left: 16, top: 8, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
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
                    GestureDetector(
                      child: Icon(
                        Icons.close,
                        color: App.theme.turquoise,
                        size: 32,
                      ),
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => Home(0),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                    )
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Personal Details',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: App.theme.grey900,
                        ),
                      ),
                      SizedBox(height: 24),
                      if (_error.isNotEmpty)
                        Text(
                          _error,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: App.theme.red),
                        ),
                      Text(
                        'First Name',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.grey600),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        readOnly: true,
                        enabled: false,
                        initialValue: App.currentUser.firstName,
                        style: TextStyle(fontSize: 18, color: App.theme.lightText),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            fillColor: App.theme.grey100,
                            filled: true,
                            hintText: 'Jane',
                            hintStyle: TextStyle(fontSize: 16, color: App.theme.mutedLightColor),
                            contentPadding: EdgeInsets.only(left: 8, right: 8),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: App.theme.grey300!, width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: App.theme.grey300!, width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: App.theme.grey300!, width: 1.0), borderRadius: BorderRadius.circular(10.0))),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Last Name',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.grey600),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        readOnly: true,
                        enabled: false,
                        initialValue: App.currentUser.lastName,
                        style: TextStyle(fontSize: 18, color: App.theme.lightText),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            fillColor: App.theme.grey100,
                            filled: true,
                            hintText: 'Doe',
                            hintStyle: TextStyle(fontSize: 16, color: App.theme.mutedLightColor),
                            contentPadding: EdgeInsets.only(left: 8, right: 8),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: App.theme.grey300!, width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: App.theme.grey300!, width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: App.theme.grey300!, width: 1.0), borderRadius: BorderRadius.circular(10.0))),
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
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.grey600),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12.0),
                                        decoration: BoxDecoration(
                                          color: App.theme.grey100,
                                          borderRadius: BorderRadius.circular(12.0),
                                          border: Border.all(color: App.theme.grey300!, style: BorderStyle.solid, width: 1),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              App.currentUser.patientProfile!.dob != null
                                                  ? (DateFormat.d().format(DateTime.parse(App.currentUser.patientProfile!.dob!)) +
                                                      ' ' +
                                                      DateFormat.MMM().format(DateTime.parse(App.currentUser.patientProfile!.dob!)) +
                                                      ' ' +
                                                      DateFormat.y().format(DateTime.parse(App.currentUser.patientProfile!.dob!)))
                                                  : '--/--/----',
                                              style: TextStyle(fontSize: 16, color: App.theme.mutedLightColor),
                                            ),
                                            SvgPicture.asset('assets/icons/icon_calendar.svg'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.grey600),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12.0),
                                        decoration: BoxDecoration(
                                          color: App.theme.grey100,
                                          borderRadius: BorderRadius.circular(12.0),
                                          border: Border.all(color: App.theme.grey300!, style: BorderStyle.solid, width: 1),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(App.currentUser.patientProfile!.gender!,
                                                style: TextStyle(fontSize: 16, color: App.theme.mutedLightColor)),
                                            SvgPicture.asset('assets/icons/icon_down_caret.svg', color: App.theme.turquoise)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Phone Number',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.grey600),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              key: _phoneCodeFieldKey,
                              style: TextStyle(fontSize: 18, color: App.theme.darkText),
                              controller: countryCodeController,
                              validator: (value) {
                                setState(() {
                                  _showPhoneCodeError = false;
                                });
                                if (value!.isNotEmpty) {
                                  RegExp regex = new RegExp(r'^(\+\d{1,3}|\d{1,4})$');
                                  if (!regex.hasMatch(value)) {
                                    setState(() {
                                      _showPhoneCodeError = true;
                                      _phoneError = 'Enter valid phone code';
                                    });
                                    return null;
                                  } else {
                                    return null;
                                  }
                                } else {
                                  setState(() {
                                    _showPhoneCodeError = true;
                                    _phoneError = "Phone Code Field Required";
                                  });
                                  return '';
                                }
                              },
                              decoration: InputDecoration(
                                  fillColor: App.theme.white,
                                  errorStyle: TextStyle(height: 0),
                                  filled: true,
                                  hintText: '+263',
                                  hintStyle: TextStyle(fontSize: 16, color: App.theme.mutedLightColor),
                                  contentPadding: EdgeInsets.only(left: 8, right: 8),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: App.theme.grey300!, width: 1.0),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: App.theme.grey300!, width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: App.theme.grey300!, width: 1.0), borderRadius: BorderRadius.circular(10.0))),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              key: _phoneFieldKey,
                              style: TextStyle(fontSize: 18, color: App.theme.darkText),
                              controller: phoneNumberController,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                setState(() {
                                  _showPhoneError = false;
                                });
                                if (value!.isEmpty) {
                                  setState(() {
                                    _showPhoneError = true;
                                    _phoneError = "Phone Field Required";
                                  });
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  errorStyle: TextStyle(height: 0),
                                  fillColor: App.theme.white,
                                  filled: true,
                                  hintText: '7123456789',
                                  hintStyle: TextStyle(fontSize: 16, color: App.theme.mutedLightColor),
                                  contentPadding: EdgeInsets.only(left: 8, right: 8),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: App.theme.grey300!, width: 1.0),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: App.theme.grey300!, width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: App.theme.grey300!, width: 1.0), borderRadius: BorderRadius.circular(10.0))),
                            ),
                          ),
                        ],
                      ),
                      if (_showPhoneError || _showPhoneCodeError)
                        Row(
                          children: [
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
                          ],
                        ),
                      SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'If you wish to make additional changes to your personal details, please ',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: App.theme.mutedLightColor,
                              ),
                            ),
                            TextSpan(
                              text: 'contact us.',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 14, color: App.theme.turquoise, decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ContactUs();
                                      },
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: App.theme.turquoise50,
          child: Container(
            padding: EdgeInsets.all(16),
            child: _loading
                ? PrimaryButtonLoading()
                : PrimaryLargeButton(
                    title: 'Save Personal Details',
                    iconWidget: SizedBox(),
                    onPressed: () {
                      setState(() {
                        _loading = true;
                      });
                      if (_phoneCodeFieldKey.currentState!.validate() && _phoneFieldKey.currentState!.validate()) {
                        if (_showPhoneError || _showPhoneCodeError) {
                          setState(() {
                            _loading = false;
                          });
                          return;
                        }

                        App.currentUser.patientProfile!.phoneCode = countryCodeController.value.text;
                        App.currentUser.patientProfile!.phone = phoneNumberController.value.text;

                        ApiProvider _provider = new ApiProvider();
                        _provider.updatePatientProfile().then(
                          (success) {
                            setState(() {
                              _loading = false;
                            });
                            if (success) {
                              App.sessionMessage = 'Profile Details updated successfully';
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Home(1);
                                  },
                                ),
                              );
                            } else {
                              _error = ApiResponse.message;
                              ApiResponse.message = '';
                            }
                          },
                        );
                      } else {
                        setState(() {
                          _loading = false;
                        });
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
