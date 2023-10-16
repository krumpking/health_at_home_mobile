import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';

import '../home.dart';

class PatientMedicalProfileAllergies extends StatefulWidget {
  const PatientMedicalProfileAllergies({Key? key}) : super(key: key);

  @override
  _PatientMedicalProfileAllergiesState createState() => _PatientMedicalProfileAllergiesState();
}

class _PatientMedicalProfileAllergiesState extends State<PatientMedicalProfileAllergies> {
  final allergiesController = TextEditingController();
  late String _error = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    allergiesController.text = App.currentUser.patientProfile!.allergies!;
  }

  Future<void> _eraseChangesDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: App.theme.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
          contentPadding: EdgeInsets.all(16),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 8),
                SvgPicture.asset('assets/icons/icon_error.svg'),
                SizedBox(height: 24),
                Text(
                  'Save Changes?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: App.theme.grey800),
                ),
                SizedBox(height: 8),
                Text(
                  'Exiting this page without saving your changes will erase them. Do you want to erase your changes?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.grey500),
                ),
                SizedBox(height: 8),
                PrimaryRegularButton(
                    title: 'Yes, save changes',
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                SizedBox(height: 16),
                Text(
                  'No, remove changes',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.red),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
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
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Allergies',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: App.theme.grey900,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Separate Allergies with a comma',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: App.theme.grey600),
                      ),
                      SizedBox(height: 8),
                      if (_error.isNotEmpty)
                        Text(
                          _error,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: App.theme.red),
                        ),
                      TextField(
                        maxLines: 5,
                        style: TextStyle(fontSize: 18, color: App.theme.darkText),
                        controller: allergiesController,
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
                    title: 'Save Allergies',
                    iconWidget: SizedBox(),
                    onPressed: () {
                      setState(() {
                        _loading = true;
                      });

                      App.currentUser.patientProfile!.allergies = allergiesController.value.text;

                      ApiProvider _provider = new ApiProvider();
                      _provider.updatePatientProfile().then(
                        (success) {
                          setState(() {
                            _loading = false;
                          });
                          if (success) {
                            App.sessionMessage = 'Allergies updated successfully';
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
