import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';
import 'package:mobile/ui/screens/patient/booking/new_booking.dart';
import 'package:mobile/ui/screens/patient_review_booking_relevant_services/patient_review_booking_relevant_services.dart';

class PatientMedicalProfileAppointmentReport extends StatefulWidget {
  final Booking booking;
  const PatientMedicalProfileAppointmentReport({Key? key, required this.booking}) : super(key: key);

  @override
  _PatientMedicalProfileAppointmentReportState createState() => _PatientMedicalProfileAppointmentReportState();
}

class _PatientMedicalProfileAppointmentReportState extends State<PatientMedicalProfileAppointmentReport> {
  @override
  Widget build(BuildContext context) {
    bool reviewExpired = false;
    if (widget.booking.report != null && widget.booking.report!.requestReview) {
      var diff = DateTime.now().difference(widget.booking.report!.nextReviewDate!).inHours;
      if (diff > 1) reviewExpired = true;
    }
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.turquoise50,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                decoration: BoxDecoration(
                  color: App.theme.turquoise50,
                  boxShadow: [
                    BoxShadow(
                      color: App.theme.turquoise!.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(2, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                                  builder: (context) => Home(1),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Appointment Report',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 23,
                        color: App.theme.grey900,
                      ),
                    ),
                    SizedBox(height: 16),
                    if (widget.booking.startTime != null)
                      Column(
                        children: [
                          Text(
                            ((DateFormat.d().format(widget.booking.selectedDate) +
                                    '/' +
                                    DateFormat.M().format(widget.booking.selectedDate) +
                                    '/' +
                                    DateFormat.y().format(widget.booking.selectedDate)) +
                                ', ' +
                                widget.booking.startTime! +
                                ' - ' +
                                widget.booking.endTime!),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: App.theme.grey600,
                            ),
                          ),
                          SizedBox(height: 4),
                        ],
                      ),
                    Text(
                      widget.booking.selectedDoctor != null
                          ? 'Dr. ' + Utilities.convertToTitleCase(widget.booking.selectedDoctor!.displayName)
                          : 'Urgent Visit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: App.theme.grey600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Services: ' + Utilities.getServiceListForBooking(widget.booking),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: App.theme.grey600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Patient: ' +
                          (widget.booking.dependent!.firstName.isNotEmpty
                              ? Utilities.convertToTitleCase((widget.booking.dependent!.firstName + ' ' + widget.booking.dependent!.lastName))
                              : Utilities.convertToTitleCase(widget.booking.patient!.displayName)),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: App.theme.grey600,
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Review Requested',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: App.theme.grey900,
                      ),
                    ),
                    SizedBox(height: 8),
                    (widget.booking.report != null && widget.booking.report!.requestReview)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Yes, before ${DateFormat.d().format(widget.booking.report!.nextReviewDate!) + ' ' + DateFormat.MMMM().format(widget.booking.report!.nextReviewDate!) + ', ' + DateFormat.y().format(widget.booking.report!.nextReviewDate!)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: reviewExpired ? Colors.red : App.theme.green,
                                ),
                              ),
                              SizedBox(height: 8),
                              (reviewExpired)
                                  ? Column(
                                      children: [
                                        Text(
                                          'Sorry, reviews must be placed within the specified timeframe above.',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Colors.red,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        PrimaryLargeButton(
                                            title: 'Book a standard visit',
                                            iconWidget: SizedBox(),
                                            onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                return PatientAppointmentNewBooking();
                                              }));
                                            }),
                                        SizedBox(height: 8),
                                      ],
                                    )
                                  : PrimaryLargeButton(
                                      title: 'Book a Review',
                                      iconWidget: SizedBox(),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return PatientReviewBookingRelevantServices();
                                        }));
                                      }),
                            ],
                          )
                        : Text(
                            'No',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: App.theme.red,
                            ),
                          ),
                    SizedBox(height: 16),
                    Text(
                      'Symptoms',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: App.theme.grey900,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.booking.bookingReason!.symptoms.length > 0 ? widget.booking.bookingReason!.symptoms.join(', ') : '--',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: App.theme.grey600,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Diagnosis & Comments',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: App.theme.grey900,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.booking.report != null && widget.booking.report!.diagnosis.isNotEmpty ? widget.booking.report!.diagnosis : '--',
                      softWrap: true,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: App.theme.grey600,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Doctor’s Plan',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: App.theme.grey900,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.booking.report != null && widget.booking.report!.doctorPlan.isNotEmpty ? widget.booking.report!.doctorPlan : '--',
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
            ],
          ),
        ),
      ),
    );
  }
}
