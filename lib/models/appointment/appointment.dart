import 'dart:ui';

import 'package:mobile/models/booking/booking.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HatAppointment extends Appointment {
  Booking booking;
  String eventName;
  DateTime from;
  DateTime to;
  bool isAllDay;
  String locationR;
  String services;
  AppointmentStatus status;
  Color backgroundColor;
  String action;
  String icon;

  HatAppointment(this.booking, this.eventName, this.from, this.to, this.isAllDay, this.locationR, this.services, this.status, this.backgroundColor, this.action, this.icon)
      : super(endTime: to, startTime: from, subject: eventName);
}

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<HatAppointment>? source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getAppointmentData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getAppointmentData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getAppointmentData(index).eventName;
  }

  @override
  bool isAllDay(int index) {
    return _getAppointmentData(index).isAllDay;
  }

  HatAppointment _getAppointmentData(int index) {
    final dynamic appointment = appointments![index];
    late final HatAppointment appointmentData;
    if (appointment is HatAppointment) {
      appointmentData = appointment;
    }

    return appointmentData;
  }
}

enum AppointmentStatus { COMPLETED_NO_REPORT, COMPLETED_WITH_REPORT, CONFIRMED, REPORT_PENDING, NEW, DOCTOR_NEW_PENDING, ASAP_NEW_PENDING, EN_ROUTE }
