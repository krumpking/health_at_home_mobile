import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';
import 'package:mobile/ui/screens/patient_report_review/patient_report_review_doctor_do.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PatientReportReviewDoctorWas extends StatefulWidget {
  final Booking booking;
  const PatientReportReviewDoctorWas({Key? key, required this.booking}) : super(key: key);

  @override
  _PatientReportReviewDoctorWasState createState() => _PatientReportReviewDoctorWasState();
}

class _PatientReportReviewDoctorWasState extends State<PatientReportReviewDoctorWas> {
  final privateCommentController = TextEditingController();
  final List<String> timeKeeping = ['ON TIME', 'LATE'];
  final List<String> patience = ['PATIENT', 'IN A RUSH'];
  final List<String> professional = ['PROFESSIONAL', 'UNPROFESSIONAL'];
  final List<String> presentable = ['WELL-PRESENTED', 'SCRUFY'];
  final List<String> informative = ['INFORMATIVE', 'UNINFORMATIVE'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: LightStatusNavigationBarWidget(
        child: Scaffold(
          backgroundColor: App.theme.turquoise50,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.only(left: 16, top: 16, right: 16),
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
                    SizedBox(height: 24),
                    Text(
                      'The Practitioner was:',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: App.theme.grey900,
                      ),
                    ),
                    SizedBox(height: 12),
                    Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ToggleSwitch(
                                  minWidth: width,
                                  cornerRadius: 22.0,
                                  activeBgColors: [
                                    [App.theme.turquoise!],
                                    [App.theme.turquoise!]
                                  ],
                                  activeFgColor: App.theme.white,
                                  inactiveBgColor: App.theme.white,
                                  inactiveFgColor: App.theme.darkBackground,
                                  initialLabelIndex:
                                      App.patientReport.timeKeeping.isNotEmpty ? timeKeeping.indexOf(App.patientReport.timeKeeping) : 0,
                                  totalSwitches: 2,
                                  labels: timeKeeping,
                                  radiusStyle: true,
                                  onToggle: (index) {
                                    if (index != null) {
                                      App.patientReport.timeKeeping = timeKeeping[index];
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ToggleSwitch(
                                  minWidth: width,
                                  cornerRadius: 22.0,
                                  activeBgColors: [
                                    [App.theme.turquoise!],
                                    [App.theme.turquoise!]
                                  ],
                                  activeFgColor: App.theme.white,
                                  inactiveBgColor: App.theme.white,
                                  inactiveFgColor: App.theme.darkBackground,
                                  initialLabelIndex: App.patientReport.patience.isNotEmpty ? patience.indexOf(App.patientReport.patience) : 0,
                                  totalSwitches: 2,
                                  labels: patience,
                                  radiusStyle: true,
                                  onToggle: (index) {
                                    if (index != null) {
                                      App.patientReport.patience = patience[index];
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ToggleSwitch(
                                  minWidth: width,
                                  cornerRadius: 22.0,
                                  activeBgColors: [
                                    [App.theme.turquoise!],
                                    [App.theme.turquoise!]
                                  ],
                                  activeFgColor: App.theme.white,
                                  inactiveBgColor: App.theme.white,
                                  inactiveFgColor: App.theme.darkBackground,
                                  initialLabelIndex:
                                      App.patientReport.professionalism.isNotEmpty ? professional.indexOf(App.patientReport.professionalism) : 0,
                                  totalSwitches: 2,
                                  labels: professional,
                                  radiusStyle: true,
                                  onToggle: (index) {
                                    if (index != null) {
                                      App.patientReport.professionalism = professional[index];
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ToggleSwitch(
                                  minWidth: width,
                                  cornerRadius: 22.0,
                                  activeBgColors: [
                                    [App.theme.turquoise!],
                                    [App.theme.turquoise!]
                                  ],
                                  activeFgColor: App.theme.white,
                                  inactiveBgColor: App.theme.white,
                                  inactiveFgColor: App.theme.darkBackground,
                                  initialLabelIndex:
                                      App.patientReport.presentable.isNotEmpty ? presentable.indexOf(App.patientReport.presentable) : 0,
                                  totalSwitches: 2,
                                  labels: presentable,
                                  radiusStyle: true,
                                  onToggle: (index) {
                                    if (index != null) {
                                      App.patientReport.presentable = presentable[index];
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ToggleSwitch(
                                  minWidth: width,
                                  cornerRadius: 22.0,
                                  activeBgColors: [
                                    [App.theme.turquoise!],
                                    [App.theme.turquoise!]
                                  ],
                                  activeFgColor: App.theme.white,
                                  inactiveBgColor: App.theme.white,
                                  inactiveFgColor: App.theme.darkBackground,
                                  initialLabelIndex:
                                      App.patientReport.informative.isNotEmpty ? informative.indexOf(App.patientReport.informative) : 0,
                                  totalSwitches: 2,
                                  labels: informative,
                                  radiusStyle: true,
                                  onToggle: (index) {
                                    if (index != null) {
                                      App.patientReport.informative = informative[index];
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          Text(
                            'Leave a private comment for our team',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.grey600),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            maxLines: 5,
                            style: TextStyle(fontSize: 16, color: App.theme.darkText),
                            controller: privateCommentController,
                            onChanged: (value) {
                              App.patientReport.privateMessage = value;
                            },
                            decoration: InputDecoration(
                                fillColor: App.theme.white,
                                filled: true,
                                hintText: 'Input text here',
                                hintStyle: TextStyle(fontSize: 18, color: App.theme.grey400),
                                contentPadding: EdgeInsets.all(16),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0), borderRadius: BorderRadius.circular(10.0))),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryLargeButton(
                      title: 'Confirm',
                      iconWidget: SizedBox(),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return PatientReportReviewDoctorDo(booking: widget.booking);
                        })).then((value) {
                          App.patientReport.timeKeeping = '';
                          App.patientReport.patience = '';
                          App.patientReport.professionalism = '';
                          App.patientReport.presentable = '';
                          App.patientReport.informative = '';
                        });
                      }),
                  SizedBox(height: 8),
                  SecondaryLargeButton(
                      title: 'Skip',
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return PatientReportReviewDoctorDo(booking: widget.booking);
                        }));
                      }),
                ],
              ),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
