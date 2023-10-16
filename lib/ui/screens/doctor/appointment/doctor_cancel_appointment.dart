import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';

import 'doctor_appointment_summary.dart';

class DoctorCancelAppointment extends StatefulWidget {
  final Booking booking;
  const DoctorCancelAppointment({Key? key, required this.booking}) : super(key: key);

  @override
  _DoctorCancelAppointmentState createState() => _DoctorCancelAppointmentState();
}

class _DoctorCancelAppointmentState extends State<DoctorCancelAppointment> {
  String _groupValue = 'Emergency';
  late Booking _booking;
  final reasonsController = TextEditingController();
  bool _showReasonError = false;
  bool _fieldEnabled = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _booking = widget.booking;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DarkStatusNavigationBarWidget(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: App.theme.darkBackground,
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
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Appointment File',
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
                          SizedBox(height: 24),
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reason for Cancellation',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: App.theme.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Theme(
                        data: ThemeData(
                          unselectedWidgetColor: App.theme.mutedLightColor,
                        ),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'Emergency',
                              groupValue: _groupValue,
                              onChanged: handleRadio,
                              activeColor: App.theme.turquoise,
                            ),
                            GestureDetector(
                              child: Text(
                                'Emergency',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: App.theme.mutedLightColor,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _groupValue = 'Emergency';
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Theme(
                        data: ThemeData(
                          unselectedWidgetColor: App.theme.mutedLightColor,
                        ),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'Another',
                              groupValue: _groupValue,
                              onChanged: handleRadio,
                              activeColor: App.theme.turquoise,
                            ),
                            GestureDetector(
                              child: Text(
                                'Another Appointment',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: App.theme.mutedLightColor,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _groupValue = 'Another';
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Theme(
                        data: ThemeData(
                          unselectedWidgetColor: App.theme.mutedLightColor,
                        ),
                        child: Row(
                          children: [
                            Radio(
                              value: 'Other',
                              groupValue: _groupValue,
                              onChanged: handleRadio,
                              activeColor: App.theme.turquoise,
                            ),
                            GestureDetector(
                              child: Text(
                                'Other',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: App.theme.mutedLightColor,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _groupValue = 'Other';
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: TextFormField(
                          maxLines: 5,
                          enabled: _fieldEnabled,
                          style: TextStyle(fontSize: 18, color: App.theme.white),
                          controller: reasonsController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              fillColor: _fieldEnabled ? App.theme.mutedLightColor : App.theme.mutedLightFillColor,
                              filled: true,
                              hintText: 'Type other reasons here...',
                              hintStyle: TextStyle(fontSize: 18, color: App.theme.lightText),
                              contentPadding: EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF131825), width: 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF131825), width: 1.0), borderRadius: BorderRadius.circular(10.0))),
                        ),
                      ),
                      if (_showReasonError)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 18),
                          child: Text(
                            'Field Required',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _loading
                            ? PrimaryButtonLoading()
                            : PrimaryLargeButton(
                                title: 'Confirm Cancellation',
                                iconWidget: SizedBox(),
                                onPressed: () {
                                  setState(() {
                                    _loading = true;
                                    _showReasonError = false;
                                  });
                                  int reason = _groupValue == 'Emergency' ? 1 : (_groupValue == 'Another' ? 2 : 3);

                                  if (reason == 3 && reasonsController.value.text.isEmpty) {
                                    setState(() {
                                      _showReasonError = true;
                                      _loading = false;
                                    });
                                    return;
                                  }

                                  var payload = {
                                    'bookingId': _booking.id,
                                    'status': 'cancelled',
                                    'reason': reason,
                                    'otherReasons': reasonsController.value.text
                                  };

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
                                      _loading = false;
                                    });
                                  });
                                }),
                        SizedBox(height: 16),
                        SecondaryLargeButton(
                            title: 'Keep Appointment',
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void handleRadio(String? value) {
    setState(() {
      _groupValue = value!;
    });

    if (_groupValue == 'Other') {
      setState(() {
        _fieldEnabled = true;
      });
    } else {
      setState(() {
        _fieldEnabled = false;
      });
    }
  }
}
