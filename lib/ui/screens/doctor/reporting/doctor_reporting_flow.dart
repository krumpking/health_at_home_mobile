import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/models/booking_report.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/my_app_bar.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';
import 'package:mobile/ui/screens/doctor/reporting/doctor_reporting_flow_screen_a.dart';
import 'package:mobile/ui/screens/doctor/reporting/doctor_reporting_flow_screen_b.dart';
import 'package:mobile/ui/screens/doctor/reporting/doctor_reporting_flow_screen_c.dart';
import 'package:mobile/ui/screens/doctor/reporting/doctor_reporting_flow_screen_d.dart';
import 'package:mobile/ui/screens/doctor/reporting/doctor_reporting_flow_screen_e.dart';
import 'package:mobile/ui/screens/doctor/reporting/doctor_reporting_flow_screen_f.dart';

class DoctorReportingFlow extends StatefulWidget {
  final Booking booking;
  const DoctorReportingFlow({Key? key, required this.booking}) : super(key: key);

  @override
  _DoctorReportingFlowState createState() => _DoctorReportingFlowState();
}

class _DoctorReportingFlowState extends State<DoctorReportingFlow> {
  int currentIndex = 0;
  late PageController _controller = PageController();
  late List<Widget> reportingFlowScreens = <Widget>[];
  bool _loading = false;
  late String error = '';

  @override
  void initState() {
    super.initState();

    App.progressReport = BookingReport.init();

    App.progressReport.bookingId = widget.booking.id;

    setState(() {
      reportingFlowScreens = [
        DoctorReportingFlowScreenA(booking: widget.booking),
        DoctorReportingFlowScreenB(booking: widget.booking),
        DoctorReportingFlowScreenC(booking: widget.booking),
        DoctorReportingFlowScreenD(booking: widget.booking),
        DoctorReportingFlowScreenE(booking: widget.booking),
        DoctorReportingFlowScreenF(booking: widget.booking),
      ];
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _appointmentReportCompleteDialog() async {
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
                  'Appointment Report Complete!',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: App.theme.white),
                ),
                SizedBox(height: 16),
                Text(
                  'Great job! You’re on track for a 5% bonus at the end of the month. \n\nKeep filling out your reports within 24 hours to stay ahead. ',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.mutedLightColor),
                ),
                SizedBox(height: 16),
                SuccessRegularButton(
                    title: 'Back to Home Page',
                    onPressed: () async {
                      await Navigator.of(context)
                          .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => DoctorHome()), (Route<dynamic> route) => false);
                    }),
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: DarkStatusNavigationBarWidget(
        child: Container(
          decoration: BoxDecoration(color: App.theme.darkBackground),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: myAppBar(),
            body: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: App.theme.grey700,
                  child: Container(
                    margin: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Appointment Details',
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utilities.getTimeLapseBooking(widget.booking),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: App.theme.white,
                              ),
                            ),
                            Text(
                              Utilities.getServiceListForBooking(widget.booking),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: App.theme.white,
                              ),
                            ),
                            Text(
                              Utilities.convertToTitleCase(widget.booking.patient!.displayName),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: App.theme.white,
                              ),
                            ),
                            Text(
                              widget.booking.address,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: App.theme.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                      pageSnapping: true,
                      scrollDirection: Axis.horizontal,
                      controller: _controller,
                      onPageChanged: (value) {
                        setState(() {
                          currentIndex = value;
                        });
                      },
                      children: reportingFlowScreens),
                ),
                if (error.isNotEmpty)
                  Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        error,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: App.theme.red,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                Container(
                  color: App.theme.darkBackground,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          height: 2,
                          color: App.theme.turquoise,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          height: 2,
                          color: currentIndex + 1 >= 2 ? App.theme.turquoise : App.theme.white,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          height: 2,
                          color: currentIndex + 1 >= 3 ? App.theme.turquoise : App.theme.white,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          height: 2,
                          color: currentIndex + 1 >= 4 ? App.theme.turquoise : App.theme.white,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          height: 2,
                          color: currentIndex + 1 >= 5 ? App.theme.turquoise : App.theme.white,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          height: 2,
                          color: currentIndex + 1 >= 6 ? App.theme.turquoise : App.theme.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    height: 70,
                    width: double.infinity,
                    color: App.theme.darkBackground,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: currentIndex == 0
                                ? SizedBox()
                                : GestureDetector(
                                    child: Text(
                                      'Previous',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: App.theme.mutedLightColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    onTap: () {
                                      _controller.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                                    },
                                  ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${currentIndex + 1}/${reportingFlowScreens.length}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: App.theme.mutedLightColor),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: currentIndex + 1 != reportingFlowScreens.length
                                  ? PrimarySmallButton(
                                      title: "Next",
                                      onPressed: () {
                                        setState(() {
                                          error = "";
                                        });
                                        if (currentIndex == 0) {
                                          if (App.progressReport.checks.isEmpty) {
                                            setState(() {
                                              error = "Please select at least one check.";
                                            });
                                            return;
                                          }
                                        }
                                        if (currentIndex == 1) {
                                          if (App.progressReport.symptoms.isEmpty && App.progressReport.otherSymptoms.isEmpty) {
                                            setState(() {
                                              error = "Please select at least one symptom or type something in the textfield.";
                                            });
                                            return;
                                          }
                                        }
                                        if (currentIndex == 2) {
                                          if (App.progressReport.physicalExam.isEmpty ||
                                              App.progressReport.chronicConditions.isEmpty ||
                                              App.progressReport.familyHistory.isEmpty) {
                                            setState(() {
                                              error = "Please fill in all fields.";
                                            });
                                            return;
                                          }
                                        }
                                        if (currentIndex == 3) {
                                          if (App.progressReport.diagnosis.isEmpty || App.progressReport.doctorPlan.isEmpty) {
                                            setState(() {
                                              error = "Diagnosis and doctor's plan are required.";
                                            });
                                            return;
                                          }
                                          if (App.progressReport.requestReview &&
                                              (App.progressReport.reviewDate.isEmpty || App.progressReport.reviewTime.isEmpty)) {
                                            setState(() {
                                              error = "Please provide next review date.";
                                            });
                                            return;
                                          }
                                        }
                                        _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                                      })
                                  : _loading
                                      ? PrimarySmallLoadingButton()
                                      : PrimarySmallButton(
                                          title: 'Finish',
                                          onPressed: () {
                                            if (currentIndex == 5) {
                                              if (App.progressReport.privateMessage.isEmpty) {
                                                setState(() {
                                                  error = "Please leave a private comment.";
                                                });
                                                return;
                                              }
                                            }
                                            setState(() {
                                              _loading = true;
                                            });
                                            ApiProvider _provider = new ApiProvider();

                                            if (App.progressReport.requestReview &&
                                                (App.progressReport.reviewDate.isNotEmpty && App.progressReport.reviewTime.isNotEmpty)) {
                                              App.progressReport.nextReviewDate =
                                                  DateTime.tryParse("${App.progressReport.reviewDate} ${App.progressReport.reviewTime}");
                                            }

                                            _provider.createReport().then(
                                              (report) {
                                                if (report != null) {
                                                  _appointmentReportCompleteDialog();
                                                }

                                                setState(() {
                                                  _loading = false;
                                                });
                                              },
                                            );
                                          },
                                        ),
                            ),
                          ),
                        ],
                      ),
                    )),
                SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
