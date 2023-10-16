import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/ui/partials/button.dart';

class DoctorReportingFlowScreenA extends StatefulWidget {
  final Booking booking;
  const DoctorReportingFlowScreenA({Key? key, required this.booking}) : super(key: key);

  @override
  _DoctorReportingFlowScreenAState createState() => _DoctorReportingFlowScreenAState();
}

class _DoctorReportingFlowScreenAState extends State<DoctorReportingFlowScreenA> {
  var _paidCheck = true;
  var _paidStatus = 'Yes';

  void handlePills(String val) {
    List<String> checksA = <String>[];
    if (App.progressReport.checks.isNotEmpty) {
      checksA = App.progressReport.checks.split(', ');
      int index = checksA.indexOf(val);
      if (index != -1) {
        checksA.removeAt(index);
      } else {
        checksA.add(val);
      }
    } else {
      checksA.add(val);
    }

    App.progressReport.checks = checksA.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What did you do/check during the appointment?',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: App.theme.white,
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  PrimaryPillButton(
                    title: 'Injection',
                    onPressed: () {
                      handlePills('Injection');
                    },
                  ),
                  PrimaryPillButton(
                    title: 'Drip',
                    onPressed: () {
                      handlePills('Drip');
                    },
                  ),
                  PrimaryPillButton(
                    title: 'Lab Test',
                    onPressed: () {
                      handlePills('Blood Test');
                    },
                  ),
                  PrimaryPillButton(
                    title: 'Covid Test',
                    onPressed: () {
                      handlePills('Covid Test');
                    },
                  ),
                  PrimaryPillButton(
                    title: 'Other',
                    onPressed: () {
                      handlePills('Other');
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Has the patient paid in full for their appointment?',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: App.theme.white,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  CupertinoSwitch(
                    value: _paidCheck,
                    onChanged: (bool value) {
                      setState(() {
                        _paidCheck = value;
                        App.progressReport.paidInFull = _paidCheck;
                        if (_paidCheck == true) {
                          _paidStatus = 'Yes';
                        } else {
                          _paidStatus = 'No';
                        }
                      });
                    },
                  ),
                  Text(_paidStatus,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: App.theme.white,
                      )),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        SizedBox(height: 16),
      ],
    ));
  }
}
