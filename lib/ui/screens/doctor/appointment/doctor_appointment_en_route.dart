import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/models/booking/booking_travel.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/places.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';

import 'doctor_appointment_summary.dart';

class DoctorAppointmentEnRoute extends StatefulWidget {
  final int bookingId;
  final int? notificationId;
  const DoctorAppointmentEnRoute({Key? key, required this.bookingId, this.notificationId}) : super(key: key);

  @override
  _DoctorAppointmentEnRouteState createState() => _DoctorAppointmentEnRouteState();
}

class _DoctorAppointmentEnRouteState extends State<DoctorAppointmentEnRoute> {
  ApiProvider _provider = new ApiProvider();
  final oCcy = new NumberFormat("#,##0", "en_US");
  bool _completeLoading = false;
  bool _bookingLoaded = false;
  bool _cancelLoading = false;
  late Booking _booking;
  late BookingTravel _travel;
  late String _distance = '';
  late String _time = '_';
  final format = DateFormat.jm();
  Timer? timer;

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
      });
      var travel = await _provider.getBookingTravel(_bk.id);
      setState(() {
        _bookingLoaded = true;
      });
      if (travel != null) {
        var now = DateTime.now();
        var matrix = await PlaceApiProvider(UniqueKey()).getDistance(LatLng(double.parse(_booking.latitude), double.parse(_booking.longitude)),
            LatLng(double.parse(travel.fromLat), double.parse(travel.fromLng)));
        setState(() {
          _travel = travel;
          _distance = matrix.distance.text;
          _time = format.format(now.add(Duration(seconds: matrix.time.value)));
        });

        checkDistance();
      }
    }
  }

  void checkDistance() {
    // timer = Timer.periodic(Duration(seconds: 2), (Timer t) async {
    //   var location = await Utilities.getUserLocation();
    //   _travel.fromLat = location!.latitude.toString();
    //   _travel.fromLng = location.longitude.toString();

    //   var travel = await _provider.updateBookingTravel(_travel.toJson());
    //   if (travel != null) {
    //     var now = DateTime.now();
    //     var matrix = await PlaceApiProvider(UniqueKey())
    //         .getDistance(LatLng(double.parse(_booking.latitude), double.parse(_booking.longitude)), LatLng(double.parse(travel.fromLat), double.parse(travel.fromLng)));
    //     setState(() {
    //       _travel = travel;
    //       _distance = matrix.distance.text;
    //       _time = format.format(now.add(Duration(seconds: matrix.time.value)));
    //     });

    //     if (_distance.toLowerCase() == 'arrived') {
    //       timer!.cancel();
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DarkStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.darkBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  _bookingLoaded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _booking.selectedDoctor != null
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: CircleAvatar(
                                          backgroundColor: App.theme.white,
                                          backgroundImage: _booking.patient!.profileImg != null ? NetworkImage(_booking.patient!.profileImg!) : null,
                                          child: _booking.patient!.profileImg == null
                                              ? Center(
                                                  child: Text(
                                                    _booking.dependent!.firstName.substring(0, 1).toUpperCase() +
                                                        _booking.dependent!.lastName.substring(0, 1).toUpperCase(),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                      color: App.theme.turquoise,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          radius: MediaQuery.of(context).size.width * 0.09,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              Utilities.convertToTitleCase('${_booking.dependent!.firstName} ${_booking.dependent!.lastName}'),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                color: App.theme.white,
                                              ),
                                            ),
                                            if (_booking.patient!.phone != null)
                                              Text(
                                                _booking.patient!.phone!,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20,
                                                  color: App.theme.white,
                                                ),
                                              )
                                          ],
                                        ),
                                      )
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
                                color: App.theme.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'EN-ROUTE',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  'Estimated time of Arrival: $_time',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: App.theme.white!.withOpacity(0.7),
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
                            SizedBox(height: 6),
                            SuccessRegularButton(
                                title: 'Start Navigation',
                                onPressed: () async {
                                  await Utilities.openMap(_booking);
                                }),
                            SizedBox(height: 24),
                            Text(
                              'Address',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: App.theme.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              _booking.address,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: App.theme.white!.withOpacity(0.7),
                              ),
                            ),
                            if (_booking.unitNumber.isNotEmpty)
                              Text(
                                _booking.unitNumber,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: App.theme.white!.withOpacity(0.7),
                                ),
                              ),
                            if (_booking.addressNotes.isNotEmpty)
                              Text(
                                _booking.addressNotes,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: App.theme.white!.withOpacity(0.7),
                                ),
                              ),
                            SizedBox(height: 24),
                            Text(
                              'Date/Time',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: App.theme.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              Utilities.getTimeLapseBooking(_booking),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: App.theme.white!.withOpacity(0.7),
                              ),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Total',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: App.theme.white,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              '\$${oCcy.format(_booking.totalPrice)}',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: App.theme.white!.withOpacity(0.7),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                          child: SizedBox(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(App.theme.turquoise!),
                              strokeWidth: 3,
                            ),
                            height: 32,
                            width: 32,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _bookingLoaded
            ? Container(
                padding: EdgeInsets.all(16),
                color: App.theme.grey700,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _completeLoading
                        ? PrimaryButtonLoading()
                        : PrimaryLargeButton(
                            title: 'Complete Appointment',
                            iconWidget: SizedBox(),
                            onPressed: () {
                              setState(() {
                                _completeLoading = true;
                              });

                              var payload = {'bookingId': _booking.id, 'status': 'completed'};

                              ApiProvider _provider = new ApiProvider();
                              _provider.updateDoctorBookingStatus(payload).then((success) {
                                if (success) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => DoctorAppointmentSummary(
                                        bookingId: _booking.id,
                                      ),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                }
                                setState(() {
                                  _completeLoading = false;
                                });
                              });
                            }),
                    SizedBox(height: 16),
                    DangerLargeButton(
                      title: 'Cancel Travelling',
                      onPressed: () async {
                        setState(() {
                          _cancelLoading = true;
                        });
                        ApiProvider _provider = new ApiProvider();
                        bool success = await _provider.updateDoctorBookingStatus({'bookingId': _booking.id, 'status': 'confirmed'});
                        if (success) {
                          var location = await Utilities.getUserLocation();
                          var travel = BookingTravel(
                                  _booking.id, location!.latitude.toString(), location.longitude.toString(), _booking.latitude, _booking.longitude)
                              .toJson();
                          _provider.updateBookingTravel(travel).then((travel) {
                            setState(() {
                              _cancelLoading = false;
                            });
                            if (travel != null) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => DoctorAppointmentSummary(bookingId: _booking.id),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            }
                          });
                        }
                      },
                    )
                  ],
                ),
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
}
