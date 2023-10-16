import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/models/patient_report.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';
import 'package:mobile/ui/screens/patient_report_review/patient_report_review_doctor_was.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

class PatientReportReview extends StatefulWidget {
  final int bookingId;
  const PatientReportReview({Key? key, required this.bookingId}) : super(key: key);

  @override
  _PatientReportReviewState createState() => _PatientReportReviewState();
}

class _PatientReportReviewState extends State<PatientReportReview> {
  ApiProvider _provider = new ApiProvider();
  bool rated = false;

  @override
  void initState() {
    super.initState();
    App.patientReport = PatientReport.init();
    setState(() {
      App.patientReport.bookingId = widget.bookingId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.turquoise50,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
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
                    ),
                  ],
                )),
                SizedBox(height: 24),
                Text(
                  'Visit Rating/Review',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 23,
                    color: App.theme.grey900,
                  ),
                ),
                FutureBuilder<Booking?>(
                  future: _provider.getBooking(widget.bookingId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
                        child: Center(
                          child: SizedBox(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(App.theme.turquoise!),
                              strokeWidth: 3,
                            ),
                            height: MediaQuery.of(context).size.height * 0.04,
                            width: MediaQuery.of(context).size.height * 0.04,
                          ),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      Booking? _booking = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            DateFormat.E().format(_booking!.selectedDate) +
                                ', ' +
                                DateFormat.MMM().format(_booking.selectedDate) +
                                ' ' +
                                DateFormat.d().format(_booking.selectedDate) +
                                Utilities.getDayOfMonthSuffix(_booking.selectedDate.day) +
                                ', ' +
                                _booking.startTime! +
                                ' - ' +
                                _booking.endTime!,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: App.theme.grey900,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            Utilities.getServiceListForBooking(_booking),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: App.theme.grey900,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Dr. ${_booking.selectedDoctor!.displayName}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: App.theme.grey900,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _booking.address,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: App.theme.grey900,
                            ),
                          ),
                          SizedBox(height: 64),
                          Text(
                            'How would you rate this practitioner based on this visit?',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: App.theme.grey900,
                            ),
                          ),
                          SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SimpleStarRating(
                                allowHalfRating: false,
                                starCount: 5,
                                rating: 0,
                                size: 64,
                                isReadOnly: false,
                                filledIcon: Icon(Icons.star, color: App.theme.btnDarkSecondary, size: 64),
                                nonFilledIcon: Icon(Icons.star, color: App.theme.grey300, size: 64),
                                onRated: (rate) {
                                  if (rate != null) {
                                    Future.delayed(const Duration(seconds: 1), () {
                                      setState(() {
                                        App.patientReport.rating = rate;
                                      });
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return PatientReportReviewDoctorWas(booking: _booking);
                                      }));
                                    });
                                  }
                                },
                                spacing: 4,
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'We couldn\'t find this booking.',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: App.theme.red,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
