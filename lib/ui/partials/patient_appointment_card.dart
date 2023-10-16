import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/screens/patient_appointment_summary_tracking/patient_appointment_summary.dart';

class PatientAppointmentCard extends StatefulWidget {
  final Function callBack;
  final Booking booking;

  PatientAppointmentCard({required this.booking, required this.callBack});

  @override
  _PatientAppointmentCardState createState() => _PatientAppointmentCardState();
}

class _PatientAppointmentCardState extends State<PatientAppointmentCard> {
  Color? appointmentStatusColor = App.theme.turquoise;
  String _bookingAction = '';

  @override
  Widget build(BuildContext context) {
    setState(() {
      switch (widget.booking.status.toUpperCase()) {
        case 'PENDING':
          appointmentStatusColor = App.theme.orange;
          break;
        case 'CONFIRMED':
          appointmentStatusColor = App.theme.green500;
          break;
        case 'EN-ROUTE':
          appointmentStatusColor = App.theme.red;
          _bookingAction = 'Track';
          break;
        case 'CANCELLED':
          appointmentStatusColor = App.theme.turquoise;
          _bookingAction = !widget.booking.isEmergency ? 'Re-Book' : '';
          break;
        case 'DECLINED':
          appointmentStatusColor = App.theme.turquoise;
          _bookingAction = !widget.booking.isEmergency ? 'Re-Book' : '';
          break;
        case 'COMPLETE':
          appointmentStatusColor = App.theme.turquoise;
          break;
      }
    });

    return GestureDetector(
      onTap: () {
        widget.callBack();
        App.progressBooking = Booking.init();
        if (_bookingAction.toLowerCase() == 're-book') {
          App.progressBooking!.id = widget.booking.id;
          App.progressBooking!.isRebook = true;
          App.progressBooking!.addOnService = widget.booking.addOnService;
          App.progressBooking!.address = widget.booking.address;
          App.progressBooking!.addressNotes = widget.booking.addressNotes;
          App.progressBooking!.latitude = widget.booking.latitude;
          App.progressBooking!.longitude = widget.booking.longitude;
          App.progressBooking!.bookingReason = widget.booking.bookingReason;
          App.progressBooking!.selectedDoctor = widget.booking.selectedDoctor;
          App.progressBooking!.bookingFor = widget.booking.bookingFor;
          App.progressBooking!.dependent = widget.booking.dependent;
          App.progressBooking!.primaryService = widget.booking.primaryService;
          App.progressBooking!.secondaryServices = widget.booking.secondaryServices;
          App.progressBooking!.bookingCriteria = BookingCriteria.SELECT_PROVIDERS;
          App.progressBooking!.bookingFlow = BookingFlow.HOME_PLUS;

          for (final e in App.progressBooking!.secondaryServices) {
            App.progressBooking!.totalPrice += e.price;
          }

          App.progressBooking!.totalPrice += App.progressBooking!.primaryService.price;
          if (App.progressBooking!.addOnService != null) {
            App.progressBooking!.totalPrice += App.progressBooking!.addOnService!.price;
          }
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PatientAppointmentSummary(bookingId: widget.booking.id);
        }));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: App.theme.white!,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: App.theme.grey!.withOpacity(0.05),
              spreadRadius: 8,
              blurRadius: 10,
              offset: Offset(-2, -2), // changes position of shadow
            ),
          ],
        ),
        child: ListTile(
          title: RichText(
            text: TextSpan(
              text: DateFormat.E().format(widget.booking.selectedDate) +
                  ', ' +
                  DateFormat.MMM().format(widget.booking.selectedDate) +
                  ' ' +
                  DateFormat.d().format(widget.booking.selectedDate) +
                  Utilities.getDayOfMonthSuffix(widget.booking.selectedDate.day) +
                  ', ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: App.theme.grey900,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: widget.booking.startTime != null ? widget.booking.startTime! + ' - ' + widget.booking.endTime! : '',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: App.theme.grey900,
                    )),
              ],
            ),
          ),
          subtitle: Text(
            widget.booking.selectedDoctor != null
                ? ((widget.booking.selectedDoctor!.title.isNotEmpty ? widget.booking.selectedDoctor!.title.replaceAll('.', '') + '. ' : '') +
                            Utilities.convertToTitleCase(widget.booking.selectedDoctor!.displayName))
                        .toUpperCase() +
                    (widget.booking.isReview ? ' (Review)' : '')
                : 'URGENT VISIT',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: App.theme.grey500,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.booking.status.toUpperCase(),
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: appointmentStatusColor,
                ),
              ),
              if (_bookingAction.isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: 4),
                    Text(
                      _bookingAction.toUpperCase(),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: appointmentStatusColor,
                      ),
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
