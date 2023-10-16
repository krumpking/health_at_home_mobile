import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/patient_view_history_report_card.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/patient_medical_profile/patient_medical_profile_appointment_report.dart';

import '../../partials/patient_appointment_card.dart';
import '../home.dart';

class PatientMedicalProfileVisitHistory extends StatefulWidget {
  const PatientMedicalProfileVisitHistory({Key? key}) : super(key: key);

  @override
  _PatientMedicalProfileVisitHistoryState createState() => _PatientMedicalProfileVisitHistoryState();
}

class _PatientMedicalProfileVisitHistoryState extends State<PatientMedicalProfileVisitHistory> {
  ApiProvider _provider = new ApiProvider();
  List<Booking> _bookings = <Booking>[];
  final oCcy = new NumberFormat("#,##0", "en_US");
  bool _bookingsLoading = false;
  late String _bookingsError = '';

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    setState(() {
      _bookingsLoading = true;
    });
    try {
      _provider.getPatientBookings().then((bookings) {
        if (bookings != null) {
          setState(() {
            _bookings = bookings;
          });
        }
        setState(() {
          _bookingsLoading = false;
        });
      });
    } catch (_err) {
      setState(() {
        _bookingsError = 'Failed to load appointments.';
        _bookingsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.turquoise50,
        body: SafeArea(
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
                      offset: Offset(0, 3),
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
                    SizedBox(height: 24),
                    Text(
                      'Appointment History',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: App.theme.grey900,
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              if (_bookings.length < 1 && !_bookingsLoading)
                _bookingsError.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: 32),
                        child: Text(
                          _bookingsError,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: App.theme.red,
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: 32),
                        child: Text(
                          'You have no appointments yet.',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: App.theme.mutedLightColor,
                          ),
                        ),
                      ),
              _bookingsLoading
                  ? SizedBox(
                      child: LinearProgressIndicator(
                        color: App.theme.grey100,
                        backgroundColor: App.theme.grey100,
                        valueColor: AlwaysStoppedAnimation<Color>(App.theme.turquoise!.withOpacity(0.6)),
                      ),
                      height: 3,
                      width: MediaQuery.of(context).size.width,
                    )
                  : Expanded(
                      child: Container(
                        color: Color(0XFFF8FAFC),
                        margin: EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...List.generate(_bookings.length, (index) {
                                Booking booking = _bookings[index];
                                if (index > 9) return Container();
                                return PatientAppointmentCard(booking: booking, callBack: loadBookings);
                              })
                            ],
                          ),
                        ),
                      ),
                    ),

            ],
          ),
        ),
      ),
    );
  }
}
