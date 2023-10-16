import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/patient_report_review/patient_report_review_complete.dart';

import '../home.dart';

class PatientReportReviewDoctorDo extends StatefulWidget {
  final Booking booking;
  const PatientReportReviewDoctorDo({Key? key, required this.booking}) : super(key: key);

  @override
  _PatientReportReviewDoctorDoState createState() => _PatientReportReviewDoctorDoState();
}

class _PatientReportReviewDoctorDoState extends State<PatientReportReviewDoctorDo> {
  bool _confirmLoading = false;
  bool _skipLoading = false;
  bool _goHome = false;
  String _error = '';

  void handlePills(String val) {
    List<String> checksA = <String>[];
    if (App.patientReport.checks.isNotEmpty) {
      checksA = App.patientReport.checks.split(', ');
      int index = checksA.indexOf(val);
      if (index != -1) {
        checksA.removeAt(index);
      } else {
        checksA.add(val);
      }
    } else {
      checksA.add(val);
    }

    App.patientReport.checks = checksA.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.turquoise50,
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
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
                        'What did the practitioner do/check during the appointment?',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: App.theme.grey900,
                        ),
                      ),
                      SizedBox(height: 24),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          SecondaryPillButton(
                            title: 'Blood Test',
                            onPressed: () {
                              handlePills('Blood Test');
                            },
                          ),
                          SecondaryPillButton(
                            title: 'Injection',
                            onPressed: () {
                              handlePills('Injection');
                            },
                          ),
                          SecondaryPillButton(
                            title: 'Drip',
                            onPressed: () {
                              handlePills('Drip');
                            },
                          ),
                          SecondaryPillButton(
                            title: 'Other',
                            onPressed: () {
                              handlePills('Other');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
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
                if (_goHome)
                  Column(
                    children: [
                      if (_error.isNotEmpty)
                        Text(
                          _error,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                      SizedBox(height: 12),
                      PrimaryLargeButton(
                          title: 'Go to Home Page',
                          iconWidget: SizedBox(),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => Home(0),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          }),
                    ],
                  ),
                if (!_goHome)
                  Column(
                    children: [
                      _confirmLoading
                          ? PrimaryButtonLoading()
                          : PrimaryLargeButton(
                              title: 'Confirm & Complete',
                              iconWidget: SizedBox(),
                              onPressed: () {
                                setState(() {
                                  _confirmLoading = true;
                                });
                                doSubmit();
                              }),
                      SizedBox(height: 8),
                      _skipLoading
                          ? SecondaryButtonLoading()
                          : SecondaryLargeButton(
                              title: 'Skip & Complete',
                              onPressed: () {
                                setState(() {
                                  _skipLoading = true;
                                });

                                doSubmit();
                              }),
                    ],
                  )
              ],
            ),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  void doSubmit() {
    ApiProvider _provider = new ApiProvider();

    _provider.createPatientReport().then((report) {
      if (report != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PatientReportReviewComplete(booking: widget.booking);
        }));
      } else {
        _error = ApiResponse.message;
        _goHome = true;
        ApiResponse.message = '';
      }

      setState(() {
        _confirmLoading = false;
        _skipLoading = false;
      });
    });
  }
}
