import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/user/doctorProfile.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/select_button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';
import 'package:mobile/ui/screens/patient/booking/new_booking_someone_else.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_new_booking_reasons_visit.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_new_booking_visit_summary.dart';
import 'package:mobile/ui/screens/patient_browse_page/patient_view_doctor_profile.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

class PatientNewBookingAvailabilities extends StatefulWidget {
  final DoctorProfile doctorProfile;
  final bool isEdit;

  const PatientNewBookingAvailabilities(
      {Key? key, required this.doctorProfile, required this.isEdit})
      : super(key: key);

  @override
  _PatientNewBookingAvailabilitiesState createState() =>
      _PatientNewBookingAvailabilitiesState();
}

class _PatientNewBookingAvailabilitiesState
    extends State<PatientNewBookingAvailabilities> {
  final locationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _loading = false;
  late String _selectedTime = '';

  late List<String> timeHours = [];
  final ApiProvider _provider = new ApiProvider();

  @override
  void initState() {
    super.initState();
    getTimes();
  }

  void getTimes() {
    setState(() {
      _loading = true;
    });
    App.progressBooking!.selectedDate = _selectedDate;
    _provider
        .getAvailabilities(widget.doctorProfile.id!,
            "${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}")
        .then((data) {
      if (data != null) {
        setState(() {
          timeHours = data;
        });
      }

      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.turquoise50,
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                  decoration: BoxDecoration(
                    color: App.theme.turquoise50,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
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
                      ),
                      SizedBox(height: 16),
                      App.isFromViewPractioners
                          ? SizedBox(height: 16)
                          : TextField(
                              style: TextStyle(
                                  fontSize: 18, color: App.theme.white),
                              controller: locationController,
                              readOnly: true,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SvgPicture.asset(
                                        'assets/icons/icon_location.svg'),
                                  ),
                                  fillColor: App.theme.white,
                                  filled: true,
                                  hintText: App.progressBooking!.address,
                                  hintStyle: TextStyle(
                                      fontSize: 16, color: App.theme.grey800),
                                  contentPadding:
                                      EdgeInsets.only(left: 8, right: 8),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: (App.theme.grey300)!,
                                          width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: (App.theme.grey300)!,
                                          width: 1.0),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: (App.theme.grey300)!,
                                          width: 1.0),
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                      SizedBox(height: 16),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    App.theme.grey!.withOpacity(0.1),
                                backgroundImage:
                                    widget.doctorProfile.profileImg != null
                                        ? NetworkImage(
                                            widget.doctorProfile.profileImg!)
                                        : null,
                                radius: MediaQuery.of(context).size.width * 0.1,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (widget.doctorProfile.title.isNotEmpty
                                              ? widget.doctorProfile.title
                                                      .replaceAll('.', '') +
                                                  '. '
                                              : '') +
                                          Utilities.convertToTitleCase(
                                              widget.doctorProfile.displayName),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: App.theme.grey900,
                                      ),
                                    ),
                                    Text(
                                      widget.doctorProfile.specialities
                                              .isNotEmpty
                                          ? widget.doctorProfile.specialities
                                          : '',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14,
                                        color: App.theme.grey400,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SimpleStarRating(
                                          allowHalfRating: true,
                                          starCount: 5,
                                          rating: 3.8,
                                          size: 24,
                                          filledIcon: Icon(Icons.star,
                                              color: App.theme.btnDarkSecondary,
                                              size: 24),
                                          nonFilledIcon: Icon(Icons.star_half,
                                              color: App.theme.btnDarkSecondary,
                                              size: 24),
                                          onRated: (rate) {},
                                          spacing: 4,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/icons/icon_user.svg',
                                            height: 18,
                                            color: App.theme.turquoise),
                                        SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return PatientViewDoctorProfile(
                                                  doctor: widget.doctorProfile);
                                            }));
                                          },
                                          child: Text(
                                            'VIEW PROFILE',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: App.theme.turquoise,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 24),
                          Text(
                            'Availabilities',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 23,
                              color: App.theme.grey900,
                            ),
                          ),
                          SizedBox(height: 24),
                          GestureDetector(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                color: App.theme.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                border: Border.all(
                                    color: (App.theme.grey300)!,
                                    style: BorderStyle.solid,
                                    width: 0.7),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${DateFormat.yMMMd().format(DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day))}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: App.theme.grey900,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  SvgPicture.asset(
                                      'assets/icons/icon_carret_down.svg',
                                      width: 18,
                                      height: 18),
                                ],
                              ),
                            ),
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime(_selectedDate.year,
                                    _selectedDate.month, _selectedDate.day),
                                firstDate: DateTime(DateTime.now().year,
                                    DateTime.now().month, DateTime.now().day),
                                lastDate: DateTime(DateTime.now().year + 1),
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData(
                                      primaryColor: App.theme.turquoise,
                                      colorScheme: ColorScheme.light(
                                          primary: App.theme.turquoise!),
                                      buttonTheme: ButtonThemeData(
                                          textTheme: ButtonTextTheme.primary),
                                    ),
                                    child: child!,
                                  );
                                },
                              ).then((pickedDate) {
                                if (pickedDate == null) {
                                  return;
                                }
                                setState(() {
                                  _selectedDate = pickedDate;
                                  timeHours = [];
                                });

                                getTimes();
                              });
                            },
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Select Time',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: App.theme.grey900,
                            ),
                          ),
                          SizedBox(height: 16),
                          _loading
                              ? Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.08),
                                    child: SizedBox(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.green.withOpacity(0.5)),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                    ),
                                  ),
                                )
                              : timeHours.length > 0
                                  ? MediaQuery.removePadding(
                                      removeTop: true,
                                      removeBottom: true,
                                      context: context,
                                      child: GridView(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 0,
                                          mainAxisSpacing: 8,
                                          mainAxisExtent: 32,
                                        ),
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: List.generate(
                                            timeHours.length, (index) {
                                          return TimeSelectButton(
                                            title: timeHours[index],
                                            onPressed: (bool selected) {
                                              setState(() {
                                                _selectedTime = selected
                                                    ? timeHours[index]
                                                    : '';
                                              });

                                              App.progressBooking!.startTime =
                                                  _selectedTime;
                                            },
                                          );
                                        }),
                                      ),
                                    )
                                  : Text("No available time found"),
                          SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: _selectedTime.isNotEmpty
              ? Container(
                  padding: EdgeInsets.all(16),
                  child: PrimaryLargeButton(
                      title: 'Confirm Time',
                      iconWidget: SizedBox(),
                      onPressed: () {
                        if (App.isFromViewPractioners) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PatientAppointmentSomeoneElse();
                          }));
                        } else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return (App.progressBooking!.isRebook ||
                                    widget.isEdit)
                                ? PatientNewBookingVisitSummary()
                                : PatientNewBookingReasonsVisit();
                          }));
                        }
                      }))
              : null,
          elevation: 0,
        ),
      ),
    );
  }
}
