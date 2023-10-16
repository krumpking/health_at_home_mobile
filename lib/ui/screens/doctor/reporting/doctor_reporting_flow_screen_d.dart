import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
// import 'package:time_picker_widget/time_picker_widget.dart';

class DoctorReportingFlowScreenD extends StatefulWidget {
  final Booking booking;
  const DoctorReportingFlowScreenD({Key? key, required this.booking})
      : super(key: key);

  @override
  _DoctorReportingFlowScreenDState createState() =>
      _DoctorReportingFlowScreenDState();
}

class _DoctorReportingFlowScreenDState
    extends State<DoctorReportingFlowScreenD> {
  final diagnosisCommentsController = TextEditingController();
  final doctorsPlanController = TextEditingController();

  String _selectedDate = App.progressReport.reviewDate.isNotEmpty
      ? App.progressReport.reviewDate.toString()
      : "Select Date";
  String _selectedTime = App.progressReport.reviewTime.isNotEmpty
      ? App.progressReport.reviewTime.toString()
      : "Select time";

  var _reviewCheck = false;
  var _reviewStatus = 'No';

  List<String> numberOfDays = ['1', '2', '3', '4', '5', '6', '7'];
  List<String> dayWeek = ['Day(s)', 'Week(s)'];

  @override
  void initState() {
    diagnosisCommentsController.text = App.progressReport.diagnosis;
    doctorsPlanController.text = App.progressReport.doctorPlan;
    _reviewCheck = App.progressReport.requestReview;
    if (_reviewCheck) {
      _reviewStatus = "Yes";
    }
    super.initState();
  }

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
                'Diagnosis and comments',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: App.theme.white,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                maxLines: 3,
                style: TextStyle(fontSize: 18, color: App.theme.white),
                controller: diagnosisCommentsController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                onChanged: (value) {
                  App.progressReport.diagnosis = value;
                },
                decoration: InputDecoration(
                    fillColor: App.theme.mutedLightFillColor,
                    filled: true,
                    hintText: 'Start typing... ',
                    hintStyle:
                        TextStyle(fontSize: 18, color: App.theme.grey400),
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF131825), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF131825), width: 1.0),
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              SizedBox(height: 16),
              Text(
                'Doctor’s Plan',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: App.theme.white,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                maxLines: 6,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                style: TextStyle(fontSize: 18, color: App.theme.white),
                controller: doctorsPlanController,
                onChanged: (value) {
                  App.progressReport.doctorPlan = value;
                },
                decoration: InputDecoration(
                    fillColor: App.theme.mutedLightFillColor,
                    filled: true,
                    hintText: 'Start typing... ',
                    hintStyle:
                        TextStyle(fontSize: 18, color: App.theme.grey400),
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF131825), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF131825), width: 1.0),
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              SizedBox(height: 16),
              Text(
                'Would you like to book a review?',
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
                    value: _reviewCheck,
                    onChanged: (bool value) {
                      setState(() {
                        _reviewCheck = value;
                        App.progressReport.requestReview = _reviewCheck;
                        if (_reviewCheck == true) {
                          _reviewStatus = 'Yes';
                        } else {
                          _reviewStatus = 'No';
                        }
                      });
                    },
                  ),
                  Text(_reviewStatus,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: App.theme.white,
                      )),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'When will it be?',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: App.theme.white,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: App.theme.darkGrey,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                              color: (App.theme.darkGrey)!,
                              style: BorderStyle.solid,
                              width: 0.1),
                        ),
                        child: Text(
                          '$_selectedDate',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: App.theme.white,
                          ),
                        ),
                      ),
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(Duration(days: 1)),
                          firstDate: DateTime.now().add(Duration(days: 1)),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData(
                                primaryColor: App.theme.darkBackground,
                                canvasColor: App.theme.darkBackground,
                                cardColor: App.theme.darkBackground,
                                dialogBackgroundColor: App.theme.darkBackground,
                                backgroundColor: App.theme.darkBackground!,
                                colorScheme: ColorScheme.light(
                                    onPrimary: Colors.white,
                                    onSurface:
                                        App.theme.white!.withOpacity(0.7),
                                    secondary: Colors.red,
                                    background: App.theme.darkBackground!,
                                    primary: App.theme.turquoise!),
                                buttonTheme: ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary),
                              ),
                              child: child!,
                            );
                          },
                        ).then((pickedDate) {
                          if (pickedDate == null) {
                            return;
                          }
                          App.progressReport.reviewDate =
                              DateFormat.yMMMd().format(pickedDate);
                          setState(() {
                            _selectedDate =
                                DateFormat.yMMMd().format(pickedDate);
                          });
                        });
                      }),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      child: Text(
                        'at',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: App.theme.white,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: App.theme.darkGrey,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                            color: (App.theme.darkGrey)!,
                            style: BorderStyle.solid,
                            width: 0.1),
                      ),
                      child: Text(
                        '$_selectedTime',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: App.theme.white,
                        ),
                      ),
                    ),
                    onTap: () async {
                      // showCustomTimePicker(
                      //   context: context,
                      //   // It is a must if you provide selectableTimePredicate
                      //   onFailValidation: (context) => null,
                      //   initialTime: TimeOfDay.now(),
                      //   selectableTimePredicate: (time) => time!.minute * 1 == time.minute,
                      // ).then((time) {
                      //   if (time != null) {
                      //     App.progressReport.reviewTime = time.format(context);
                      //     setState(() {
                      //       _selectedTime = time.format(context);
                      //     });
                      //   }
                      // });
                    },
                  ),
                ],
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ],
    ));
  }
}
