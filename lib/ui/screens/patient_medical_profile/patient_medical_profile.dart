import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/ui/partials/menu_text.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/patient_medical_profile/patient_medical_allergies.dart';
import 'package:mobile/ui/screens/patient_medical_profile/patient_medical_chronic_conditions.dart';
import 'package:mobile/ui/screens/patient_medical_profile/patient_medical_profile_manage_dependents.dart';
import 'package:mobile/ui/screens/patient_medical_profile/patient_medical_profile_medical_plans.dart';
import 'package:mobile/ui/screens/patient_medical_profile/patient_medical_profile_personal_details.dart';
import 'package:mobile/ui/screens/patient_medical_profile/patient_medical_profile_visit_history.dart';

class PatientMedicalProfile extends StatefulWidget {
  const PatientMedicalProfile({Key? key}) : super(key: key);

  @override
  _PatientMedicalProfileState createState() => _PatientMedicalProfileState();
}

class _PatientMedicalProfileState extends State<PatientMedicalProfile> {
  late String _message = '';
  bool _showMessage = true;
  late final Timer timer = new Timer(Duration(seconds: 5), () {
    try {
      setState(() {
        _showMessage = false;
      });
    } catch (_) {}
  });

  @override
  void initState() {
    super.initState();
    if (App.sessionMessage != null) {
      setState(() {
        _message = App.sessionMessage!;
      });
    }
    App.sessionMessage = null;
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: LightStatusNavigationBarWidget(
          child: Scaffold(
            backgroundColor: App.theme.turquoise50,
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 32),
                    Text(
                      'Medical Profile',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 23,
                        color: App.theme.grey900,
                      ),
                    ),
                    if (_message.isNotEmpty && _showMessage)
                      Column(
                        children: [
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                _message,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: App.theme.green,
                                ),
                              ),
                              Icon(
                                Icons.check_circle,
                                color: App.theme.green,
                                size: 18,
                              )
                            ],
                          )
                        ],
                      ),
                    SizedBox(height: 16),
                    Divider(color: App.theme.lightGreyColor),
                    MyMenuItem(
                        menuTitle: 'Appointment History',
                        menuSubtitle: '',
                        enabled: true,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return PatientMedicalProfileVisitHistory();
                          }));
                        }),
                    MyMenuItem(
                        menuTitle: 'Personal Details',
                        menuSubtitle: '',
                        enabled: true,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return PatientMedicalProfilePersonalDetails();
                          }));
                        }),
                    // MyMenuItem(
                    //     menuTitle: 'Chronic Conditions',
                    //     menuSubtitle: '',
                    //     enabled: true,
                    //     onPressed: () {
                    //       Navigator.push(context, MaterialPageRoute(builder: (context) {
                    //         return PatientMedicalProfileChronicCondition();
                    //       }));
                    //     }),
                    // MyMenuItem(
                    //     menuTitle: 'Allergies',
                    //     menuSubtitle: '',
                    //     enabled: true,
                    //     onPressed: () {
                    //       Navigator.push(context, MaterialPageRoute(builder: (context) {
                    //         return PatientMedicalProfileAllergies();
                    //       }));
                    //     }),
                    MyMenuItem(
                      menuTitle: 'Manage Dependents & Family',
                      menuSubtitle: '',
                      enabled: true,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return PatientDependentManageDependents();
                        }));
                      },
                    ),
                    MyMenuItem(
                      menuTitle: 'My Medical Plans',
                      menuSubtitle: '',
                      enabled: true,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return MyMedicalPlans();
                        }));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: () async => false);
  }
}
