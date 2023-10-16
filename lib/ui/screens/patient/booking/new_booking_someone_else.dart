import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/models/user/dependent.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/patient_dependent_list_card.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';

import '../../auth/login.dart';
import 'new_booking_service_type.dart';

class PatientAppointmentSomeoneElse extends StatefulWidget {
  const PatientAppointmentSomeoneElse({Key? key}) : super(key: key);

  @override
  _PatientAppointmentSomeoneElseState createState() => _PatientAppointmentSomeoneElseState();
}

class _PatientAppointmentSomeoneElseState extends State<PatientAppointmentSomeoneElse> {
  ApiProvider _provider = new ApiProvider();
  List<Dependent> _dependents = <Dependent>[];
  bool _loaded = false;

  void initState() {
    super.initState();
    App.progressBooking!.bookingFor = BookingFor.SOMEONE;

    _provider.getDependents().then((dependents) {
      if (dependents != null) {
        setState(() {
          _dependents = dependents;
        });
      }
      setState(() {
        _loaded = true;
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
            margin: EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Container(
              child: Column(
                children: [
                  Container(
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
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Text(
                    'Which dependent is the appointment for?',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                      color: App.theme.grey900,
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: !_loaded
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
                              child: SizedBox(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(App.theme.green!.withOpacity(0.5)),
                                ),
                                height: MediaQuery.of(context).size.height * 0.03,
                                width: MediaQuery.of(context).size.height * 0.03,
                              ),
                            ),
                          )
                        : _dependents.length < 1
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  "You have not set up any dependents.",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                ),
                              )
                            : MediaQuery.removePadding(
                                removeTop: true,
                                context: context,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _dependents.length,
                                    itemBuilder: (context, index) {
                                      Dependent dependent = _dependents[index];
                                      return PatientDependentListCard(
                                        name: dependent.firstName + ' ' + dependent.lastName,
                                        age: Utilities.ageFromDob(dependent.dob),
                                        sex: dependent.gender,
                                        relationship: dependent.relationship,
                                        onPressed: () {
                                          App.progressBooking!.dependent = dependent;
                                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                                            return PatientAppointmentNewBookingServiceType();
                                          }));
                                        },
                                      );
                                    }),
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
}
