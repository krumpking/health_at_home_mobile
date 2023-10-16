import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/my_app_bar.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';

class DoctorSpecificRequested extends StatefulWidget {
  final int bookingId;
  const DoctorSpecificRequested({Key? key, required this.bookingId}) : super(key: key);

  @override
  _DoctorSpecificRequestedState createState() => _DoctorSpecificRequestedState();
}

class _DoctorSpecificRequestedState extends State<DoctorSpecificRequested> {
  late final Booking _booking;
  bool confirmLoading = false;
  bool cancelLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _booking = Utilities.getBookingById(widget.bookingId)!;
    });
  }

  Future<void> _confirmBookingDialog() async {
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
                SvgPicture.asset('assets/icons/icon_success.svg'),
                SizedBox(height: 24),
                Text(
                  'Appointment Confirmed',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: App.theme.white),
                ),
                SizedBox(height: 16),
                Text(
                  'This appointment has been confirmed. We have let the patient know.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.mutedLightColor),
                ),
                SizedBox(height: 16),
                SuccessRegularButton(
                  title: 'OK',
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => DoctorHome()), (Route<dynamic> route) => false);
                  },
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _cancelBookingDialog() async {
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
                  'Appointment Cancelled',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: App.theme.white),
                ),
                SizedBox(height: 16),
                Text(
                  'This appointment has been cancelled. The patient will have the option to re-book another time or with another practitioner.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.mutedLightColor),
                ),
                SizedBox(height: 16),
                DangerRegularButton(
                  title: 'Back to Home Page',
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => DoctorHome()), (Route<dynamic> route) => false);
                  },
                ),
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
    return DarkStatusNavigationBarWidget(
      child: Scaffold(
        appBar: myAppBar(),
        body: Container(
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
                    SizedBox(height: 16),
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
                      Utilities.convertToTitleCase(_booking.patient!.displayName),
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reason for Appointment',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: App.theme.white,
                      ),
                    ),
                    Text(
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
                              fontSize: 18,
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
                      )
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    confirmLoading
                        ? PrimaryButtonLoading()
                        : PrimaryLargeButton(
                            title: 'Confirm Appointment',
                            iconWidget: SizedBox(),
                            onPressed: () {
                              setState(() {
                                confirmLoading = true;
                              });
                              ApiProvider _provider = new ApiProvider();
                              _provider.updateDoctorBookingStatus({'bookingId': widget.bookingId, 'status': 'confirmed'}).then((success) {
                                setState(() {
                                  confirmLoading = false;
                                });
                                if (success) {
                                  _confirmBookingDialog();
                                }
                              });
                            }),
                    SizedBox(height: 16),
                    cancelLoading
                        ? SecondaryButtonLoading()
                        : SecondaryLargeButton(
                            title: 'Decline Appointment',
                            onPressed: () {
                              setState(() {
                                cancelLoading = true;
                              });
                              ApiProvider _provider = new ApiProvider();
                              _provider.updateDoctorBookingStatus({'bookingId': widget.bookingId, 'status': 'declined'}).then((success) {
                                setState(() {
                                  cancelLoading = false;
                                });
                                if (success) {
                                  _cancelBookingDialog();
                                }
                              });
                            }),
                    SizedBox(height: 16),
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
