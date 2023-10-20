import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/ui/partials/patient_select_list_card.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_new_booking_address.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_primary_service.dart';

class PatientAppointmentNewBookingServiceType extends StatefulWidget {
  const PatientAppointmentNewBookingServiceType({Key? key}) : super(key: key);

  @override
  _PatientAppointmentNewBookingServiceTypeState createState() =>
      _PatientAppointmentNewBookingServiceTypeState();
}

class _PatientAppointmentNewBookingServiceTypeState
    extends State<PatientAppointmentNewBookingServiceType> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.turquoise50,
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
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
                Spacer(),
                Text(
                  'How would you like to book?',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 19,
                    color: App.theme.grey900,
                  ),
                ),
                SizedBox(height: 8),
                PatientSelectListCard(
                  title: 'Select Primary Service',
                  onPressed: () {
                    App.progressBooking!.bookingCriteria =
                        BookingCriteria.SELECT_PROVIDERS;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      if (App.progressBooking!.bookingFlow ==
                          BookingFlow.HOME_PLUS) {
                        return PatientPrimaryService();
                      } else {
                        return PatientNewBookingAddress(isEdit: false);
                      }
                    }));
                  },
                ),
                SizedBox(height: 8),
                PatientSelectListCard(
                  title: 'Book an Urgent Visit',
                  onPressed: () {
                    App.progressBooking!.bookingCriteria = BookingCriteria.ASAP;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      if (App.progressBooking!.bookingFlow ==
                          BookingFlow.HOME_PLUS) {
                        return PatientPrimaryService();
                      } else {
                        return PatientNewBookingAddress(isEdit: false);
                      }
                    }));
                  },
                ),
                SizedBox(height: 8),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
