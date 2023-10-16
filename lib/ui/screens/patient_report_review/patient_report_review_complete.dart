import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';

class PatientReportReviewComplete extends StatefulWidget {
  final Booking booking;
  const PatientReportReviewComplete({Key? key, required this.booking}) : super(key: key);

  @override
  _PatientReportReviewCompleteState createState() => _PatientReportReviewCompleteState();
}

class _PatientReportReviewCompleteState extends State<PatientReportReviewComplete> {
  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.turquoise50,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [SvgPicture.asset('assets/icons/icon_big_check.svg')],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Visit Review Complete!',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 23,
                            color: App.theme.grey900,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Text(
                      'Thank you for submitting your review for your appointment with ${widget.booking.selectedDoctor!.title.isNotEmpty ? widget.booking.selectedDoctor!.title.replaceAll('.', '') + '. ' : 'Dr.'} ${widget.booking.selectedDoctor!.firstName} ${widget.booking.selectedDoctor!.lastName}.',
                      textAlign: TextAlign.start,
                      maxLines: 10,
                      softWrap: true,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: App.theme.grey600,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Reports like these help us to ensure a high quality of service for our customers. ',
                      textAlign: TextAlign.start,
                      maxLines: 10,
                      softWrap: true,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: App.theme.grey600,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Container(
              padding: EdgeInsets.all(16),
              child: PrimaryLargeButton(
                  title: 'Go Home',
                  iconWidget: SizedBox(),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Home(0);
                    }));
                  })),
          elevation: 0,
        ),
      ),
    );
  }
}
