import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';

class DoctorReportingFlowScreenF extends StatefulWidget {
  final Booking booking;
  const DoctorReportingFlowScreenF({Key? key, required this.booking}) : super(key: key);

  @override
  _DoctorReportingFlowScreenFState createState() => _DoctorReportingFlowScreenFState();
}

class _DoctorReportingFlowScreenFState extends State<DoctorReportingFlowScreenF> {
  final privateMessageController = TextEditingController();

  late int _personalEffortRadioGroupValue = 2;
  late int _medicalEffortRadioGroupValue = 2;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
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
                'Leave a private comment for our team',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: App.theme.white,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                textInputAction: TextInputAction.newline,
                maxLines: 3,
                style: TextStyle(fontSize: 18, color: App.theme.white),
                controller: privateMessageController,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    App.progressReport.privateMessage = value.replaceAll("\n", App.newLineDelimiter);
                  }
                },
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

    App.progressReport.personalEffortRating = value! + 1;
  }

  void medicalEffortRadio(int? value) {
    setState(() {
      _medicalEffortRadioGroupValue = value!;
    });
    App.progressReport.medicalEffortRating = value! + 1;
  }
}
