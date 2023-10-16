import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';

class DoctorSpecificRequestCancelAppointment extends StatefulWidget {
  const DoctorSpecificRequestCancelAppointment({Key? key}) : super(key: key);

  @override
  _DoctorSpecificRequestCancelAppointmentState createState() => _DoctorSpecificRequestCancelAppointmentState();
}

class _DoctorSpecificRequestCancelAppointmentState extends State<DoctorSpecificRequestCancelAppointment> {
  int _groupValue = 0;

  final reasonController = TextEditingController();

  Future<void> _saveChangesDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: App.theme.darkGrey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
          contentPadding: EdgeInsets.all(16),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 8),
                SvgPicture.asset('assets/icons/icon_success.svg'),
                SizedBox(height: 24),
                Text(
                  'Appointment Cancelled',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: App.theme.white),
                ),
                SizedBox(height: 16),
                Text(
                  'This appointment has been cancelled. The patient will have the option to re-book another time or with another practitioner.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.mutedLightColor),
                ),
                SizedBox(height: 16),
                SuccessRegularButton(title: 'Back to Home Page', onPressed: () {}),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DarkStatusNavigationBarWidget(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          color: App.theme.darkBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                width: MediaQuery.of(context).size.width,
                color: App.theme.grey700,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Appointment File',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              color: App.theme.white,
                            ),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.close,
                              color: App.theme.white,
                              size: 32,
                            ),
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => DoctorHome(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Today, 10:30AM - 11:00AM',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: App.theme.white,
                        ),
                      ),
                      Text(
                        'GP Appointment (PPE necessary), COVID-19 Test',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: App.theme.white,
                        ),
                      ),
                      Text(
                        'Grace Thompson',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: App.theme.white,
                        ),
                      ),
                      Text(
                        '25 Budleigh Close, Borrowdale ',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: App.theme.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reason for Cancellation',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: App.theme.white,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: App.theme.mutedLightColor,
                    ),
                    child: Row(
                      children: [
                        Radio(
                          value: 0,
                          groupValue: _groupValue,
                          onChanged: handleRadio,
                          hoverColor: Colors.yellow,
                          activeColor: App.theme.turquoise,
                          focusColor: Colors.green,
                        ),
                        GestureDetector(
                          child: Text(
                            'Emergency',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: App.theme.mutedLightColor,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _groupValue = 0;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: App.theme.mutedLightColor,
                    ),
                    child: Row(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: _groupValue,
                          onChanged: handleRadio,
                          hoverColor: Colors.yellow,
                          activeColor: App.theme.turquoise,
                          focusColor: Colors.green,
                        ),
                        GestureDetector(
                          child: Text(
                            'Another Appointment',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: App.theme.mutedLightColor,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _groupValue = 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: App.theme.mutedLightColor,
                    ),
                    child: Row(
                      children: [
                        Radio(
                          value: 2,
                          groupValue: _groupValue,
                          onChanged: handleRadio,
                          hoverColor: Colors.yellow,
                          activeColor: App.theme.turquoise,
                          focusColor: Colors.green,
                        ),
                        GestureDetector(
                          child: Text(
                            'Other',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: App.theme.mutedLightColor,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _groupValue = 2;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Please add a reason for the cancellation',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: App.theme.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      maxLines: 7,
                      style: TextStyle(fontSize: 18, color: App.theme.white),
                      controller: reasonController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          fillColor: App.theme.mutedLightFillColor,
                          filled: true,
                          hintText: 'Start typing... ',
                          hintStyle: TextStyle(fontSize: 18, color: App.theme.grey400),
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF131825), width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF131825), width: 1.0), borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryLargeButton(
                        title: 'Confirm Cancellation',
                        iconWidget: SizedBox(),
                        onPressed: () {
                          _saveChangesDialog();
                        }),
                    SizedBox(height: 16),
                    SecondaryLargeButton(title: 'Keep Appointment', onPressed: () {}),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleRadio(int? value) {
    setState(() {
      _groupValue = value!;
    });
  }
}
