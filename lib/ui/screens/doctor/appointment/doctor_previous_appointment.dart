import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';

class DoctorPreviousAppointment extends StatefulWidget {
  final int bookingId;
  const DoctorPreviousAppointment({Key? key, required this.bookingId}) : super(key: key);

  @override
  _DoctorPreviousAppointmentState createState() => _DoctorPreviousAppointmentState();
}

class _DoctorPreviousAppointmentState extends State<DoctorPreviousAppointment> {
  ApiProvider _provider = new ApiProvider();
  bool _bookingLoaded = false;
  var enabled = false;
  late Booking _booking;

  @override
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    Booking? _bk = await _provider.getBooking(widget.bookingId);
    if (_bk != null) {
      setState(() {
        _booking = _bk;
        _bookingLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DarkStatusNavigationBarWidget(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: App.theme.darkBackground,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width,
                  color: App.theme.grey700,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Appointment Report',
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
                        if (_bookingLoaded)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Utilities.getTimeLapseBooking(_booking),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: App.theme.white,
                                ),
                              ),
                              Text(
                                Utilities.getServiceListForBooking(_booking),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: App.theme.white,
                                ),
                              ),
                              Text(
                                Utilities.convertToTitleCase('${_booking.dependent!.firstName} ${_booking.dependent!.lastName}'),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: App.theme.white,
                                ),
                              ),
                              Text(
                                _booking.address,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: App.theme.white,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                _bookingLoaded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Actions Taken',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: App.theme.white,
                                  ),
                                ),
                                Text(
                                  _booking.report!.checks.isNotEmpty ? _booking.report!.checks : 'N/A',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.mutedLightColor),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Symptoms',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: App.theme.white,
                                  ),
                                ),
                                Text(
                                  _booking.report!.symptoms.isNotEmpty ? _booking.report!.symptoms.replaceAll(App.newLineDelimiter, "\n") : 'N/A',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.mutedLightColor),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Physical Exam',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: App.theme.white,
                                  ),
                                ),
                                Text(
                                  _booking.report!.physicalExam.isNotEmpty
                                      ? _booking.report!.physicalExam.replaceAll(App.newLineDelimiter, "\n")
                                      : 'N/A',
                                  softWrap: true,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.mutedLightColor),
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
                                Text(
                                  _booking.report!.chronicConditions.isNotEmpty
                                      ? _booking.report!.chronicConditions.replaceAll(App.newLineDelimiter, "\n")
                                      : 'N/A',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.mutedLightColor),
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
                                Text(
                                  _booking.report!.familyHistory.isNotEmpty
                                      ? _booking.report!.familyHistory.replaceAll(App.newLineDelimiter, "\n")
                                      : 'N/A',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.mutedLightColor),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Diagnosis and Comments',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: App.theme.white,
                                  ),
                                ),
                                Text(
                                  _booking.report!.diagnosis.isNotEmpty ? _booking.report!.diagnosis.replaceAll(App.newLineDelimiter, "\n") : 'N/A',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.mutedLightColor),
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
                                Text(
                                  _booking.report!.doctorPlan.isNotEmpty ? _booking.report!.doctorPlan.replaceAll(App.newLineDelimiter, "\n") : 'N/A',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.mutedLightColor),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Divider(
                              color: App.theme.darkGrey,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Previous Appointment Reports',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: App.theme.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                (_booking.previousBookings.length > 0)
                                    ? Column(
                                        children: [
                                          for (Booking pBooking in _booking.previousBookings)
                                            Container(
                                              margin: EdgeInsets.symmetric(vertical: 8),
                                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                              width: double.infinity,
                                              decoration:
                                                  BoxDecoration(color: (App.theme.darkGrey)!, borderRadius: BorderRadius.all(Radius.circular(16))),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    Utilities.getTimeLapseBooking(pBooking),
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16,
                                                      color: App.theme.white,
                                                    ),
                                                  ),
                                                  SizedBox(height: 12),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Diagnos(es): ',
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16,
                                                          color: App.theme.white,
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          Utilities.getAllBookingReason(pBooking),
                                                          maxLines: 5,
                                                          softWrap: true,
                                                          textAlign: TextAlign.start,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 14,
                                                            color: App.theme.mutedLightColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 12),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Seen by: ',
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16,
                                                          color: App.theme.white,
                                                        ),
                                                      ),
                                                      Text(
                                                        (_booking.selectedDoctor != null)
                                                            ? Utilities.convertToTitleCase(_booking.selectedDoctor!.displayName)
                                                            : '--',
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 14,
                                                          color: App.theme.mutedLightColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      )
                                    : Text(
                                        'No previous bookings',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.mutedLightColor),
                                      ),
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(App.theme.turquoise!),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: App.theme.darkGrey,
          child: Container(
            padding: EdgeInsets.all(16),
            child: SecondaryLargeButton(
              title: 'Done',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
