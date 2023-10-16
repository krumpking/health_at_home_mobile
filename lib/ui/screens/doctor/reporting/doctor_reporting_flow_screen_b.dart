import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/ui/partials/button.dart';

class DoctorReportingFlowScreenB extends StatefulWidget {
  final Booking booking;
  const DoctorReportingFlowScreenB({Key? key, required this.booking}) : super(key: key);

  @override
  _DoctorReportingFlowScreenBState createState() => _DoctorReportingFlowScreenBState();
}

class _DoctorReportingFlowScreenBState extends State<DoctorReportingFlowScreenB> {
  final otherSymptomsController = TextEditingController();

  @override
  void initState() {
    otherSymptomsController.text = App.progressReport.otherSymptoms;
    super.initState();
  }

  void handlePills(String val) {
    List<String> symptomsA = <String>[];
    if (App.progressReport.symptoms.isNotEmpty) {
      symptomsA = App.progressReport.symptoms.split(', ');
      int index = symptomsA.indexOf(val);
      if (index != -1) {
        symptomsA.removeAt(index);
      } else {
        symptomsA.add(val);
      }
    } else {
      symptomsA.add(val);
    }

    App.progressReport.symptoms = symptomsA.join(', ');
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
                'What symptoms did the patient present with?',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: App.theme.white,
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  PrimaryPillButton(
                    title: 'Headache',
                    onPressed: () {
                      handlePills('Headache');
                    },
                  ),
                  PrimaryPillButton(
                    title: 'Dizziness',
                    onPressed: () {
                      handlePills('Dizziness');
                    },
                  ),
                  PrimaryPillButton(
                    title: 'Cough',
                    onPressed: () {
                      handlePills('Cough');
                    },
                  ),
                  PrimaryPillButton(
                    title: 'Sore Throat',
                    onPressed: () {
                      handlePills('Sore Throat');
                    },
                  ),
                  PrimaryPillButton(
                    title: 'Nausea',
                    onPressed: () {
                      handlePills('Nausea');
                    },
                  ),
                  PrimaryPillButton(
                    title: 'Vomiting',
                    onPressed: () {
                      handlePills('Vomiting');
                    },
                  ),
                  PrimaryPillButton(
                    title: 'Fever',
                    onPressed: () {
                      handlePills('Fever');
                    },
                  ),
                  PrimaryPillButton(
                    title: 'Diarrhea',
                    onPressed: () {
                      handlePills('Diarrhea');
                    },
                  ),
                  PrimaryPillButton(
                    title: 'Dysuria',
                    onPressed: () {
                      handlePills('Dysuria');
                    },
                  ),
                  PrimaryPillButton(
                    title: 'Frequency',
                    onPressed: () {
                      handlePills('Frequency');
                    },
                  ),
                  PrimaryPillButton(
                    title: 'Chest Pain',
                    onPressed: () {
                      handlePills('Chest Pain');
                    },
                  ),
                  PrimaryPillButton(
                    title: 'Palpitations',
                    onPressed: () {
                      handlePills('Palpitations');
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Other Symptoms',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: App.theme.mutedLightColor,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                maxLines: 3,
                style: TextStyle(fontSize: 18, color: App.theme.white),
                controller: otherSymptomsController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    App.progressReport.otherSymptoms = value.replaceAll("\n", App.newLineDelimiter);
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
            ],
          ),
        ),
      ],
    ));
  }
}
