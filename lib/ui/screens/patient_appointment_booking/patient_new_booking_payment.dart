import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_new_booking_visit_request_successful.dart';

import '../../../providers/api_response.dart';
import '../../partials/button.dart';
import '../home.dart';
import '../patient_appointment_summary_tracking/patient_appointment_summary.dart';

class PatientNewBookingPayment extends StatefulWidget {
  final Booking booking;
  const PatientNewBookingPayment({Key? key, required this.booking}) : super(key: key);

  @override
  _PatientNewBookingPaymentState createState() => _PatientNewBookingPaymentState();
}

class _PatientNewBookingPaymentState extends State<PatientNewBookingPayment> {
  bool _cardLoading = false;
  bool _cashLoading = false;
  bool _planLoading = false;
  late String _error = '';
  late Timer? timer;
  late int paymentId = 0;
  late bool paymentSuccess = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _errorDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: App.theme.turquoise50,
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
                  'Payment Failed!',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: App.theme.red),
                ),
                SizedBox(height: 16),
                DangerRegularButton(
                    title: 'Okay',
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => Home(0),
                        ),
                            (Route<dynamic> route) => false,
                      );
                    }),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _successDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: App.theme.turquoise50,
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
                  'Payment Received!',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: App.theme.green),
                ),
                SizedBox(height: 16),
                SuccessRegularButton(
                    title: 'Okay',
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => Home(0),
                        ),
                            (Route<dynamic> route) => false,
                      );
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
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.turquoise50,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
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
                            Text(
                              'Payment',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: App.theme.grey900,
                              ),
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
                            ),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Select a payment option.",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () async {
                          if (!_cardLoading) {
                            setState(() {
                              _cardLoading = true;
                            });

                            ApiProvider provider = ApiProvider();
                            var result = await provider.payBooking(bookingId: widget.booking.id, method: 'card');

                            if (result != null) {
                              if (result['redirectUrl'] != null) {
                                paymentId = result['paymentId'];
                                App.launchURL(result['redirectUrl']);

                                timer = Timer.periodic(Duration(seconds: 10), (Timer t) async {
                                  print('Timer running....');
                                  if (paymentId > 0) {
                                    var result = await provider.checkPaymentStatus(paymentId: paymentId, type: 'booking');

                                    if (result.containsKey('status') && result['status'] != null && int.parse(result['status'].toString()) == 3) {
                                      setState(() {
                                        _cardLoading = false;
                                      });
                                      timer!.cancel();
                                      t.cancel();
                                      _successDialog();
                                    }

                                    if (result.containsKey('status') && result['status'] != null && int.parse(result['status'].toString()) == 4) {
                                      setState(() {
                                        _cardLoading = false;
                                      });
                                      timer!.cancel();
                                      t.cancel();
                                      _errorDialog();
                                    }
                                  } else {
                                    timer!.cancel();
                                    t.cancel();
                                    setState(() {
                                      _cardLoading = false;
                                    });
                                  }
                                });
                              }
                            }

                            setState(() {
                              _error = ApiResponse.message;
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                          decoration: BoxDecoration(
                            color: App.theme.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: !_cardLoading
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Card",
                                      style: TextStyle(
                                        color: App.theme.darkerText,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Pay with your VISA or Mastercard credit or debit card.",
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        App.theme.turquoise!,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () async {
                          if (!_cashLoading) {
                            setState(() {
                              _cashLoading = true;
                            });

                            ApiProvider provider = ApiProvider();
                            var result = await provider.payBooking(bookingId: widget.booking.id, method: 'cash');
                            if (result != null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientNewBookingVisitRequestSuccessful(),
                                ),
                              );
                            }

                            setState(() {
                              _cashLoading = false;
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                          decoration: BoxDecoration(
                            color: App.theme.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: !_cashLoading
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Cash",
                                      style: TextStyle(
                                        color: App.theme.darkerText,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Pay with cash in person when the doctor gets to you.",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: App.theme.darkerText,
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(App.theme.white!),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (widget.booking.dependent != null &&
                          widget.booking.dependent!.isSubscriptionValid() &&
                          widget.booking.dependent!.subscription != null &&
                          widget.booking.dependent!.subscription!.remainingVisits > 0)
                        InkWell(
                          onTap: () async {
                            if (!_planLoading) {
                              setState(() {
                                _planLoading = true;
                              });

                              ApiProvider provider = ApiProvider();
                              var result = await provider.payBooking(bookingId: widget.booking.id, method: 'plan');
                              if (result != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PatientNewBookingVisitRequestSuccessful(),
                                  ),
                                );
                              }

                              setState(() {
                                _planLoading = false;
                              });
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                            decoration: BoxDecoration(
                              color: App.theme.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: !_planLoading
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Medical Plan",
                                        style: TextStyle(
                                          color: App.theme.darkerText,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Pay with your medical plan (this depends on remaining yearly visits).",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: App.theme.darkerText,
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: AlwaysStoppedAnimation<Color>(App.theme.white!),
                                      ),
                                    ),
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
      ),
    );
  }
}
