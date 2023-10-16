import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking_notification.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/ui/screens/doctor/partials/doctor_notification_card.dart';

import '../appointment/doctor_appointment_en_route.dart';
import '../appointment/doctor_appointment_summary.dart';

class DoctorNotification extends StatefulWidget {
  const DoctorNotification({Key? key}) : super(key: key);

  @override
  _DoctorNotificationState createState() => _DoctorNotificationState();
}

class _DoctorNotificationState extends State<DoctorNotification> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          child: Text(
            'Notifications',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 23,
              color: App.theme.white,
              letterSpacing: 1,
            ),
          ),
        ),
        FutureBuilder<List<BookingNotification>?>(
          future: BookingNotification.getNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
                child: Container(
                  child: SizedBox(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(App.theme.turquoise!),
                      strokeWidth: 3,
                    ),
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.height * 0.04,
                  ),
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.length > 0) {
              App.notificationCounter = snapshot.data!.length;
              return Expanded(
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      BookingNotification _notification = snapshot.data![index];
                      return GestureDetector(
                        onTap: () async {
                            BookingNotification.markSeen();
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return _notification.booking.status.toLowerCase() == 'en-route'
                                  ? DoctorAppointmentEnRoute(bookingId: _notification.booking.id, notificationId: _notification.id)
                                  : DoctorAppointmentSummary(bookingId: _notification.booking.id, notificationId: _notification.id);
                            })).then((value) => setState(() {}));
                        },
                        child: DoctorNotificationCard(
                          notification: _notification,
                        ),
                      );
                    },
                  ),
                ),
              );
            } else {
              return Container(
                padding: EdgeInsets.all(16),
                child: Text('You have no notifications yet'),
              );
            }
          },
        ),
      ],
    );
  }
}
