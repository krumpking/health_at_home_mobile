import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';

class DoctorReportingFlowNonMedicalScreenB extends StatefulWidget {
  const DoctorReportingFlowNonMedicalScreenB({Key? key}) : super(key: key);

  @override
  _DoctorReportingFlowNonMedicalScreenBState createState() => _DoctorReportingFlowNonMedicalScreenBState();
}

class _DoctorReportingFlowNonMedicalScreenBState extends State<DoctorReportingFlowNonMedicalScreenB> {
  final diagnosisCommentsController = TextEditingController();
  final doctorsPlanController = TextEditingController();
  final briefFamilyHistoryController = TextEditingController();

  late int _personalEffortRadioGroupValue = 0;
  late int _medicalEffortRadioGroupValue = 0;

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
                'Patient Rating',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: App.theme.white,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Personal Effort',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: App.theme.white,
                ),
              ),
              Text(
                'On a scale of 1-5, to what extent do you agree or disagree with the following statement?: I wish I served patients like this all day. ',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: App.theme.mutedLightColor,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: App.theme.mutedLightColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Text(
                            '1',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: App.theme.white,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _personalEffortRadioGroupValue = 0;
                            });
                          },
                        ),
                        Radio(
                          value: 0,
                          groupValue: _personalEffortRadioGroupValue,
                          onChanged: personalEffortRadio,
                          activeColor: App.theme.turquoise,
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: App.theme.mutedLightColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Text(
                            '2',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: App.theme.white,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _personalEffortRadioGroupValue = 1;
                            });
                          },
                        ),
                        Radio(
                          value: 1,
                          groupValue: _personalEffortRadioGroupValue,
                          onChanged: personalEffortRadio,
                          activeColor: App.theme.turquoise,
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: App.theme.mutedLightColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Text(
                            '3',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: App.theme.white,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _personalEffortRadioGroupValue = 2;
                            });
                          },
                        ),
                        Radio(
                          value: 2,
                          groupValue: _personalEffortRadioGroupValue,
                          onChanged: personalEffortRadio,
                          activeColor: App.theme.turquoise,
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: App.theme.mutedLightColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Text(
                            '4',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: App.theme.white,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _personalEffortRadioGroupValue = 3;
                            });
                          },
                        ),
                        Radio(
                          value: 3,
                          groupValue: _personalEffortRadioGroupValue,
                          onChanged: personalEffortRadio,
                          activeColor: App.theme.turquoise,
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: App.theme.mutedLightColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Text(
                            '5',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: App.theme.white,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _personalEffortRadioGroupValue = 4;
                            });
                          },
                        ),
                        Radio(
                          value: 4,
                          groupValue: _personalEffortRadioGroupValue,
                          onChanged: personalEffortRadio,
                          activeColor: App.theme.turquoise,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Strongly Disagree',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: App.theme.white,
                    ),
                  ),
                  Text(
                    'Strongly Agree',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: App.theme.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'Medical Effort',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: App.theme.white,
                ),
              ),
              Text(
                'On a scale of 1-5, to what extent do you agree or disagree with the following statement?: this was simple, routine procedure with no complications. ',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: App.theme.mutedLightColor,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: App.theme.mutedLightColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Text(
                            '1',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: App.theme.white,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _medicalEffortRadioGroupValue = 0;
                            });
                          },
                        ),
                        Radio(
                          value: 0,
                          groupValue: _medicalEffortRadioGroupValue,
                          onChanged: medicalEffortRadio,
                          activeColor: App.theme.turquoise,
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: App.theme.mutedLightColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Text(
                            '2',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: App.theme.white,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _medicalEffortRadioGroupValue = 1;
                            });
                          },
                        ),
                        Radio(
                          value: 1,
                          groupValue: _medicalEffortRadioGroupValue,
                          onChanged: medicalEffortRadio,
                          activeColor: App.theme.turquoise,
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: App.theme.mutedLightColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Text(
                            '3',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: App.theme.white,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _medicalEffortRadioGroupValue = 2;
                            });
                          },
                        ),
                        Radio(
                          value: 2,
                          groupValue: _medicalEffortRadioGroupValue,
                          onChanged: medicalEffortRadio,
                          activeColor: App.theme.turquoise,
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: App.theme.mutedLightColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Text(
                            '4',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: App.theme.white,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _medicalEffortRadioGroupValue = 3;
                            });
                          },
                        ),
                        Radio(
                          value: 3,
                          groupValue: _medicalEffortRadioGroupValue,
                          onChanged: medicalEffortRadio,
                          activeColor: App.theme.turquoise,
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: App.theme.mutedLightColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Text(
                            '5',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: App.theme.white,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _medicalEffortRadioGroupValue = 4;
                            });
                          },
                        ),
                        Radio(
                          value: 4,
                          groupValue: _medicalEffortRadioGroupValue,
                          onChanged: medicalEffortRadio,
                          activeColor: App.theme.turquoise,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Strongly Disagree',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: App.theme.white,
                    ),
                  ),
                  Text(
                    'Strongly Agree',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: App.theme.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'Leave a private comment for our team (optional)',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: App.theme.white,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                maxLines: 6,
                style: TextStyle(fontSize: 18, color: App.theme.white),
                controller: doctorsPlanController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    fillColor: App.theme.mutedLightFillColor,
                    filled: true,
                    hintText: 'Start typing... ',
                    hintStyle: TextStyle(fontSize: 18, color: App.theme.grey400),
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF131825), width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF131825), width: 1.0), borderRadius: BorderRadius.circular(10.0))),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ],
    ));
  }

  void personalEffortRadio(int? value) {
    setState(() {
      _personalEffortRadioGroupValue = value!;
    });
  }

  void medicalEffortRadio(int? value) {
    setState(() {
      _medicalEffortRadioGroupValue = value!;
    });
  }
}
