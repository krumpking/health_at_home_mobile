import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';

class DoctorReportingFlowNonMedicalScreenA extends StatefulWidget {
  const DoctorReportingFlowNonMedicalScreenA({Key? key}) : super(key: key);

  @override
  _DoctorReportingFlowNonMedicalScreenAState createState() => _DoctorReportingFlowNonMedicalScreenAState();
}

class _DoctorReportingFlowNonMedicalScreenAState extends State<DoctorReportingFlowNonMedicalScreenA> {
  var _paidCheck = false;
  var _paidStatus = 'No';

  final appointmentCommentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            mainAxisAlignment: MainAxisAlignment.center,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comments from the appointment',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: App.theme.white,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                maxLines: 9,
                style: TextStyle(fontSize: 18, color: App.theme.white),
                controller: appointmentCommentsController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    fillColor: App.theme.mutedLightFillColor,
                    filled: true,
                    hintText: 'Start typing...',
                    hintStyle: TextStyle(fontSize: 18, color: App.theme.mutedLightColor),
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF131825), width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF131825), width: 1.0), borderRadius: BorderRadius.circular(10.0))),
              ),
              SizedBox(height: 16),
              Text(
                'Has the patient paid in full for their appointment?',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: App.theme.white,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  CupertinoSwitch(
                    value: _paidCheck,
                    onChanged: (bool value) {
                      setState(() {
                        _paidCheck = value;
                        if (_paidCheck == true) {
                          _paidStatus = 'Yes';
                        } else {
                          _paidStatus = 'No';
                        }
                      });
                    },
                  ),
                  Text(_paidStatus,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: App.theme.white,
                      )),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        SizedBox(height: 16),
      ],
    ));
  }
}
