import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/doctor/reporting/non-medical/doctor_reporting_flow_non_medical_screen_a.dart';
import 'package:mobile/ui/screens/doctor/reporting/non-medical/doctor_reporting_flow_non_medical_screen_b.dart';

class DoctorReportingFlowNonMedical extends StatefulWidget {
  const DoctorReportingFlowNonMedical({Key? key}) : super(key: key);

  @override
  _DoctorReportingFlowNonMedicalState createState() =>
      _DoctorReportingFlowNonMedicalState();
}

class _DoctorReportingFlowNonMedicalState
    extends State<DoctorReportingFlowNonMedical> {
  int currentIndex = 0;
  late PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> reportingFlowScreens = [
    DoctorReportingFlowNonMedicalScreenA(),
    DoctorReportingFlowNonMedicalScreenB(),
  ];

  Future<void> _appointmentReportCompleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: App.theme.darkGrey,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
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
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: App.theme.white),
                ),
                SizedBox(height: 16),
                Text(
                  'Great job! You’re on track for a 5% bonus at the end of the month. \n\nKeep filling out your reports within 24 hours to stay ahead. ',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: App.theme.mutedLightColor),
                ),
                SizedBox(height: 16),
                SuccessRegularButton(
                    title: 'Back to Home Page', onPressed: () {}),
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
    return Container(
      decoration: BoxDecoration(color: App.theme.darkBackground),
      child: DarkStatusNavigationBarWidget(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
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
                        color: currentIndex + 1 >= 2
                            ? App.theme.turquoise
                            : App.theme.white,
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
                                    _controller.previousPage(
                                        duration: Duration(milliseconds: 750),
                                        curve: Curves.easeInOut);
                                  },
                                ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${currentIndex + 1}/${reportingFlowScreens.length}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: App.theme.mutedLightColor),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: currentIndex + 1 != reportingFlowScreens.length
                                ? PrimarySmallButton(
                                    title: 'Next',
                                    onPressed: () {
                                      _controller.nextPage(
                                          duration: Duration(milliseconds: 750),
                                          curve: Curves.easeInOut);
                                    })
                                : PrimarySmallButton(
                                    title: 'Finish',
                                    onPressed: () {
                                      _appointmentReportCompleteDialog();
                                    }),
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
    );
  }
}
