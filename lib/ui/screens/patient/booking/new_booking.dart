import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/patient_select_list_card.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';
import 'package:mobile/ui/screens/patient/booking/new_booking_service_type.dart';
import 'package:mobile/ui/screens/patient/booking/new_booking_someone_else.dart';

class PatientAppointmentNewBooking extends StatefulWidget {
  PatientAppointmentNewBooking({Key? key}) : super(key: key) {
    Utilities.getUserLocation();
  }

  @override
  _PatientAppointmentNewBookingState createState() => _PatientAppointmentNewBookingState();
}

class _PatientAppointmentNewBookingState extends State<PatientAppointmentNewBooking> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        extendBody: true,
        backgroundColor: App.theme.turquoise50,
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
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
                Spacer(),
                Text(
                  'Who is the appointment for?',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 19,
                    color: App.theme.grey900,
                  ),
                ),
                SizedBox(height: 8),
                PatientSelectListCard(
                  title: 'Myself',
                  onPressed: () {
                    App.progressBooking!.bookingFor = BookingFor.SELF;
                    App.progressBooking!.dependent = null;
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return PatientAppointmentNewBookingServiceType();
                    }));
                  },
                ),
                SizedBox(height: 8),
                PatientSelectListCard(
                  title: 'Someone Else',
                  onPressed: () {
                    App.progressBooking!.bookingFor = BookingFor.SOMEONE;
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return PatientAppointmentSomeoneElse();
                    }));
                  },
                ),
                SizedBox(height: 8),
                Text(
                  'Note: You need the legal right and/or consent to make medical decisions on behalf of a dependent.',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: App.theme.grey600,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
