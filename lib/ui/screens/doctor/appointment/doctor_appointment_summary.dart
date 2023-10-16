import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/models/booking/booking_travel.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';
import 'package:mobile/ui/screens/doctor/reporting/doctor_reporting_flow.dart';

import 'doctor_appointment_en_route.dart';
import 'doctor_cancel_appointment.dart';
import 'doctor_previous_appointment.dart';

class DoctorAppointmentSummary extends StatefulWidget {
  final int bookingId;
  final int? notificationId;
  const DoctorAppointmentSummary({Key? key, required this.bookingId, this.notificationId}) : super(key: key);

  @override
  _DoctorAppointmentSummaryState createState() => _DoctorAppointmentSummaryState();
}

class _DoctorAppointmentSummaryState extends State<DoctorAppointmentSummary> {
  ApiProvider _provider = new ApiProvider();
  final oCcy = new NumberFormat("#,##0", "en_US");
  late Booking _booking;
  bool _bookingLoaded = false;
  bool _travelLoading = false;
  bool _confirmLoading = false;
  bool _completedLoading = false;
  bool _claimLoading = false;
  bool _declineLoading = false;
  Color appointmentStatusColor = App.theme.turquoise!;
  late String error = '';

  @override
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    if(widget.notificationId != null && widget.notificationId! > 0) {
      await _provider.openNotification(widget.notificationId!);
    }
    Booking? _bk = await _provider.getBooking(widget.bookingId);
    if (_bk != null) {
      setState(() {
        _booking = _bk;
        _bookingLoaded = true;

        switch (_booking.status.toUpperCase()) {
          case 'PENDING':
            appointmentStatusColor = App.theme.orange!;
            break;
          case 'CONFIRMED':
            appointmentStatusColor = App.theme.green500!;
            break;
          case 'EN-ROUTE':
            appointmentStatusColor = App.theme.red!;
            break;
          case 'CANCELLED':
            appointmentStatusColor = App.theme.orange!;
            break;
          case 'DECLINED':
            appointmentStatusColor = App.theme.orange!;
            break;
          case 'COMPLETE':
            appointmentStatusColor = App.theme.green500!;
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DarkStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.darkBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: App.theme.grey700,
                    child: Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            )
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
                                    'Appointment Status',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: App.theme.white,
                                    ),
                                  ),
                                  Text(
                                    _booking.status.toUpperCase() +
                                        ((_booking.status.toLowerCase() == 'complete' && _booking.report != null)
                                            ? ' (Report Filed)'
                                            : _booking.paymentStatus.toLowerCase() == 'paid'
                                                ? '(PAID)'
                                                : ''),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: appointmentStatusColor,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Payment Status',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: App.theme.white,
                                    ),
                                  ),
                                  Text(
                                    "${_booking.paymentStatus} - ${_booking.payment != null ? _booking.payment!.method.toUpperCase() : ''}",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.mutedLightColor),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Reason for Appointment',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: App.theme.white,
                                    ),
                                  ),
                                  (_booking.isReview)
                                      ? Text(
                                          'Review',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.errorRedColor),
                                        )
                                      : Text(
                                          Utilities.getAllBookingReason(_booking),
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.mutedLightColor),
                                        ),
                                  SizedBox(height: 16),
                                  if (Utilities.getAllBookingAlerts(_booking).isNotEmpty)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Alerts',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: App.theme.white,
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: Utilities.getAllBookingAlerts(_booking),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: App.theme.errorRedColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Personal Details',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: App.theme.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Age: ',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.white),
                                      ),
                                      Text(
                                        (_booking.patient != null && _booking.patient!.dob != null && _booking.patient!.dob!.isNotEmpty)
                                            ? Utilities.ageFromDob(_booking.patient!.dob!)
                                            : '--',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.mutedLightColor),
                                      ),
                                      SizedBox(width: 32),
                                      Text(
                                        'Sex: ',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.white),
                                      ),
                                      Text(
                                        _booking.patient!.gender!.toLowerCase() == 'female'
                                            ? 'F'
                                            : (_booking.patient!.gender!.toLowerCase() == 'male' ? 'M' : 'O'),
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.mutedLightColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  if (_booking.patient!.chronicConditions != null && _booking.patient!.chronicConditions!.isNotEmpty)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Chronic Conditions',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: App.theme.white,
                                          ),
                                        ),
                                        Text(
                                          _booking.patient!.chronicConditions!,
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.mutedLightColor),
                                        ),
                                        SizedBox(height: 16),
                                      ],
                                    ),
                                  if (_booking.patient!.allergies != null && _booking.patient!.allergies!.isNotEmpty)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Allergies',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: App.theme.white,
                                          ),
                                        ),
                                        Text(
                                          _booking.patient!.allergies!,
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.mutedLightColor),
                                        ),
                                      ],
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
                                      fontSize: 16,
                                      color: App.theme.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  (_booking.previousBookings.length > 0)
                                      ? Column(
                                          children: [
                                            for (Booking pBooking in _booking.previousBookings)
                                              if (pBooking.report != null)
                                                Container(
                                                  margin: EdgeInsets.symmetric(vertical: 8),
                                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      color: (App.theme.darkGrey)!, borderRadius: BorderRadius.all(Radius.circular(16))),
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
                                                )
                                          ],
                                        )
                                      : Text(
                                          'No previous bookings',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.mutedLightColor),
                                        ),
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
        ),
        bottomNavigationBar: _bookingLoaded
            ? BottomAppBar(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_booking.report != null && _booking.status.toLowerCase() != 'pending')
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _claimLoading
                                ? PrimaryButtonLoading()
                                : PrimaryLargeButton(
                                    title: 'View report',
                                    iconWidget: SizedBox(),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return DoctorPreviousAppointment(bookingId: _booking.id);
                                      }));
                                    },
                                  ),
                            SizedBox(height: 12),
                          ],
                        ),
                      if (_booking.status.toLowerCase() == 'pending' && _booking.isEmergency)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _claimLoading
                                ? PrimaryButtonLoading()
                                : PrimaryLargeButton(
                                    title: 'Claim & Confirm',
                                    iconWidget: SizedBox(),
                                    onPressed: () async {
                                      setState(() {
                                        _claimLoading = true;
                                      });
                                      ApiProvider _provider = new ApiProvider();
                                      bool success =
                                          await _provider.claimAppointment({'bookingId': _booking.id, 'doctorId': App.currentUser.doctorProfile!.id});
                                      setState(() {
                                        _claimLoading = false;
                                      });

                                      if (success) {
                                        Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) => DoctorAppointmentSummary(bookingId: _booking.parentBookingId!),
                                          ),
                                          (Route<dynamic> route) => false,
                                        );
                                      } else {
                                        error = ApiResponse.message;
                                        ApiResponse.message = '';
                                        Future.delayed(Duration.zero, () async {
                                          await _errorDialog();
                                        });
                                      }
                                    },
                                  )
                          ],
                        ),
                      if (_booking.status.toLowerCase() == 'pending' &&
                          !_booking.isEmergency &&
                          (_booking.selectedDoctor != null && _booking.selectedDoctor!.id == App.currentUser.doctorProfile!.id))
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _confirmLoading
                                ? PrimaryButtonLoading()
                                : PrimaryLargeButton(
                                    title: 'Confirm Appointment',
                                    iconWidget: SizedBox(),
                                    onPressed: () {
                                      setState(() {
                                        _confirmLoading = true;
                                      });
                                      ApiProvider _provider = new ApiProvider();
                                      _provider.updateDoctorBookingStatus({'bookingId': _booking.id, 'status': 'confirmed'}).then((success) async {
                                        setState(() {
                                          _confirmLoading = false;
                                        });
                                        if (success) {
                                          Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) => DoctorAppointmentSummary(bookingId: _booking.id),
                                            ),
                                            (Route<dynamic> route) => false,
                                          );
                                        }
                                      });
                                    },
                                  )
                          ],
                        ),
                      if (_booking.status.toLowerCase() == 'cancelled' || _booking.status.toLowerCase() == 'declined')
                        SecondaryLargeButton(
                          title: 'Back to Home',
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => DoctorHome(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      if (_booking.status.toLowerCase() == 'complete' && _booking.report == null)
                        PrimaryLargeButton(
                          title: 'File Report',
                          iconWidget: SizedBox(),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => DoctorReportingFlow(booking: _booking),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      if (_booking.status.toLowerCase() == 'complete' && _booking.report != null)
                        SecondaryLargeButton(
                          title: 'Go back to Home',
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => DoctorHome(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      if (_booking.status.toLowerCase() == 'confirmed')
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _travelLoading
                                ? PrimaryButtonLoading()
                                : (Utilities.canStartTravelling(_booking))
                                    ? PrimaryLargeButton(
                                        title: 'Start Travelling',
                                        iconWidget: SizedBox(),
                                        onPressed: () {
                                          setState(() {
                                            _travelLoading = true;
                                          });
                                          ApiProvider _provider = new ApiProvider();
                                          _provider.updateDoctorBookingStatus({'bookingId': _booking.id, 'status': 'en-route'}).then((success) async {
                                            if (success) {
                                              var location = await Utilities.getUserLocation();
                                              var travel = BookingTravel(_booking.id, location!.latitude.toString(), location.longitude.toString(),
                                                      _booking.latitude, _booking.longitude)
                                                  .toJson();
                                              _provider.updateBookingTravel(travel).then((travel) {
                                                setState(() {
                                                  _travelLoading = false;
                                                });
                                                if (travel != null) {
                                                  Navigator.of(context).pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                      builder: (context) => DoctorAppointmentEnRoute(bookingId: _booking.id),
                                                    ),
                                                    (Route<dynamic> route) => false,
                                                  );
                                                }
                                              });
                                            }
                                          });
                                        },
                                      )
                                    : DisabledLargeButton(
                                        title: 'Start Travelling',
                                        onPressed: () {},
                                      ),
                          ],
                        ),
                      if (Utilities.bookingCanBeCancelled(_booking)) SizedBox(height: 10),
                      if (Utilities.bookingCanBeCancelled(_booking))
                        _booking.status.toLowerCase() == 'pending'
                            ? Column(
                                children: [
                                  _declineLoading
                                      ? SecondaryButtonLoading()
                                      : SecondaryLargeButton(
                                          title: 'Decline Appointment',
                                          onPressed: () {
                                            setState(() {
                                              _declineLoading = true;
                                            });
                                            ApiProvider _provider = new ApiProvider();
                                            _provider
                                                .updateDoctorBookingStatus({'bookingId': widget.bookingId, 'status': 'declined'}).then((success) {
                                              setState(() {
                                                _declineLoading = false;
                                              });
                                              if (success) {
                                                Navigator.of(context).pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                    builder: (context) => DoctorHome(),
                                                  ),
                                                  (Route<dynamic> route) => false,
                                                );
                                              }
                                            });
                                          })
                                ],
                              )
                            : DangerLargeButton(
                                title: 'Cancel Appointment',
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return DoctorCancelAppointment(booking: _booking);
                                  }));
                                }),
                    ],
                  ),
                ),
                elevation: 0,
              )
            : Container(
                child: SizedBox(
                  height: 32,
                  width: 32,
                ),
              ),
      ),
    );
  }

  Future<void> _errorDialog() async {
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
                SvgPicture.asset('assets/icons/icon_error.svg'),
                SizedBox(height: 24),
                Text(
                  'Error!!!',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: App.theme.white),
                ),
                SizedBox(height: 8),
                Text(
                  error,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.mutedLightColor),
                ),
                SizedBox(height: 8),
                DangerRegularButton(
                    title: 'Go to Home Page',
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => DoctorHome(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
}
