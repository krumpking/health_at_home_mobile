import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/places.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/patient/booking/new_booking.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_doctor_availabilities.dart';
import 'package:mobile/ui/screens/patient_report_review/patient_report_review.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

import '../home.dart';
import '../patient_appointment_booking/patient_new_booking_availabilities.dart';
import '../patient_appointment_booking/patient_new_booking_filtered_doctors.dart';
import '../patient_appointment_booking/patient_new_booking_payment.dart';
import '../patient_appointment_booking/patient_new_booking_visit_summary.dart';

class PatientAppointmentSummary extends StatefulWidget {
  final int bookingId;
  const PatientAppointmentSummary({Key? key, required this.bookingId}) : super(key: key);

  @override
  _PatientAppointmentSummaryState createState() => _PatientAppointmentSummaryState();
}

class _PatientAppointmentSummaryState extends State<PatientAppointmentSummary> {
  ApiProvider _provider = new ApiProvider();
  final oCcy = new NumberFormat("#,##0", "en_US");
  bool _cancelLoading = false;
  bool _payLoading = false;
  bool _bookingLoaded = false;
  late Booking _booking;
  late String _distance = '';
  late String error = '';
  late String _time = '_';
  Timer? timer;
  final format = DateFormat.jm();

  @override
  void initState() {
    super.initState();
    initApp();
    print('refreshed');
  }

  Future<void> initApp() async {
    Booking? _bk = await _provider.getBooking(widget.bookingId);
    if (_bk != null) {
      if (_bk.status.toLowerCase() != 'complete') {
        _bk = await Utilities.checkAndUpdateStatus(_bk);
      }
      setState(() {
        _booking = _bk!;
      });

      if (_booking.status.toLowerCase() == 'en-route') {
        var travel = await _provider.getBookingTravel(_bk.id);
        setState(() {
          _bookingLoaded = true;
        });
        if (travel != null) {
          var now = DateTime.now();
          var matrix = await PlaceApiProvider(UniqueKey()).getDistance(LatLng(double.parse(_booking.latitude), double.parse(_booking.longitude)),
              LatLng(double.parse(travel.fromLat), double.parse(travel.fromLng)));
          setState(() {
            _distance = matrix.distance.text;
            _time = format.format(now.add(Duration(seconds: matrix.time.value)));
          });

          checkDistance();
        }
      } else {
        setState(() {
          _bookingLoaded = true;
        });
      }
    }
  }

  void checkDistance() {
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
      var travel = await _provider.getBookingTravel(_booking.id);
      if (travel != null) {
        var now = DateTime.now();
        var matrix = await PlaceApiProvider(UniqueKey()).getDistance(LatLng(double.parse(_booking.latitude), double.parse(_booking.longitude)),
            LatLng(double.parse(travel.fromLat), double.parse(travel.fromLng)));
        setState(() {
          _distance = matrix.distance.text;
          _time = format.format(now.add(Duration(seconds: matrix.time.value)));
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.turquoise50,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                  decoration: BoxDecoration(
                    color: App.theme.turquoise50,
                  ),
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
                                Navigator.pop(context, {
                                  setState(() {
                                    // refresh state
                                  })
                                });
                              },
                            ),
                            GestureDetector(
                              child: Icon(
                                Icons.close,
                                color: App.theme.turquoise,
                                size: 32,
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Home(0))).then((value) {
                                  setState(() {
                                    // refresh state
                                  });
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text(
                        'Visit Summary',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 23,
                          color: App.theme.grey900,
                        ),
                      ),
                      SizedBox(height: 24),
                      _bookingLoaded
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _booking.selectedDoctor != null
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(_booking.selectedDoctor!.profileImg != null
                                                  ? _booking.selectedDoctor!.profileImg!
                                                  : 'https://via.placeholder.com/140x100'),
                                              radius: MediaQuery.of(context).size.width * 0.09,
                                            ),
                                          ),
                                          Expanded(
                                              flex: 3,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    (_booking.selectedDoctor!.title.isNotEmpty ? _booking.selectedDoctor!.title + '. ' : '') +
                                                        Utilities.convertToTitleCase(_booking.selectedDoctor!.displayName),
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20,
                                                      color: App.theme.grey900,
                                                    ),
                                                  ),
                                                  SimpleStarRating(
                                                    allowHalfRating: false,
                                                    starCount: 5,
                                                    rating: double.parse(_booking.selectedDoctor!.rating.toString()),
                                                    size: 24,
                                                    filledIcon: Icon(Icons.star, color: App.theme.btnDarkSecondary, size: 24),
                                                    nonFilledIcon: Icon(Icons.star_border, color: App.theme.btnDarkSecondary, size: 24),
                                                    onRated: (rate) {},
                                                    spacing: 4,
                                                  ),
                                                ],
                                              ))
                                        ],
                                      )
                                    : Text(
                                        'Urgent Visit',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: App.theme.grey900,
                                        ),
                                      ),
                                SizedBox(height: 24),
                                Text(
                                  'Status',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: App.theme.grey900,
                                  ),
                                ),
                                SizedBox(height: 8),
                                if (_booking.status.toLowerCase() == 'complete')
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'COMPLETE',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: App.theme.turquoise,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      if (_booking.patientReport == null)
                                        PrimaryLargeButton(
                                            title: 'Rate your experience',
                                            iconWidget: SizedBox(),
                                            onPressed: () {
                                              App.patientReport.doctorName =
                                                  (_booking.selectedDoctor!.title.isNotEmpty ? _booking.selectedDoctor!.title + '. ' : '') +
                                                      Utilities.convertToTitleCase(_booking.selectedDoctor!.displayName);
                                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                return PatientReportReview(bookingId: _booking.id);
                                              }));
                                            }),
                                    ],
                                  ),
                                if (_booking.status.toLowerCase() == 'pending')
                                  Text(
                                    'PENDING',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: App.theme.orange,
                                    ),
                                  ),
                                if (_booking.status.toLowerCase() == 'confirmed')
                                  Text(
                                    "CONFIRMED",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: App.theme.green500,
                                    ),
                                  ),
                                if (_booking.status.toLowerCase() == 'cancelled')
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'CANCELLED RE-BOOK',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: App.theme.turquoise,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Sorry, your practitioner was unable to attend this visit and had to cancel.',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: App.theme.grey600,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (_booking.status.toLowerCase() == 'declined')
                                  Text(
                                    'DECLINED',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: App.theme.red,
                                    ),
                                  ),
                                if (_booking.status.toLowerCase() == 'en-route')
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'EN-ROUTE',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: App.theme.red,
                                        ),
                                      ),
                                      Text(
                                        'Estimated time of Arrival: $_time',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: App.theme.darkText,
                                        ),
                                      ),
                                      Text(
                                        _distance,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: App.theme.green500,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (_booking.report != null && _booking.report!.requestReview && _booking.report!.nextReviewDate != null)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Review Requested',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: App.theme.grey900,
                                        ),
                                      ),
                                      Text(
                                        DateFormat.d().format(_booking.report!.nextReviewDate!) +
                                            ' ' +
                                            DateFormat.MMMM().format(_booking.report!.nextReviewDate!) +
                                            ', ' +
                                            DateFormat.y().format(_booking.report!.nextReviewDate!),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: App.theme.green500,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (_booking.payment != null)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 24),
                                      Text(
                                        'Payment Status',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: App.theme.grey900,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "${_booking.payment!.method.toUpperCase()} - ${_booking.payment!.status}",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: App.theme.grey600,
                                        ),
                                      ),
                                    ],
                                  ),
                                SizedBox(height: 24),
                                Text(
                                  'Address',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: App.theme.grey900,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  _booking.address,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: App.theme.grey600,
                                  ),
                                ),
                                if (_booking.unitNumber.isNotEmpty)
                                  Text(
                                    _booking.unitNumber,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: App.theme.grey600,
                                    ),
                                  ),
                                SizedBox(height: 24),
                                Text(
                                  'Date/Time',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: App.theme.grey900,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  Utilities.getTimeLapseBooking(_booking),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: App.theme.grey600,
                                  ),
                                ),
                                SizedBox(height: 24),
                                Text(
                                  'Total',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: App.theme.grey900,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  '\$${oCcy.format(_booking.totalPrice)}',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: App.theme.grey600,
                                  ),
                                ),
                                SizedBox(height: 24),
                                if (Utilities.bookingCanBeCancelled(_booking))
                                  GestureDetector(
                                    onTap: () {
                                      _cancelDismissDialog();
                                    },
                                    child: Text(
                                      'Cancel Visit',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: App.theme.errorRedColor,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                if (_booking.status.toLowerCase() == 'cancelled' || _booking.status.toLowerCase() == 'declined')
                                  PrimaryRegularButton(title: "Re-Book", onPressed: () {
                                    App.progressBooking = _booking;
                                    App.progressBooking!.bookingFlow = BookingFlow.HOME_PLUS;
                                    App.progressBooking!.bookingCriteria = _booking.selectedDoctor != null ? BookingCriteria.SELECT_PROVIDERS : BookingCriteria.ASAP;
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return (_booking.selectedDoctor != null) ? PatientNewBookingAvailabilities(doctorProfile: App.progressBooking!.selectedDoctor!, isEdit: true) : PatientNewBookingVisitSummary();
                                    }));
                                  })
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            child: _bookingLoaded
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_booking.report != null && _booking.report!.requestReview)
                        Column(
                          children: [
                            PrimaryLargeButton(
                              iconWidget: SizedBox(),
                              title: 'Book Review',
                              onPressed: () {
                                App.progressBooking = Booking.init();
                                App.progressBooking!.id = _booking.id;
                                App.progressBooking!.selectedDoctor = _booking.selectedDoctor;
                                App.progressBooking!.addOnService = _booking.addOnService;
                                App.progressBooking!.address = _booking.address;
                                App.progressBooking!.unitNumber = _booking.unitNumber;
                                App.progressBooking!.addressNotes = _booking.addressNotes;
                                App.progressBooking!.latitude = _booking.latitude;
                                App.progressBooking!.longitude = _booking.longitude;
                                App.progressBooking!.bookingReason = _booking.bookingReason;
                                App.progressBooking!.selectedDoctor = _booking.selectedDoctor;
                                App.progressBooking!.bookingFor = _booking.bookingFor;
                                App.progressBooking!.dependent = _booking.dependent;
                                App.progressBooking!.primaryService = _booking.primaryService;
                                App.progressBooking!.bookingCriteria = BookingCriteria.SELECT_PROVIDERS;
                                App.progressBooking!.bookingFlow = BookingFlow.HOME_PLUS;
                                App.progressBooking!.isReview = true;

                                App.progressBooking!.totalPrice = App.progressBooking!.primaryService.reviewPrice != 0
                                    ? App.progressBooking!.primaryService.reviewPrice
                                    : App.progressBooking!.primaryService.price;

                                print(App.progressBooking!.toJson());

                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return PatientDoctorAvailabilities(doctorProfile: _booking.selectedDoctor!);
                                }));
                              },
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      if (_booking.status.toLowerCase() == 'confirmed' &&
                          _booking.paymentStatus.toLowerCase() == 'new' &&
                          (_booking.payment == null || _booking.payment!.status.toLowerCase() == 'failed'))
                        Column(
                          children: [
                            PrimaryLargeButton(
                              iconWidget: SizedBox(),
                              title: 'Make Payment',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return PatientNewBookingPayment(booking: _booking);
                                  }),
                                );
                              },
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                    ],
                  )
                : SizedBox(height: 0),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Future<void> _cancelDismissDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter dialogState) {
          return AlertDialog(
            backgroundColor: App.theme.white,
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
                    'Are you sure you want to cancel this visit?',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: App.theme.grey900),
                  ),
                  SizedBox(height: 16),
                  PrimaryRegularButton(
                    title: 'No, keep visit',
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 16),
                  _cancelLoading
                      ? SizedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(App.theme.red!),
                            strokeWidth: 3,
                          ),
                          height: 14,
                          width: 14,
                        )
                      : GestureDetector(
                          child: Text(
                            'Yes, cancel visit',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: App.theme.red),
                          ),
                          onTap: () {
                            dialogState(() {
                              _cancelLoading = true;
                            });
                            ApiProvider _provider = new ApiProvider();
                            _provider.updatePatientBookingStatus({'bookingId': _booking.id, 'status': 'cancelled'}).then(
                              (success) {
                                dialogState(() {
                                  _cancelLoading = false;
                                });
                                setState(() {
                                  _cancelLoading = false;
                                });
                                if (success) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => Home(0),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                }
                              },
                            );
                          },
                        ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
