import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';

import '../home.dart';

class PatientMedicalProfileChronicCondition extends StatefulWidget {
  const PatientMedicalProfileChronicCondition({Key? key}) : super(key: key);

  @override
  _PatientMedicalProfileChronicConditionState createState() => _PatientMedicalProfileChronicConditionState();
}

class _PatientMedicalProfileChronicConditionState extends State<PatientMedicalProfileChronicCondition> {
  final chronicConditionsController = TextEditingController();
  late String _error = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    chronicConditionsController.text = App.currentUser.patientProfile!.chronicConditions!;
  }

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.turquoise50,
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
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
                SizedBox(height: 32),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chronic Conditions',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: App.theme.grey900,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Separate Conditions with a comma',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: App.theme.grey600),
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
                            hintText: 'Tap to add',
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
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: App.theme.turquoise50,
          child: Container(
            padding: EdgeInsets.all(16),
            child: _loading
                ? PrimaryButtonLoading()
                : PrimaryLargeButton(
                    title: 'Save Chronic Conditions',
                    iconWidget: SizedBox(),
                    onPressed: () {
                      setState(() {
                        _loading = true;
                      });

                      App.currentUser.patientProfile!.chronicConditions = chronicConditionsController.value.text;

                      ApiProvider _provider = new ApiProvider();
                      _provider.updatePatientProfile().then(
                        (success) {
                          setState(() {
                            _loading = false;
                          });
                          if (success) {
                            App.sessionMessage = 'Chronic Conditions updated successfully';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Home(1);
                                },
                              ),
                            );
                          } else {
                            _error = ApiResponse.message;
                            ApiResponse.message = '';
                          }
                        },
                      );
                    },
                  ),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
