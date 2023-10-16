import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';

class DoctorReportingFlowScreenC extends StatefulWidget {
  final Booking booking;
  const DoctorReportingFlowScreenC({Key? key, required this.booking}) : super(key: key);

  @override
  _DoctorReportingFlowScreenCState createState() => _DoctorReportingFlowScreenCState();
}

class _DoctorReportingFlowScreenCState extends State<DoctorReportingFlowScreenC> {
  final physicalExamController = TextEditingController();
  final chronicConditionsController = TextEditingController();
  final briefFamilyHistoryController = TextEditingController();

  @override
  void initState() {
    physicalExamController.text = App.progressReport.physicalExam;
    chronicConditionsController.text = App.progressReport.chronicConditions;
    briefFamilyHistoryController.text = App.progressReport.familyHistory;
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
                'Physical Exam',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: App.theme.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Include Respiratory System, CVS, Abdomen and Central Nervous System',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: App.theme.mutedLightColor,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                textInputAction: TextInputAction.newline,
                maxLines: 3,
                style: TextStyle(fontSize: 18, color: App.theme.white),
                controller: physicalExamController,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    App.progressReport.physicalExam = value.replaceAll("\n", App.newLineDelimiter);
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
              SizedBox(height: 16),
              Text(
                'Chronic Conditions',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: App.theme.white,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                style: TextStyle(fontSize: 18, color: App.theme.white),
                controller: chronicConditionsController,
                maxLines: 3,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    App.progressReport.chronicConditions = value.replaceAll("\n", App.newLineDelimiter);
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
              SizedBox(height: 16),
              Text(
                'Brief Family History',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: App.theme.white,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                style: TextStyle(fontSize: 18, color: App.theme.white),
                controller: briefFamilyHistoryController,
                maxLines: 3,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    App.progressReport.familyHistory = value.replaceAll("\n", App.newLineDelimiter);
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
              SizedBox(height: 24),
            ],
          ),
        ),
      ],
    ));
  }
}
