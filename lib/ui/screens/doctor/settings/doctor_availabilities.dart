import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/user/workHour.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
// import 'package:time_picker_widget/time_picker_widget.dart';

import 'base_location.dart';

class DoctorAvailabilities extends StatefulWidget {
  const DoctorAvailabilities({Key? key}) : super(key: key);

  @override
  _DoctorAvailabilitiesState createState() => _DoctorAvailabilitiesState();
}

class _DoctorAvailabilitiesState extends State<DoctorAvailabilities> {
  late WorkHour? monday;
  late WorkHour? tuesday;
  late WorkHour? wednesday;
  late WorkHour? thursday;
  late WorkHour? friday;
  late WorkHour? saturday;
  late WorkHour? sunday;

  late bool mondaySelected;
  late bool tuesdaySelected;
  late bool wednesdaySelected;
  late bool thursdaySelected;
  late bool fridaySelected;
  late bool saturdaySelected;
  late bool sundaySelected;

  late String mondayError = '';
  late String tuesdayError = '';
  late String wednesdayError = '';
  late String thursdayError = '';
  late String fridayError = '';
  late String saturdayError = '';
  late String sundayError = '';

  List<String> _radiusDistance = [
    '10km',
    '20km',
    '30km',
    '40km',
    '50km',
    '60km',
    '100km'
  ];

  var _timeOff = App.currentUser.doctorProfile!.isAway;
  var _timeOffStatus = App.currentUser.doctorProfile!.isAway ? 'On' : 'Off';
  late String _distanceHint = 'Select';

  final locationController = TextEditingController();

  DateTime _selectedFromDate = App.currentUser.doctorProfile!.isAway
      ? App.currentUser.doctorProfile!.holidayFrom!
      : DateTime.now();
  DateTime _selectedToDate = App.currentUser.doctorProfile!.isAway
      ? App.currentUser.doctorProfile!.holidayTo!
      : DateTime.now().add(Duration(days: 1));

  late TimeOfDay _mondayFrom = TimeOfDay(hour: 6, minute: 0);
  late TimeOfDay _mondayTo = TimeOfDay(hour: 16, minute: 0);
  late TimeOfDay _tuesdayFrom = TimeOfDay(hour: 6, minute: 0);
  late TimeOfDay _tuesdayTo = TimeOfDay(hour: 16, minute: 0);
  late TimeOfDay _wednesdayFrom = TimeOfDay(hour: 6, minute: 0);
  late TimeOfDay _wednesdayTo = TimeOfDay(hour: 16, minute: 0);
  late TimeOfDay _thursdayFrom = TimeOfDay(hour: 6, minute: 0);
  late TimeOfDay _thursdayTo = TimeOfDay(hour: 16, minute: 0);
  late TimeOfDay _fridayFrom = TimeOfDay(hour: 6, minute: 0);
  late TimeOfDay _fridayTo = TimeOfDay(hour: 16, minute: 0);
  late TimeOfDay _saturdayFrom = TimeOfDay(hour: 6, minute: 0);
  late TimeOfDay _saturdayTo = TimeOfDay(hour: 16, minute: 0);
  late TimeOfDay _sundayFrom = TimeOfDay(hour: 6, minute: 0);
  late TimeOfDay _sundayTo = TimeOfDay(hour: 16, minute: 0);

  bool showToolTip = false;
  String _error = '';
  late bool _loading = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      monday = Utilities.findWorkHourByDay('Mon');
      tuesday = Utilities.findWorkHourByDay('Tue');
      wednesday = Utilities.findWorkHourByDay('Wed');
      thursday = Utilities.findWorkHourByDay('Thu');
      friday = Utilities.findWorkHourByDay('Fri');
      saturday = Utilities.findWorkHourByDay('Sat');
      sunday = Utilities.findWorkHourByDay('Sun');

      mondaySelected = monday != null;
      tuesdaySelected = tuesday != null;
      wednesdaySelected = wednesday != null;
      thursdaySelected = thursday != null;
      fridaySelected = friday != null;
      saturdaySelected = saturday != null;
      sundaySelected = sunday != null;

      if (monday != null) _mondayFrom = monday!.getFrom;
      if (monday != null) _mondayTo = monday!.getTo;
      if (tuesday != null) _tuesdayFrom = tuesday!.getFrom;
      if (tuesday != null) _tuesdayTo = tuesday!.getTo;
      if (wednesday != null) _wednesdayFrom = wednesday!.getFrom;
      if (wednesday != null) _wednesdayTo = wednesday!.getTo;
      if (thursday != null) _thursdayFrom = thursday!.getFrom;
      if (thursday != null) _thursdayTo = thursday!.getTo;
      if (friday != null) _fridayFrom = friday!.getFrom;
      if (friday != null) _fridayTo = friday!.getTo;
      if (saturday != null) _saturdayFrom = saturday!.getFrom;
      if (saturday != null) _saturdayTo = saturday!.getTo;
      if (sunday != null) _sundayFrom = sunday!.getFrom;
      if (sunday != null) _sundayTo = sunday!.getTo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: DarkStatusNavigationBarWidget(
          child: Scaffold(
            backgroundColor: App.theme.darkBackground,
            body: SafeArea(
              child: Listener(
                onPointerDown: (details) {
                  setState(() {
                    showToolTip = false;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: App.theme.grey700!,
                      ))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Availabilities',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 23,
                              color: App.theme.white,
                              letterSpacing: 1,
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
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Days & Times',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: App.theme.white,
                                ),
                              ),
                            ),
                            if (_error.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(_error,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: App.theme.errorRedColor,
                                    )),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            unselectedWidgetColor:
                                                App.theme.turquoise,
                                          ),
                                          child: Checkbox(
                                            checkColor:
                                                App.theme.darkBackground,
                                            focusColor: App.theme.turquoise,
                                            activeColor: App.theme.turquoise,
                                            value: mondaySelected,
                                            onChanged: (newValue) {
                                              toggleWorkHour('Mon', newValue!);
                                              setState(() {
                                                mondaySelected = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              mondaySelected = !mondaySelected;
                                            });
                                          },
                                          child: SizedBox(
                                            width: 40,
                                            child: Text('Mon',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color:
                                                      App.theme.mutedLightColor,
                                                )),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                              child: Container(
                                                margin: EdgeInsets.all(4),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12.0),
                                                decoration: BoxDecoration(
                                                  color: App.theme.darkGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      color:
                                                          (App.theme.darkGrey)!,
                                                      style: BorderStyle.solid,
                                                      width: 0.1),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      monday != null
                                                          ? _mondayFrom
                                                              .format(context)
                                                          : '-- : --',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: App.theme.white,
                                                      )),
                                                ),
                                              ),
                                              onTap: () async {
                                                if (mondaySelected) {
                                                  // showCustomTimePicker(
                                                  //     context: context,
                                                  //     // It is a must if you provide selectableTimePredicate
                                                  //     onFailValidation:
                                                  //         (context) => null,
                                                  //     initialTime: TimeOfDay(
                                                  //         hour:
                                                  //             _mondayFrom.hour,
                                                  //         minute: _mondayFrom
                                                  //             .minute),
                                                  //     selectableTimePredicate:
                                                  //         (time) =>
                                                  //             time!.minute %
                                                  //                 30 ==
                                                  //             0).then((time) {
                                                  //   setState(() {
                                                  //     _mondayFrom = time!;
                                                  //     monday!.from =
                                                  //         time.format(context);
                                                  //   });
                                                  // });
                                                }
                                              }),
                                        ),
                                        SizedBox(
                                            width: 10,
                                            child: Divider(
                                              thickness: 1.0,
                                              color: App.theme.grey,
                                            )),
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                              child: Container(
                                                margin: EdgeInsets.all(4),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12.0),
                                                decoration: BoxDecoration(
                                                  color: App.theme.darkGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      color:
                                                          (App.theme.darkGrey)!,
                                                      style: BorderStyle.solid,
                                                      width: 0.1),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      monday != null
                                                          ? _mondayTo
                                                              .format(context)
                                                          : '-- : --',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: App.theme.white,
                                                      )),
                                                ),
                                              ),
                                              onTap: () async {
                                                if (mondaySelected) {
                                                  // showCustomTimePicker(
                                                  //     context: context,
                                                  //     // It is a must if you provide selectableTimePredicate
                                                  //     onFailValidation:
                                                  //         (context) => null,
                                                  //     initialTime: TimeOfDay(
                                                  //         hour: _mondayTo.hour,
                                                  //         minute:
                                                  //             _mondayTo.minute),
                                                  //     selectableTimePredicate:
                                                  //         (time) =>
                                                  //             time!.minute %
                                                  //                 30 ==
                                                  //             0).then((time) {
                                                  //   setState(() {
                                                  //     _mondayTo = time!;
                                                  //     monday!.to =
                                                  //         time.format(context);
                                                  //   });
                                                  // });
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (mondayError.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                    'Error: Finish time must be after start time.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: App.theme.errorRedColor,
                                    )),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            unselectedWidgetColor:
                                                App.theme.turquoise,
                                          ),
                                          child: Checkbox(
                                            checkColor:
                                                App.theme.darkBackground,
                                            focusColor: App.theme.turquoise,
                                            activeColor: App.theme.turquoise,
                                            value: tuesdaySelected,
                                            onChanged: (newValue) {
                                              toggleWorkHour('Tue', newValue!);
                                              setState(() {
                                                tuesdaySelected = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              tuesdaySelected =
                                                  !tuesdaySelected;
                                            });
                                          },
                                          child: SizedBox(
                                            width: 40,
                                            child: Text('Tue',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color:
                                                      App.theme.mutedLightColor,
                                                )),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                              child: Container(
                                                margin: EdgeInsets.all(4),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12.0),
                                                decoration: BoxDecoration(
                                                  color: App.theme.darkGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      color:
                                                          (App.theme.darkGrey)!,
                                                      style: BorderStyle.solid,
                                                      width: 0.1),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      tuesday != null
                                                          ? _tuesdayFrom
                                                              .format(context)
                                                          : '-- : --',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: App.theme.white,
                                                      )),
                                                ),
                                              ),
                                              onTap: () async {
                                                if (tuesdaySelected) {
                                                  // showCustomTimePicker(
                                                  //     context: context,
                                                  //     // It is a must if you provide selectableTimePredicate
                                                  //     onFailValidation:
                                                  //         (context) => null,
                                                  //     initialTime: TimeOfDay(
                                                  //         hour:
                                                  //             _tuesdayFrom.hour,
                                                  //         minute: _tuesdayFrom
                                                  //             .minute),
                                                  //     selectableTimePredicate:
                                                  //         (time) =>
                                                  //             time!.minute %
                                                  //                 30 ==
                                                  //             0).then((time) {
                                                  //   setState(() {
                                                  //     _tuesdayFrom = time!;
                                                  //     tuesday!.from =
                                                  //         time.format(context);
                                                  //   });
                                                  // });
                                                }
                                              }),
                                        ),
                                        SizedBox(
                                            width: 10,
                                            child: Divider(
                                              thickness: 1.0,
                                              color: App.theme.grey,
                                            )),
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                              child: Container(
                                                margin: EdgeInsets.all(4),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12.0),
                                                decoration: BoxDecoration(
                                                  color: App.theme.darkGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      color:
                                                          (App.theme.darkGrey)!,
                                                      style: BorderStyle.solid,
                                                      width: 0.1),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      tuesday != null
                                                          ? _tuesdayTo
                                                              .format(context)
                                                          : '-- : --',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: App.theme.white,
                                                      )),
                                                ),
                                              ),
                                              onTap: () async {
                                                if (tuesdaySelected) {
                                                  // showCustomTimePicker(
                                                  //     context: context,
                                                  //     // It is a must if you provide selectableTimePredicate
                                                  //     onFailValidation:
                                                  //         (context) => null,
                                                  //     initialTime: TimeOfDay(
                                                  //         hour: _tuesdayTo.hour,
                                                  //         minute: _tuesdayTo
                                                  //             .minute),
                                                  //     selectableTimePredicate:
                                                  //         (time) =>
                                                  //             time!.minute %
                                                  //                 30 ==
                                                  //             0).then((time) {
                                                  //   setState(() {
                                                  //     _tuesdayTo = time!;
                                                  //     tuesday!.to =
                                                  //         time.format(context);
                                                  //   });
                                                  // });
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (tuesdayError.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                    'Error: Finish time must be after start time.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: App.theme.errorRedColor,
                                    )),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            unselectedWidgetColor:
                                                App.theme.turquoise,
                                          ),
                                          child: Checkbox(
                                            checkColor:
                                                App.theme.darkBackground,
                                            focusColor: App.theme.turquoise,
                                            activeColor: App.theme.turquoise,
                                            value: wednesdaySelected,
                                            onChanged: (newValue) {
                                              toggleWorkHour('Wed', newValue!);
                                              setState(() {
                                                wednesdaySelected = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              wednesdaySelected =
                                                  !wednesdaySelected;
                                            });
                                          },
                                          child: SizedBox(
                                            width: 40,
                                            child: Text('Wed',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color:
                                                      App.theme.mutedLightColor,
                                                )),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                              child: Container(
                                                margin: EdgeInsets.all(4),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12.0),
                                                decoration: BoxDecoration(
                                                  color: App.theme.darkGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      color:
                                                          (App.theme.darkGrey)!,
                                                      style: BorderStyle.solid,
                                                      width: 0.1),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      wednesday != null
                                                          ? _wednesdayFrom
                                                              .format(context)
                                                          : '-- : --',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: App.theme.white,
                                                      )),
                                                ),
                                              ),
                                              onTap: () async {
                                                if (wednesdaySelected) {
                                                  // showCustomTimePicker(
                                                  //     context: context,
                                                  //     // It is a must if you provide selectableTimePredicate
                                                  //     onFailValidation:
                                                  //         (context) => null,
                                                  //     initialTime: TimeOfDay(
                                                  //         hour: _wednesdayFrom
                                                  //             .hour,
                                                  //         minute: _wednesdayFrom
                                                  //             .minute),
                                                  //     selectableTimePredicate:
                                                  //         (time) =>
                                                  //             time!.minute %
                                                  //                 30 ==
                                                  //             0).then((time) {
                                                  //   setState(() {
                                                  //     _wednesdayFrom = time!;
                                                  //     wednesday!.from =
                                                  //         time.format(context);
                                                  //   });
                                                  // });
                                                }
                                              }),
                                        ),
                                        SizedBox(
                                            width: 10,
                                            child: Divider(
                                              thickness: 1.0,
                                              color: App.theme.grey,
                                            )),
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                              child: Container(
                                                margin: EdgeInsets.all(4),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12.0),
                                                decoration: BoxDecoration(
                                                  color: App.theme.darkGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      color:
                                                          (App.theme.darkGrey)!,
                                                      style: BorderStyle.solid,
                                                      width: 0.1),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      wednesday != null
                                                          ? _wednesdayTo
                                                              .format(context)
                                                          : '-- : --',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: App.theme.white,
                                                      )),
                                                ),
                                              ),
                                              onTap: () async {
                                                if (wednesdaySelected) {
                                                  // showCustomTimePicker(
                                                  //     context: context,
                                                  //     // It is a must if you provide selectableTimePredicate
                                                  //     onFailValidation:
                                                  //         (context) => null,
                                                  //     initialTime: TimeOfDay(
                                                  //         hour:
                                                  //             _wednesdayTo.hour,
                                                  //         minute: _wednesdayTo
                                                  //             .minute),
                                                  //     selectableTimePredicate:
                                                  //         (time) =>
                                                  //             time!.minute %
                                                  //                 30 ==
                                                  //             0).then((time) {
                                                  //   setState(() {
                                                  //     _wednesdayTo = time!;
                                                  //     wednesday!.to =
                                                  //         time.format(context);
                                                  //   });
                                                  // });
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (wednesdayError.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                    'Error: Finish time must be after start time.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: App.theme.errorRedColor,
                                    )),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            unselectedWidgetColor:
                                                App.theme.turquoise,
                                          ),
                                          child: Checkbox(
                                            checkColor:
                                                App.theme.darkBackground,
                                            focusColor: App.theme.turquoise,
                                            activeColor: App.theme.turquoise,
                                            value: thursdaySelected,
                                            onChanged: (newValue) {
                                              toggleWorkHour('Thu', newValue!);
                                              setState(() {
                                                thursdaySelected = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              thursdaySelected =
                                                  !thursdaySelected;
                                            });
                                          },
                                          child: SizedBox(
                                            width: 40,
                                            child: Text('Thu',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color:
                                                      App.theme.mutedLightColor,
                                                )),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                              child: Container(
                                                margin: EdgeInsets.all(4),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12.0),
                                                decoration: BoxDecoration(
                                                  color: App.theme.darkGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      color:
                                                          (App.theme.darkGrey)!,
                                                      style: BorderStyle.solid,
                                                      width: 0.1),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      thursday != null
                                                          ? _thursdayFrom
                                                              .format(context)
                                                          : '-- : --',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: App.theme.white,
                                                      )),
                                                ),
                                              ),
                                              onTap: () async {
                                                if (thursdaySelected) {
                                                  // showCustomTimePicker(
                                                  //     context: context,
                                                  //     // It is a must if you provide selectableTimePredicate
                                                  //     onFailValidation:
                                                  //         (context) => null,
                                                  //     initialTime: TimeOfDay(
                                                  //         hour: _thursdayFrom
                                                  //             .hour,
                                                  //         minute: _thursdayFrom
                                                  //             .minute),
                                                  //     selectableTimePredicate:
                                                  //         (time) =>
                                                  //             time!.minute %
                                                  //                 30 ==
                                                  //             0).then((time) {
                                                  //   setState(() {
                                                  //     _thursdayFrom = time!;
                                                  //     thursday!.from =
                                                  //         time.format(context);
                                                  //   });
                                                  // });
                                                }
                                              }),
                                        ),
                                        SizedBox(
                                            width: 10,
                                            child: Divider(
                                              thickness: 1.0,
                                              color: App.theme.grey,
                                            )),
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                              child: Container(
                                                margin: EdgeInsets.all(4),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12.0),
                                                decoration: BoxDecoration(
                                                  color: App.theme.darkGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      color:
                                                          (App.theme.darkGrey)!,
                                                      style: BorderStyle.solid,
                                                      width: 0.1),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      thursday != null
                                                          ? _thursdayTo
                                                              .format(context)
                                                          : '-- : --',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: App.theme.white,
                                                      )),
                                                ),
                                              ),
                                              onTap: () async {
                                                if (thursdaySelected) {
                                                  // showCustomTimePicker(
                                                  //     context: context,
                                                  //     // It is a must if you provide selectableTimePredicate
                                                  //     onFailValidation:
                                                  //         (context) => null,
                                                  //     initialTime: TimeOfDay(
                                                  //         hour:
                                                  //             _thursdayTo.hour,
                                                  //         minute: _thursdayTo
                                                  //             .minute),
                                                  //     selectableTimePredicate:
                                                  //         (time) =>
                                                  //             time!.minute %
                                                  //                 30 ==
                                                  //             0).then((time) {
                                                  //   setState(() {
                                                  //     _thursdayTo = time!;
                                                  //     thursday!.to =
                                                  //         time.format(context);
                                                  //   });
                                                  // });
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (thursdayError.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                    'Error: Finish time must be after start time.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: App.theme.errorRedColor,
                                    )),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            unselectedWidgetColor:
                                                App.theme.turquoise,
                                          ),
                                          child: Checkbox(
                                            checkColor:
                                                App.theme.darkBackground,
                                            focusColor: App.theme.turquoise,
                                            activeColor: App.theme.turquoise,
                                            value: fridaySelected,
                                            onChanged: (newValue) {
                                              toggleWorkHour('Fri', newValue!);
                                              setState(() {
                                                fridaySelected = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              fridaySelected = !fridaySelected;
                                            });
                                          },
                                          child: SizedBox(
                                            width: 40,
                                            child: Text('Fri',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color:
                                                      App.theme.mutedLightColor,
                                                )),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                              child: Container(
                                                margin: EdgeInsets.all(4),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12.0),
                                                decoration: BoxDecoration(
                                                  color: App.theme.darkGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      color:
                                                          (App.theme.darkGrey)!,
                                                      style: BorderStyle.solid,
                                                      width: 0.1),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      friday != null
                                                          ? _fridayFrom
                                                              .format(context)
                                                          : '-- : --',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: App.theme.white,
                                                      )),
                                                ),
                                              ),
                                              onTap: () async {
                                                if (fridaySelected) {
                                                  // showCustomTimePicker(
                                                  //     context: context,
                                                  //     // It is a must if you provide selectableTimePredicate
                                                  //     onFailValidation:
                                                  //         (context) => null,
                                                  //     initialTime: TimeOfDay(
                                                  //         hour:
                                                  //             _fridayFrom.hour,
                                                  //         minute: _fridayFrom
                                                  //             .minute),
                                                  //     selectableTimePredicate:
                                                  //         (time) =>
                                                  //             time!.minute %
                                                  //                 30 ==
                                                  //             0).then((time) {
                                                  //   setState(() {
                                                  //     _fridayFrom = time!;
                                                  //     friday!.from =
                                                  //         time.format(context);
                                                  //   });
                                                  // });
                                                }
                                              }),
                                        ),
                                        SizedBox(
                                            width: 10,
                                            child: Divider(
                                              thickness: 1.0,
                                              color: App.theme.grey,
                                            )),
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                              child: Container(
                                                margin: EdgeInsets.all(4),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12.0),
                                                decoration: BoxDecoration(
                                                  color: App.theme.darkGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      color:
                                                          (App.theme.darkGrey)!,
                                                      style: BorderStyle.solid,
                                                      width: 0.1),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      friday != null
                                                          ? _fridayTo
                                                              .format(context)
                                                          : '-- : --',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: App.theme.white,
                                                      )),
                                                ),
                                              ),
                                              onTap: () async {
                                                if (fridaySelected) {
                                                  // showCustomTimePicker(
                                                  //     context: context,
                                                  //     // It is a must if you provide selectableTimePredicate
                                                  //     onFailValidation:
                                                  //         (context) => null,
                                                  //     initialTime: TimeOfDay(
                                                  //         hour: _fridayTo.hour,
                                                  //         minute:
                                                  //             _fridayTo.minute),
                                                  //     selectableTimePredicate:
                                                  //         (time) =>
                                                  //             time!.minute %
                                                  //                 30 ==
                                                  //             0).then((time) {
                                                  //   setState(() {
                                                  //     _fridayTo = time!;
                                                  //     friday!.to =
                                                  //         time.format(context);
                                                  //   });
                                                  // });
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (fridayError.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                    'Error: Finish time must be after start time.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: App.theme.errorRedColor,
                                    )),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            unselectedWidgetColor:
                                                App.theme.turquoise,
                                          ),
                                          child: Checkbox(
                                            checkColor:
                                                App.theme.darkBackground,
                                            focusColor: App.theme.turquoise,
                                            activeColor: App.theme.turquoise,
                                            value: saturdaySelected,
                                            onChanged: (newValue) {
                                              toggleWorkHour('Sat', newValue!);
                                              setState(() {
                                                saturdaySelected = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              saturdaySelected =
                                                  !saturdaySelected;
                                            });
                                          },
                                          child: SizedBox(
                                            width: 40,
                                            child: Text('Sat',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color:
                                                      App.theme.mutedLightColor,
                                                )),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                              child: Container(
                                                margin: EdgeInsets.all(4),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12.0),
                                                decoration: BoxDecoration(
                                                  color: App.theme.darkGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      color:
                                                          (App.theme.darkGrey)!,
                                                      style: BorderStyle.solid,
                                                      width: 0.1),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      saturday != null
                                                          ? _saturdayFrom
                                                              .format(context)
                                                          : '-- : --',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: App.theme.white,
                                                      )),
                                                ),
                                              ),
                                              onTap: () async {
                                                if (saturdaySelected) {
                                                  // showCustomTimePicker(
                                                  //     context: context,
                                                  //     // It is a must if you provide selectableTimePredicate
                                                  //     onFailValidation:
                                                  //         (context) => null,
                                                  //     initialTime: TimeOfDay(
                                                  //         hour: _saturdayFrom
                                                  //             .hour,
                                                  //         minute: _saturdayFrom
                                                  //             .minute),
                                                  //     selectableTimePredicate:
                                                  //         (time) =>
                                                  //             time!.minute %
                                                  //                 30 ==
                                                  //             0).then((time) {
                                                  //   setState(() {
                                                  //     _saturdayFrom = time!;
                                                  //     saturday!.from =
                                                  //         time.format(context);
                                                  //   });
                                                  // });
                                                }
                                              }),
                                        ),
                                        SizedBox(
                                            width: 10,
                                            child: Divider(
                                              thickness: 1.0,
                                              color: App.theme.grey,
                                            )),
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                              child: Container(
                                                margin: EdgeInsets.all(4),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12.0),
                                                decoration: BoxDecoration(
                                                  color: App.theme.darkGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      color:
                                                          (App.theme.darkGrey)!,
                                                      style: BorderStyle.solid,
                                                      width: 0.1),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      saturday != null
                                                          ? _saturdayTo
                                                              .format(context)
                                                          : '-- : --',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: App.theme.white,
                                                      )),
                                                ),
                                              ),
                                              onTap: () async {
                                                if (saturdaySelected) {
                                                  // showCustomTimePicker(
                                                  //     context: context,
                                                  //     // It is a must if you provide selectableTimePredicate
                                                  //     onFailValidation:
                                                  //         (context) => null,
                                                  //     initialTime: TimeOfDay(
                                                  //         hour:
                                                  //             _saturdayTo.hour,
                                                  //         minute: _saturdayTo
                                                  //             .minute),
                                                  //     selectableTimePredicate:
                                                  //         (time) =>
                                                  //             time!.minute %
                                                  //                 30 ==
                                                  //             0).then((time) {
                                                  //   setState(() {
                                                  //     _saturdayTo = time!;
                                                  //     saturday!.to =
                                                  //         time.format(context);
                                                  //   });
                                                  // });
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (saturdayError.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                    'Error: Finish time must be after start time.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: App.theme.errorRedColor,
                                    )),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            unselectedWidgetColor:
                                                App.theme.turquoise,
                                          ),
                                          child: Checkbox(
                                            checkColor:
                                                App.theme.darkBackground,
                                            focusColor: App.theme.turquoise,
                                            activeColor: App.theme.turquoise,
                                            value: sundaySelected,
                                            onChanged: (newValue) {
                                              toggleWorkHour('Sun', newValue!);
                                              setState(() {
                                                sundaySelected = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              sundaySelected = !sundaySelected;
                                            });
                                          },
                                          child: SizedBox(
                                            width: 40,
                                            child: Text('Sun',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color:
                                                      App.theme.mutedLightColor,
                                                )),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                              child: Container(
                                                margin: EdgeInsets.all(4),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12.0),
                                                decoration: BoxDecoration(
                                                  color: App.theme.darkGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      color:
                                                          (App.theme.darkGrey)!,
                                                      style: BorderStyle.solid,
                                                      width: 0.1),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      sunday != null
                                                          ? _sundayFrom
                                                              .format(context)
                                                          : '-- : --',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: App.theme.white,
                                                      )),
                                                ),
                                              ),
                                              onTap: () async {
                                                if (sundaySelected) {
                                                  // showCustomTimePicker(
                                                  //     context: context,
                                                  //     // It is a must if you provide selectableTimePredicate
                                                  //     onFailValidation:
                                                  //         (context) => null,
                                                  //     initialTime: TimeOfDay(
                                                  //         hour:
                                                  //             _sundayFrom.hour,
                                                  //         minute: _sundayFrom
                                                  //             .minute),
                                                  //     selectableTimePredicate:
                                                  //         (time) =>
                                                  //             time!.minute %
                                                  //                 30 ==
                                                  //             0).then((time) {
                                                  //   setState(() {
                                                  //     _sundayFrom = time!;
                                                  //     sunday!.from =
                                                  //         time.format(context);
                                                  //   });
                                                  // });
                                                }
                                              }),
                                        ),
                                        SizedBox(
                                            width: 10,
                                            child: Divider(
                                              thickness: 1.0,
                                              color: App.theme.grey,
                                            )),
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                              child: Container(
                                                margin: EdgeInsets.all(4),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12.0),
                                                decoration: BoxDecoration(
                                                  color: App.theme.darkGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      color:
                                                          (App.theme.darkGrey)!,
                                                      style: BorderStyle.solid,
                                                      width: 0.1),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      sunday != null
                                                          ? _sundayTo
                                                              .format(context)
                                                          : '-- : --',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: App.theme.white,
                                                      )),
                                                ),
                                              ),
                                              onTap: () async {
                                                if (sundaySelected) {
                                                  // showCustomTimePicker(
                                                  //     context: context,
                                                  //     // It is a must if you provide selectableTimePredicate
                                                  //     onFailValidation:
                                                  //         (context) => null,
                                                  //     initialTime: TimeOfDay(
                                                  //         hour: _sundayTo.hour,
                                                  //         minute:
                                                  //             _sundayTo.minute),
                                                  //     selectableTimePredicate:
                                                  //         (time) =>
                                                  //             time!.minute %
                                                  //                 30 ==
                                                  //             0).then((time) {
                                                  //   setState(() {
                                                  //     _sundayTo = time!;
                                                  //     sunday!.to =
                                                  //         time.format(context);
                                                  //   });
                                                  // });
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (sundayError.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                    'Error: Finish time must be after start time.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: App.theme.errorRedColor,
                                    )),
                              ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(
                                color: App.theme.darkGrey,
                                thickness: 1,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Range of Travel',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: App.theme.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text('Base Location',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: App.theme.mutedLightColor,
                                      )),
                                  SizedBox(height: 8),
                                  if (App.currentUser.doctorProfile!
                                              .savedAddress !=
                                          null &&
                                      App.currentUser.doctorProfile!
                                          .savedAddress!.address.isNotEmpty)
                                    Column(
                                      children: [
                                        Text(
                                            App.currentUser.doctorProfile!
                                                .savedAddress!.address,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: App.theme.green500,
                                            )),
                                        SizedBox(height: 8),
                                      ],
                                    ),
                                  if (App.currentUser.doctorProfile!
                                              .savedAddress !=
                                          null &&
                                      App.currentUser.doctorProfile!
                                          .savedAddress!.lat.isNotEmpty &&
                                      App.currentUser.doctorProfile!
                                          .savedAddress!.lng.isNotEmpty)
                                    Column(
                                      children: [
                                        Text(
                                            '(' +
                                                App.currentUser.doctorProfile!
                                                    .savedAddress!.lat +
                                                ', ' +
                                                App.currentUser.doctorProfile!
                                                    .savedAddress!.lng +
                                                ')',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: App.theme.lightText,
                                            )),
                                        SizedBox(height: 8),
                                      ],
                                    ),
                                  TertiaryStandardButton(
                                    title: App.currentUser.doctorProfile!
                                                .savedAddress !=
                                            null
                                        ? 'Change base Location'
                                        : 'Tap to Add Location',
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return DoctorBaseLocation();
                                      }));
                                    },
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                      'Tip: Add the location you travel from the most.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: App.theme.mutedLightColor,
                                      )),
                                  SizedBox(height: 24),
                                  Text('Radius of Travel',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                        color: App.theme.mutedLightColor,
                                      )),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 12.0),
                                          decoration: BoxDecoration(
                                            color: App.theme.darkGrey,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                                color: (App.theme.darkGrey)!,
                                                style: BorderStyle.solid,
                                                width: 0.1),
                                          ),
                                          child: DropdownButton(
                                            isDense: true,
                                            dropdownColor: App.theme.darkGrey,
                                            underline: SizedBox(),
                                            items: _radiusDistance
                                                .map(
                                                    (value) => DropdownMenuItem(
                                                          child: Text(value,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: App
                                                                      .theme
                                                                      .white)),
                                                          value: value,
                                                        ))
                                                .toList(),
                                            icon: SvgPicture.asset(
                                                'assets/icons/icon_down_caret.svg'),
                                            hint: Text(_distanceHint,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: App.theme.white)),
                                            onChanged: (String? value) {
                                              setState(() {
                                                _distanceHint = value!;
                                                if (value
                                                    .toString()
                                                    .isNotEmpty) {
                                                  App.currentUser.doctorProfile!
                                                          .operationRadius =
                                                      int.parse(
                                                          value.replaceAll(
                                                              'km', ''));
                                                }
                                              });
                                            },
                                            isExpanded: false,
                                            value: (_radiusDistance.indexOf(App
                                                            .currentUser
                                                            .doctorProfile!
                                                            .operationRadius
                                                            .toString() +
                                                        'km') >
                                                    0)
                                                ? _radiusDistance[
                                                    _radiusDistance.indexOf(App
                                                            .currentUser
                                                            .doctorProfile!
                                                            .operationRadius
                                                            .toString() +
                                                        'km')]
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                      'Tip: Your maximum travel distance for appointments',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: App.theme.mutedLightColor,
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(
                                color: App.theme.darkGrey,
                                thickness: 1,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Block Time Off',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: App.theme.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      SimpleTooltip(
                                        borderColor: (App.theme.grey700)!,
                                        backgroundColor: (App.theme.grey700)!,
                                        hideOnTooltipTap: true,
                                        tooltipTap: () {
                                          showToolTip = !showToolTip;
                                        },
                                        animationDuration:
                                            Duration(milliseconds: 500),
                                        show: showToolTip,
                                        tooltipDirection: TooltipDirection.up,
                                        child: GestureDetector(
                                          child: SvgPicture.asset(
                                            'assets/icons/icon_info.svg',
                                            width: 18,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              showToolTip = !showToolTip;
                                            });
                                          },
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/icon_info.svg',
                                                  width: 18,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Block Time Off',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: App.theme.white,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'Going away or taking some time off work? Enter the start and end dates here and you won’t receive any appointment requests for that period.',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color:
                                                      App.theme.mutedLightColor,
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      CupertinoSwitch(
                                        value: _timeOff,
                                        onChanged: (bool value) {
                                          setState(() {
                                            _timeOff = value;
                                            if (_timeOff == true) {
                                              _timeOffStatus = 'On';
                                            } else {
                                              _timeOffStatus = 'Off';
                                            }
                                          });
                                        },
                                      ),
                                      Text(
                                        _timeOffStatus,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: App.theme.mutedLightColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 12.0),
                                            decoration: BoxDecoration(
                                              color: App.theme.darkGrey,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  color: (App.theme.darkGrey)!,
                                                  style: BorderStyle.solid,
                                                  width: 0.1),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                    '${DateFormat.yMMMd().format(DateTime(_selectedFromDate.year, _selectedFromDate.month, _selectedFromDate.day))}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14,
                                                      color: App.theme.white,
                                                    )),
                                                SizedBox(width: 10),
                                                Icon(
                                                  Icons.calendar_today,
                                                  size: 20,
                                                  color: App.theme.white,
                                                )
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  DateTime.now().day),
                                              firstDate: DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  DateTime.now().day),
                                              lastDate: DateTime(2030),
                                              builder: (BuildContext context,
                                                  Widget? child) {
                                                return Theme(
                                                  data: ThemeData(
                                                    primaryColor: App
                                                        .theme.darkBackground,
                                                    canvasColor: App
                                                        .theme.darkBackground,
                                                    cardColor: App
                                                        .theme.darkBackground,
                                                    dialogBackgroundColor: App
                                                        .theme.darkBackground,
                                                    backgroundColor: App
                                                        .theme.darkBackground!,
                                                    colorScheme:
                                                        ColorScheme.light(
                                                            // secondaryVariant: Colors.green,
                                                            onPrimary:
                                                                Colors.white,
                                                            onSurface: App
                                                                .theme.white!
                                                                .withOpacity(
                                                                    0.7),
                                                            secondary:
                                                                Colors.red,
                                                            background: App
                                                                .theme
                                                                .darkBackground!,
                                                            primary: App.theme
                                                                .turquoise!),
                                                    buttonTheme:
                                                        ButtonThemeData(
                                                            textTheme:
                                                                ButtonTextTheme
                                                                    .primary),
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                            ).then((pickedDate) {
                                              if (pickedDate == null) {
                                                return;
                                              }
                                              setState(() {
                                                _selectedFromDate = pickedDate;
                                              });
                                            });
                                          }),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                            width: 10,
                                            child: Divider(
                                              thickness: 2.0,
                                              color: App.theme.grey,
                                            )),
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 12.0),
                                          decoration: BoxDecoration(
                                            color: App.theme.darkGrey,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                                color: (App.theme.darkGrey)!,
                                                style: BorderStyle.solid,
                                                width: 0.1),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${DateFormat.yMMMd().format(DateTime(_selectedToDate.year, _selectedToDate.month, _selectedToDate.day))}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: App.theme.white,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Icon(
                                                Icons.calendar_today,
                                                size: 20,
                                                color: App.theme.white,
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day),
                                            firstDate: DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day),
                                            lastDate: DateTime(
                                                DateTime.now()
                                                    .add(Duration(days: 365))
                                                    .year,
                                                DateTime.now()
                                                    .add(Duration(days: 365))
                                                    .month,
                                                DateTime.now()
                                                    .add(Duration(days: 365))
                                                    .day),
                                            builder: (BuildContext context,
                                                Widget? child) {
                                              return Theme(
                                                data: ThemeData(
                                                  primaryColor:
                                                      App.theme.darkBackground,
                                                  canvasColor:
                                                      App.theme.darkBackground,
                                                  cardColor:
                                                      App.theme.darkBackground,
                                                  dialogBackgroundColor:
                                                      App.theme.darkBackground,
                                                  backgroundColor:
                                                      App.theme.darkBackground!,
                                                  colorScheme:
                                                      ColorScheme.light(
                                                          // secondaryVariant: Colors.green,
                                                          onPrimary:
                                                              Colors.white,
                                                          onSurface: App
                                                              .theme.white!
                                                              .withOpacity(0.7),
                                                          secondary: Colors.red,
                                                          background: App.theme
                                                              .darkBackground!,
                                                          primary: App.theme
                                                              .turquoise!),
                                                  buttonTheme: ButtonThemeData(
                                                      textTheme: ButtonTextTheme
                                                          .primary),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          ).then((pickedDate) {
                                            if (pickedDate == null) {
                                              return;
                                            }
                                            setState(() {
                                              _selectedToDate = pickedDate;
                                            });
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(
                                color: App.theme.darkGrey,
                                thickness: 1,
                              ),
                            ),
                            SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              child: Container(
                padding:
                    EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 30),
                color: App.theme.grey700,
                child: _loading
                    ? PrimaryButtonLoading()
                    : PrimaryLargeButton(
                        title: 'Save Availabilities',
                        iconWidget: SizedBox(),
                        onPressed: () {
                          App.currentUser.doctorProfile!.isAway = _timeOff;
                          App.currentUser.doctorProfile!.holidayFrom =
                              _selectedFromDate;
                          App.currentUser.doctorProfile!.holidayTo =
                              _selectedToDate;

                          List<WorkHour> newWorkHours = <WorkHour>[];
                          setState(() {
                            _loading = true;
                            mondayError = "";
                            tuesdayError = "";
                            wednesdayError = "";
                            thursdayError = "";
                            fridayError = "";
                            saturdayError = "";
                            sundayError = "";
                          });

                          if (mondaySelected &&
                              _mondayFrom.hour > _mondayTo.hour &&
                              _mondayTo.hour != 0) {
                            setState(() {
                              mondayError =
                                  "Error: Finish time must be after start time.";
                            });
                          }
                          if (tuesdaySelected &&
                              _tuesdayFrom.hour > _tuesdayTo.hour &&
                              _tuesdayTo.hour != 0) {
                            setState(() {
                              tuesdayError =
                                  "Error: Finish time must be after start time.";
                            });
                          }
                          if (wednesdaySelected &&
                              _wednesdayFrom.hour > _wednesdayTo.hour &&
                              _wednesdayTo.hour != 0) {
                            setState(() {
                              wednesdayError =
                                  "Error: Finish time must be after start time.";
                            });
                          }
                          if (thursdaySelected &&
                              _thursdayFrom.hour > _thursdayTo.hour &&
                              _thursdayTo.hour != 0) {
                            setState(() {
                              thursdayError =
                                  "Error: Finish time must be after start time.";
                            });
                          }
                          if (fridaySelected &&
                              _fridayFrom.hour > _fridayTo.hour &&
                              _fridayTo.hour != 0) {
                            setState(() {
                              fridayError =
                                  "Error: Finish time must be after start time.";
                            });
                          }
                          if (saturdaySelected &&
                              _saturdayFrom.hour > _saturdayTo.hour &&
                              _saturdayTo.hour != 0) {
                            setState(() {
                              saturdayError =
                                  "Error: Finish time must be after start time.";
                            });
                          }
                          if (sundaySelected &&
                              _sundayFrom.hour > _sundayTo.hour &&
                              _sundayTo.hour != 0) {
                            setState(() {
                              sundayError =
                                  "Error: Finish time must be after start time.";
                            });
                          }

                          if (mondayError.isNotEmpty ||
                              tuesdayError.isNotEmpty ||
                              wednesdayError.isNotEmpty ||
                              thursdayError.isNotEmpty ||
                              fridayError.isNotEmpty ||
                              saturdayError.isNotEmpty ||
                              sundayError.isNotEmpty) {
                            setState(() {
                              _loading = false;
                            });
                            return null;
                          }

                          if (monday != null &&
                              mondayError.isEmpty &&
                              mondaySelected) newWorkHours.add(monday!);
                          if (tuesday != null &&
                              tuesdayError.isEmpty &&
                              tuesdaySelected) newWorkHours.add(tuesday!);
                          if (wednesday != null &&
                              wednesdayError.isEmpty &&
                              wednesdaySelected) newWorkHours.add(wednesday!);
                          if (thursday != null &&
                              thursdayError.isEmpty &&
                              thursdaySelected) newWorkHours.add(thursday!);
                          if (friday != null &&
                              fridayError.isEmpty &&
                              fridaySelected) newWorkHours.add(friday!);
                          if (saturday != null &&
                              saturdayError.isEmpty &&
                              saturdaySelected) newWorkHours.add(saturday!);
                          if (sunday != null &&
                              sundayError.isEmpty &&
                              sundaySelected) newWorkHours.add(sunday!);

                          if (newWorkHours.length > 0) {
                            App.currentUser.workHours = newWorkHours;
                          }

                          final ApiProvider provider = new ApiProvider();
                          provider.updateDoctorProfile().then((success) => {
                                if (!success)
                                  {
                                    setState(() {
                                      _error = "Failed to update profile.";
                                    })
                                  },
                              });

                          provider.updateWorkHours().then((success) => {
                                if (success)
                                  {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return DoctorHome();
                                    }))
                                  }
                                else
                                  {
                                    setState(() {
                                      _error = "Failed to update work hours.";
                                    })
                                  },
                                setState(() {
                                  _loading = false;
                                })
                              });
                        },
                      ),
              ),
            ),
          ),
        ),
        onWillPop: () async => false);
  }

  void toggleWorkHour(String day, bool active) {
    TimeOfDay from = TimeOfDay(hour: 6, minute: 0);
    TimeOfDay to = TimeOfDay(hour: 16, minute: 0);

    var workHour = Utilities.findWorkHourByDay(day);
    if (workHour == null && active) {
      workHour = new WorkHour(day, from.format(context), to.format(context));
    }

    setState(() {
      if (day == 'Sun') {
        sunday = active ? workHour : null;
      }
      if (day == 'Mon') {
        monday = active ? workHour : null;
      }
      if (day == 'Tue') {
        tuesday = active ? workHour : null;
      }
      if (day == 'Wed') {
        wednesday = active ? workHour : null;
      }
      if (day == 'Thu') {
        thursday = active ? workHour : null;
      }
      if (day == 'Fri') {
        friday = active ? workHour : null;
      }
      if (day == 'Sat') {
        saturday = active ? workHour : null;
      }
      if (day == 'Sun') {
        sunday = active ? workHour : null;
      }
    });

    if (active) {
      App.currentUser.workHours.add(workHour!);
    } else {
      var workHour2 = Utilities.findWorkHourByDay(day);
      if (workHour2 != null) {
        App.currentUser.workHours.remove(workHour2);
      }
    }
  }
}
