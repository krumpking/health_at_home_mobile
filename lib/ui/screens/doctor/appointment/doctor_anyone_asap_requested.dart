import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';

class DoctorAnyoneAsapRequested extends StatefulWidget {
  const DoctorAnyoneAsapRequested({Key? key}) : super(key: key);

  @override
  _DoctorAnyoneAsapRequestedState createState() => _DoctorAnyoneAsapRequestedState();
}

class _DoctorAnyoneAsapRequestedState extends State<DoctorAnyoneAsapRequested> {
  @override
  Widget build(BuildContext context) {
    return DarkStatusNavigationBarWidget(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: App.theme.darkBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                height: 240,
                color: App.theme.grey700,
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reason for Appointment',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: App.theme.white,
                      ),
                    ),
                    Text(
                      'General Checkup',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.mutedLightColor),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Alerts',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: App.theme.white,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'COVID-19 positive, ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: App.theme.errorRedColor,
                            ),
                          ),
                          TextSpan(
                            text: 'Pennicilin allergy',
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: App.theme.mutedLightColor),
                          ),
                        ],
                      ),
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
                    PrimaryLargeButton(title: 'Claim Appointment', iconWidget: SizedBox(), onPressed: () {}),
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
}
