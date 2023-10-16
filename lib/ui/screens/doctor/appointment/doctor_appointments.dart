import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/appointment/appointment.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/screens/doctor/appointment/doctor_appointment_en_route.dart';
import 'package:mobile/ui/screens/doctor/appointment/doctor_appointment_summary.dart';
import 'package:mobile/ui/screens/doctor/settings/doctor_availabilities.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DoctorAppointments extends StatefulWidget {
  const DoctorAppointments({Key? key}) : super(key: key);

  @override
  _DoctorAppointmentsState createState() => _DoctorAppointmentsState();
}

class _DoctorAppointmentsState extends State<DoctorAppointments> with TickerProviderStateMixin {
  CalendarController _controller = CalendarController();
  CalendarView _view = CalendarView.day;
  late String activeCalendarView = "Day";
  bool _isDayView = true;
  bool showWeekNumber = false;
  int toggled = 0;
  List<Booking> _bookings = <Booking>[];
  bool bookingsLoading = false;

  @override
  void initState() {
    super.initState();
    startPage();
  }

  Future<void> startPage() async {
    ApiProvider _provider = new ApiProvider();
    if (mounted) {
      setState(() {
        bookingsLoading = true;
      });
      var bookings = await _provider.getDoctorBookings();
      if (bookings != null) {
        setState(() {
          _bookings = bookings;
        });
      }
      setState(() {
        bookingsLoading = false;
      });
    }
  }

  bool isToday() {
    DateTime now = DateTime.now();
    var cDate = _controller.displayDate;
    return (cDate!.year == now.year && cDate.month == now.month && cDate.day == now.day);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Appointments',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 23,
                              color: App.theme.white,
                              letterSpacing: 1,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _controller.displayDate = DateTime.now();
                              });
                            },
                            child: Icon(
                              Icons.calendar_today_rounded,
                              color: App.theme.turquoise,
                            ),
                          )
                        ],
                      ),
                    ),
                    if (_controller.displayDate != null)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width * 0.032,
                                    top: MediaQuery.of(context).size.width * 0.03,
                                    bottom: MediaQuery.of(context).size.width * 0.03,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: Color(0xFF5F626B),
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateFormat.E().format(_controller.displayDate!).toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                          color: (_view == CalendarView.week) ? App.theme.grey700 : Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Container(
                                        padding: EdgeInsets.all(6),
                                        width: MediaQuery.of(context).size.width * 0.073,
                                        height: MediaQuery.of(context).size.width * 0.073,
                                        decoration: BoxDecoration(
                                          color: (_view == CalendarView.week)
                                              ? App.theme.grey700
                                              : (isToday() ? App.theme.turquoise : App.theme.darkBackground),
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        child: Center(
                                          child: Text(
                                            DateFormat.d().format(_controller.displayDate!),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: (_view == CalendarView.week) ? App.theme.grey700 : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 18),
                                GestureDetector(
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: _controller.displayDate!,
                                      firstDate: DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day),
                                      lastDate: DateTime(DateTime.now().add(Duration(days: 365)).year, DateTime.now().add(Duration(days: 365)).month,
                                          DateTime.now().add(Duration(days: 365)).day),
                                      builder: (BuildContext context, Widget? child) {
                                        return Theme(
                                          data: ThemeData(
                                            primaryColor: App.theme.darkBackground,
                                            canvasColor: App.theme.darkBackground,
                                            cardColor: App.theme.darkBackground,
                                            dialogBackgroundColor: App.theme.darkBackground,
                                            backgroundColor: App.theme.darkBackground!,
                                            colorScheme: ColorScheme.light(
                                                onPrimary: Colors.white,
                                                onSurface: App.theme.white!.withOpacity(0.7),
                                                secondary: Colors.red,
                                                background: App.theme.darkBackground!,
                                                primary: App.theme.turquoise!),
                                            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    ).then((pickedDate) {
                                      if (pickedDate == null) {
                                        return;
                                      }
                                      setState(() {
                                        _controller.displayDate = pickedDate;
                                      });
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat.MMM().format(_controller.displayDate!),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: App.theme.white,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        SvgPicture.asset(
                                          "assets/icons/icon_caret_down_filled.svg",
                                          height: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: App.theme.grey700,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _view = _view == CalendarView.day ? CalendarView.week : CalendarView.day;
                                            _controller.view = _view;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: _view == CalendarView.day ? App.theme.turquoise : Colors.transparent,
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                          child: Text(
                                            "DAY",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _view = _view == CalendarView.day ? CalendarView.week : CalendarView.day;
                                            _controller.view = _view;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: _view == CalendarView.week ? App.theme.turquoise : Colors.transparent,
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                          child: Text(
                                            "WEEK",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16),
                                GestureDetector(
                                  child: SvgPicture.asset(
                                    'assets/icons/icon_cog.svg',
                                    height: 25,
                                    width: 25,
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return DoctorAvailabilities();
                                    }));
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: bookingsLoading
                    ? Center(
                        child: Container(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
                          child: SizedBox(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green.withOpacity(0.5)),
                            ),
                            height: MediaQuery.of(context).size.height * 0.03,
                            width: MediaQuery.of(context).size.height * 0.03,
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          SfCalendar(
                            showDatePickerButton: true,
                            allowedViews: [
                              CalendarView.day,
                              CalendarView.week,
                            ],
                            onSelectionChanged: (details) {
                              return;
                            },
                            view: _view,
                            controller: _controller,
                            backgroundColor: App.theme.darkBackground,
                            cellBorderColor: Color(0xFF5F626B),
                            selectionDecoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.transparent, width: 0),
                            ),
                            scheduleViewSettings: ScheduleViewSettings(
                              weekHeaderSettings: WeekHeaderSettings(
                                weekTextStyle: TextStyle(
                                  color: App.theme.btnDarkSecondary,
                                ),
                              ),
                              dayHeaderSettings: DayHeaderSettings(
                                dayTextStyle: TextStyle(color: App.theme.white),
                              ),
                            ),
                            appointmentTextStyle: TextStyle(color: App.theme.white),
                            showCurrentTimeIndicator: true,
                            timeSlotViewSettings: TimeSlotViewSettings(
                              minimumAppointmentDuration: Duration(minutes: 30),
                              allDayPanelColor: Colors.transparent,
                              timeIntervalHeight: 60,
                              timeFormat: 'HH:mm',
                              timeIntervalWidth: 100,
                              timeInterval: const Duration(minutes: 30),
                              timeTextStyle: TextStyle(fontSize: 10, color: App.theme.white),
                            ),
                            weekNumberStyle: WeekNumberStyle(
                                backgroundColor: App.theme.turquoise,
                                textStyle: TextStyle(
                                  color: App.theme.white,
                                  fontWeight: FontWeight.bold,
                                )),
                            headerHeight: 0,
                            viewHeaderHeight: _view == CalendarView.day ? 0 : 60,
                            onViewChanged: (ViewChangedDetails viewChangedDetails) {
                              SchedulerBinding.instance.addPostFrameCallback((duration) {
                                setState(() {
                                  if (_controller.view == CalendarView.week) {
                                    showWeekNumber = true;
                                    _isDayView = false;
                                  } else {
                                    showWeekNumber = false;
                                    _isDayView = true;
                                  }
                                });
                              });
                            },
                            headerDateFormat: 'MMMM ',
                            todayHighlightColor: App.theme.turquoise,
                            headerStyle: CalendarHeaderStyle(
                              backgroundColor: App.theme.grey700,
                              textStyle: TextStyle(
                                color: App.theme.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            viewHeaderStyle: ViewHeaderStyle(
                              backgroundColor: App.theme.grey700,
                              dateTextStyle: TextStyle(color: App.theme.white, fontWeight: FontWeight.bold),
                              dayTextStyle: TextStyle(fontWeight: FontWeight.bold, color: App.theme.white),
                            ),
                            dataSource: MeetingDataSource(_getDataSource()),
                            appointmentBuilder: appointmentBuilder,
                          ),
                          if (App.currentUser.workHours.length <= 0)
                            Positioned(
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'You have not setup work hours',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: App.theme.turquoise,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Please make sure you have set your availabilities and offering radius.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: App.theme.darkText!.withOpacity(0.8), fontSize: 14),
                                      ),
                                      SizedBox(height: 12),
                                      ElevatedButton(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                            vertical: 12.0,
                                          ),
                                          child: Text(
                                            "Setup",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: App.theme.white,
                                            ),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: App.theme.white,
                                          backgroundColor: App.theme.turquoise,
                                          elevation: 0,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) {
                                              return DoctorAvailabilities();
                                            }),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<HatAppointment> _getDataSource() {
    final List<HatAppointment> meetings = <HatAppointment>[];
    _bookings.forEach((booking) {
      if (booking.startTime == null || booking.startTime!.isEmpty) return;
      final DateTime startTime = DateTime.parse(
          "${booking.selectedDate.year}-${booking.selectedDate.month.toString().padLeft(2, '0')}-${booking.selectedDate.day.toString().padLeft(2, '0')} ${Utilities.paddedTime(booking.startTime!)}");
      final DateTime endTime = startTime.add(const Duration(hours: 1));

      AppointmentStatus _status = AppointmentStatus.NEW;
      Color _color = Color(0xFF059669);
      String _action = '';
      String _icon = '';

      if (booking.status.toLowerCase() == 'pending' && booking.selectedDoctor!.id == App.currentUser.doctorProfile!.id) {
        _color = Color(0xFFF7CE46);
        _status = AppointmentStatus.DOCTOR_NEW_PENDING;
        _action = 'Review & Confirm';
        _icon = 'assets/icons/icon_like.svg';
      } else if (booking.status.toLowerCase() == 'pending') {
        _color = Color(0xFFF7CE46);
        _status = AppointmentStatus.ASAP_NEW_PENDING;
        _action = 'Review & Claim';
        _icon = 'assets/icons/icon_like.svg';
      } else if (booking.status.toLowerCase() == 'confirmed') {
        _color = App.theme.turquoise!;
        _status = AppointmentStatus.CONFIRMED;
        _action = 'View File';
        _icon = 'assets/icons/icon_file.svg';
      } else if (booking.status.toLowerCase() == 'en-route') {
        _color = App.theme.red500!;
        _status = AppointmentStatus.EN_ROUTE;
        _action = 'Start Travelling';
        _icon = 'assets/icons/icon_map.svg';
      } else if (booking.status.toLowerCase() == 'complete' && booking.report == null) {
        _color = App.theme.purple!;
        _status = AppointmentStatus.COMPLETED_NO_REPORT;
        _action = 'File Report';
        _icon = 'assets/icons/icon_edit.svg';
      } else if (booking.status.toLowerCase() == 'complete' && booking.report != null) {
        _color = App.theme.green500!;
        _status = AppointmentStatus.COMPLETED_WITH_REPORT;
        _action = 'Report Complete';
        _icon = 'assets/icons/icon_check.svg';
      }

      meetings.add(
        HatAppointment(
          booking,
          booking.patient!.displayName,
          startTime,
          endTime,
          false,
          booking.address,
          booking.primaryService.name,
          _status,
          _color,
          _action,
          _icon,
        ),
      );
    });

    return meetings;
  }

  Widget appointmentBuilder(BuildContext context, CalendarAppointmentDetails calendarAppointmentDetails) {
    final HatAppointment appointment = calendarAppointmentDetails.appointments.first;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          print(appointment.booking.status.toLowerCase());
          return appointment.booking.status.toLowerCase() == 'en-route'
              ? DoctorAppointmentEnRoute(bookingId: appointment.booking.id)
              : DoctorAppointmentSummary(bookingId: appointment.booking.id);
        }));
      },
      child: Container(
        child: _isDayView
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  (appointment.to.difference(appointment.from).inHours < 1)
                      ? Container(
                          width: calendarAppointmentDetails.bounds.width,
                          height: calendarAppointmentDetails.bounds.height / 2,
                          margin: EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: appointment.backgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(appointment.subject,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 10,
                                          color: App.theme.white,
                                        )),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(appointment.action.toUpperCase(),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                              color: App.theme.white,
                                              decoration: appointment.status == AppointmentStatus.COMPLETED_WITH_REPORT
                                                  ? TextDecoration.none
                                                  : TextDecoration.underline,
                                            )),
                                        SizedBox(width: 4),
                                        SvgPicture.asset(
                                          appointment.icon,
                                          width: 12,
                                          color: App.theme.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          width: calendarAppointmentDetails.bounds.width,
                          height: calendarAppointmentDetails.bounds.height / 2,
                          margin: EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: appointment.status == AppointmentStatus.DOCTOR_NEW_PENDING ? Colors.transparent : appointment.backgroundColor,
                          ),
                          child:
                              (appointment.status == AppointmentStatus.DOCTOR_NEW_PENDING || appointment.status == AppointmentStatus.ASAP_NEW_PENDING)
                                  ? DottedBorder(
                                      borderType: BorderType.RRect,
                                      strokeWidth: 1,
                                      dashPattern: const [6, 2],
                                      radius: Radius.circular(5),
                                      color: appointment.backgroundColor,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(appointment.subject,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w900,
                                                      fontSize: 12,
                                                      color: App.theme.white,
                                                    )),
                                                Text(appointment.services.toUpperCase(),
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 11,
                                                      color: App.theme.white,
                                                    )),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    SvgPicture.asset('assets/icons/icon_location.svg', width: 12, color: App.theme.white),
                                                    SizedBox(width: 4),
                                                    Container(
                                                      child: Text(
                                                          appointment.locationR.toUpperCase().substring(0, 16) +
                                                              (appointment.locationR.length > 16 ? ' ...' : ''),
                                                          textAlign: TextAlign.start,
                                                          softWrap: true,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 11,
                                                            color: App.theme.white!.withOpacity(0.8),
                                                          )),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(appointment.action.toUpperCase(),
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 11,
                                                          color: App.theme.white,
                                                          decoration: appointment.status == AppointmentStatus.COMPLETED_WITH_REPORT
                                                              ? TextDecoration.none
                                                              : TextDecoration.underline,
                                                        )),
                                                    SizedBox(width: 4),
                                                    SvgPicture.asset(appointment.icon, width: 14),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(appointment.subject,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 12,
                                                    color: App.theme.white,
                                                  )),
                                              Text(appointment.services.toUpperCase(),
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                    color: App.theme.white,
                                                  )),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SvgPicture.asset('assets/icons/icon_location.svg', width: 12, color: App.theme.white),
                                                  SizedBox(width: 4),
                                                  Container(
                                                    child: Text(
                                                        appointment.locationR.length > 16
                                                            ? appointment.locationR.toUpperCase().substring(0, 16) +
                                                                (appointment.locationR.length > 16 ? ' ...' : '')
                                                            : appointment.locationR.toUpperCase(),
                                                        textAlign: TextAlign.start,
                                                        softWrap: true,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 11,
                                                          color: App.theme.white!.withOpacity(0.8),
                                                        )),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(appointment.action.toUpperCase(),
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 11,
                                                        color: App.theme.white,
                                                        decoration: appointment.status == AppointmentStatus.COMPLETED_WITH_REPORT
                                                            ? TextDecoration.none
                                                            : TextDecoration.underline,
                                                      )),
                                                  SizedBox(width: 4),
                                                  SvgPicture.asset(appointment.icon, width: 14),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                        ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: calendarAppointmentDetails.bounds.width,
                    height: calendarAppointmentDetails.bounds.height / 2,
                    decoration: BoxDecoration(
                      color: appointment.backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(3),
                      child: Container(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
