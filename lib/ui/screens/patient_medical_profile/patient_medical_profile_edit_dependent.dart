import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.turquoise50,
        body: Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 64, bottom: 16),
          child: SafeArea(
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
                SizedBox(height: 32),
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
                      Text(
                        'First Name',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.grey600),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        readOnly: true,
                        enabled: false,
                        style: TextStyle(fontSize: 18, color: App.theme.white),
                        controller: firstNameController,
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
                      TextField(
                        readOnly: true,
                        enabled: false,
                        style: TextStyle(fontSize: 18, color: App.theme.white),
                        controller: lastNameController,
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
                                            Text('01/03/09', style: TextStyle(fontSize: 16, color: App.theme.mutedLightColor)),
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
                                            Text('Female', style: TextStyle(fontSize: 16, color: App.theme.mutedLightColor)),
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
                            child: TextField(
                              style: TextStyle(fontSize: 18, color: App.theme.white),
                              controller: countryCodeController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  fillColor: App.theme.white,
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
                            child: TextField(
                              style: TextStyle(fontSize: 18, color: App.theme.white),
                              controller: phoneNumberController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
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
                              recognizer: TapGestureRecognizer()..onTap = () async {},
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
          color: App.theme.white,
          child: Container(
            padding: EdgeInsets.all(16),
            child: PrimaryLargeButton(title: 'Save Personal Details', iconWidget: SizedBox(), onPressed: () {}),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
