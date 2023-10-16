import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_new_booking_visit_summary.dart';

class PatientNewBookingChronicConditions extends StatefulWidget {
  const PatientNewBookingChronicConditions({Key? key}) : super(key: key);

  @override
  _PatientNewBookingChronicConditionsState createState() => _PatientNewBookingChronicConditionsState();
}

class _PatientNewBookingChronicConditionsState extends State<PatientNewBookingChronicConditions> {
  late TextEditingController chronicConditionsController = TextEditingController();
  late TextEditingController allergiesController = TextEditingController();
  bool _loading = false;
  late String _error = '';

  @override
  void initState() {
    super.initState();
    // chronicConditionsController = TextEditingController(
    //     text: App.currentUser.patientProfile!.chronicConditions!.isNotEmpty ? App.currentUser.patientProfile!.chronicConditions : '');
    // allergiesController =
    //     TextEditingController(text: App.currentUser.patientProfile!.allergies!.isNotEmpty ? App.currentUser.patientProfile!.allergies : '');
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
                margin: EdgeInsets.only(left: 16, top: 16, right: 16),
                decoration: BoxDecoration(
                  color: App.theme.turquoise50,
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
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text(
                        'Chronic Conditions',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 23,
                          color: App.theme.grey900,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Please list any chronic conditions of the patient so the doctor can come prepared.',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: App.theme.grey600,
                        ),
                      ),
                      SizedBox(height: 8),
                      if (_error.isNotEmpty)
                        Text(
                          _error,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: App.theme.red),
                        ),
                      TextFormField(
                        maxLines: 5,
                        style: TextStyle(fontSize: 18, color: App.theme.darkText),
                        controller: chronicConditionsController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            fillColor: App.theme.white,
                            filled: true,
                            hintText: 'Input text here',
                            hintStyle: TextStyle(fontSize: 18, color: App.theme.mutedLightColor),
                            contentPadding: EdgeInsets.all(16),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0), borderRadius: BorderRadius.circular(10.0))),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Allergies',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 23,
                          color: App.theme.grey900,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        maxLines: 5,
                        style: TextStyle(fontSize: 18, color: App.theme.darkText),
                        controller: allergiesController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            fillColor: App.theme.white,
                            filled: true,
                            hintText: 'Input text here',
                            hintStyle: TextStyle(fontSize: 18, color: App.theme.mutedLightColor),
                            contentPadding: EdgeInsets.all(16),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0), borderRadius: BorderRadius.circular(10.0))),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            child: _loading
                ? PrimaryButtonLoading()
                : PrimaryLargeButton(
                    title: 'Confirm Details',
                    iconWidget: SizedBox(),
                    onPressed: () {
                      setState(() {
                        _loading = true;
                      });
                      try {
                        if (allergiesController.value.text.isNotEmpty) App.currentUser.patientProfile!.allergies = allergiesController.value.text;
                        if (chronicConditionsController.value.text.isNotEmpty)
                          App.currentUser.patientProfile!.chronicConditions = chronicConditionsController.value.text;

                        if (allergiesController.value.text.isNotEmpty || chronicConditionsController.value.text.isNotEmpty) {
                          App.progressBooking!.addOnService = null;
                          ApiProvider _provider = new ApiProvider();
                          _provider.updatePatientProfile().then((success) async {
                            setState(() {
                              _loading = false;
                            });
                            if (success) {
                              await _provider.refreshUser();
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return PatientNewBookingVisitSummary();
                              }));
                            } else {
                              _error = ApiResponse.message;
                              ApiResponse.message = '';
                            }
                          });
                        } else {
                          setState(() {
                            _loading = false;
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return PatientNewBookingVisitSummary();
                          }));
                        }
                      } catch (error) {
                        setState(() {
                          _loading = false;
                        });
                      }
                    }),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

// Container(
// color: App.theme.turquoise50,
// child: SingleChildScrollView(
// scrollDirection: Axis.horizontal,
// child: Row(
// children: [
//
// SecondaryPillButton(title: 'GP', onPressed: (){}),
// SecondaryPillButton(title: 'qwerty', onPressed: (){}),
// SecondaryPillButton(title: 'GP', onPressed: (){}),
// SecondaryPillButton(title: 'GP', onPressed: (){}),
// ],
// ),
// ),
// ),
