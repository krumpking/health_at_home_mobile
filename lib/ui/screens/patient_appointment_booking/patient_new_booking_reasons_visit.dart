import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/reason.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_new_booking_chronic_conditions.dart';

class PatientNewBookingReasonsVisit extends StatefulWidget {
  const PatientNewBookingReasonsVisit({Key? key}) : super(key: key);

  @override
  _PatientNewBookingReasonsVisitState createState() => _PatientNewBookingReasonsVisitState();
}

class _PatientNewBookingReasonsVisitState extends State<PatientNewBookingReasonsVisit> {
  final otherReasonsController = TextEditingController();
  final locationController = TextEditingController();

  bool checked = false;
  bool _headacheSelected = false;
  bool _dizzinessSelected = false;
  bool _coughSelected = false;
  bool _throatSelected = false;
  bool _nauseaSelected = false;
  bool _vomitingSelected = false;
  bool _diarrhoeaSelected = false;
  bool _feverSelected = false;
  bool _chestPainSelected = false;
  bool _palpitationsSelected = false;

  var _covidCheck = false;
  var _covidStatus = 'No';

  var _contactCheck = false;
  var _contactStatus = 'No';

  var _suspicionCheck = false;
  var _suspicionStatus = 'No';

  bool _hasError = false;

  List<String> _selectedSymptoms = <String>[];

  @override
  void initState() {
    super.initState();
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
                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
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
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            'Reason for the visit',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 23,
                              color: App.theme.grey900,
                            ),
                          ),
                          SizedBox(height: 16),
                          if (_hasError)
                            Text(
                              'Please add some symptoms or select “General check-up”',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: App.theme.errorRedColor,
                              ),
                            ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: App.theme.turquoise,
                                ),
                                child: Checkbox(
                                  checkColor: App.theme.white,
                                  focusColor: App.theme.white,
                                  activeColor: App.theme.turquoise,
                                  value: checked,
                                  onChanged: (newValue) {
                                    setState(() {
                                      checked = !checked;
                                      if (checked) {
                                        _selectedSymptoms.add('General check-up');
                                      } else {
                                        _selectedSymptoms.remove('General check-up');
                                      }
                                    });
                                  },
                                ),
                              ),
                              Text(
                                'General check-up',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: App.theme.grey900,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Please choose any relevant symptoms below:',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: App.theme.grey600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                child: Container(
                                  height: 36,
                                  child: ElevatedButton(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Headache ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: _headacheSelected == true ? App.theme.white : App.theme.grey500,
                                          ),
                                        ),
                                        SvgPicture.asset(_headacheSelected == true ? 'assets/icons/icon_remove.svg' : 'assets/icons/icon_plus.svg',
                                            color: _headacheSelected == true ? App.theme.white : App.theme.grey500, width: 18)
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: _headacheSelected == true ? App.theme.turquoise : App.theme.white,
                                        onPrimary: App.theme.white,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                                        elevation: 0),
                                    onPressed: () {
                                      setState(() {
                                        _headacheSelected = !_headacheSelected;
                                        if (_headacheSelected) {
                                          _selectedSymptoms.add('Headache');
                                        } else {
                                          _selectedSymptoms.remove('Headache');
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                child: Container(
                                  height: 36,
                                  child: ElevatedButton(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Dizziness',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: _dizzinessSelected == true ? App.theme.white : App.theme.grey500,
                                          ),
                                        ),
                                        SvgPicture.asset(_dizzinessSelected == true ? 'assets/icons/icon_remove.svg' : 'assets/icons/icon_plus.svg',
                                            color: _dizzinessSelected == true ? App.theme.white : App.theme.grey500, width: 18)
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: _dizzinessSelected == true ? App.theme.turquoise : App.theme.white,
                                        onPrimary: App.theme.white,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                                        elevation: 0),
                                    onPressed: () {
                                      setState(() {
                                        _dizzinessSelected = !_dizzinessSelected;
                                        if (_dizzinessSelected) {
                                          _selectedSymptoms.add('Dizziness');
                                        } else {
                                          _selectedSymptoms.remove('Dizziness');
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                child: Container(
                                  height: 36,
                                  child: ElevatedButton(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Cough',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: _coughSelected == true ? App.theme.white : App.theme.grey500,
                                          ),
                                        ),
                                        SvgPicture.asset(_coughSelected == true ? 'assets/icons/icon_remove.svg' : 'assets/icons/icon_plus.svg',
                                            color: _coughSelected == true ? App.theme.white : App.theme.grey500, width: 18)
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: _coughSelected == true ? App.theme.turquoise : App.theme.white,
                                        onPrimary: App.theme.white,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                                        elevation: 0),
                                    onPressed: () {
                                      setState(() {
                                        _coughSelected = !_coughSelected;
                                        if (_coughSelected) {
                                          _selectedSymptoms.add('Cough');
                                        } else {
                                          _selectedSymptoms.remove('Cough');
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                child: Container(
                                  height: 36,
                                  child: ElevatedButton(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Sore Throat',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: _throatSelected == true ? App.theme.white : App.theme.grey500,
                                          ),
                                        ),
                                        SvgPicture.asset(_throatSelected == true ? 'assets/icons/icon_remove.svg' : 'assets/icons/icon_plus.svg',
                                            color: _throatSelected == true ? App.theme.white : App.theme.grey500, width: 18)
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: _throatSelected == true ? App.theme.turquoise : App.theme.white,
                                        onPrimary: App.theme.white,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                                        elevation: 0),
                                    onPressed: () {
                                      setState(() {
                                        _throatSelected = !_throatSelected;
                                        if (_throatSelected) {
                                          _selectedSymptoms.add('Sore Throat');
                                        } else {
                                          _selectedSymptoms.remove('Sore Throat');
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                child: Container(
                                  height: 36,
                                  child: ElevatedButton(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Nausea',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: _nauseaSelected == true ? App.theme.white : App.theme.grey500,
                                          ),
                                        ),
                                        SvgPicture.asset(_nauseaSelected == true ? 'assets/icons/icon_remove.svg' : 'assets/icons/icon_plus.svg',
                                            color: _nauseaSelected == true ? App.theme.white : App.theme.grey500, width: 18)
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: _nauseaSelected == true ? App.theme.turquoise : App.theme.white,
                                        onPrimary: App.theme.white,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                                        elevation: 0),
                                    onPressed: () {
                                      setState(() {
                                        _nauseaSelected = !_nauseaSelected;
                                        if (_nauseaSelected) {
                                          _selectedSymptoms.add('Nausea');
                                        } else {
                                          _selectedSymptoms.remove('Nausea');
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                child: Container(
                                  height: 36,
                                  child: ElevatedButton(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Vomiting',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: _vomitingSelected == true ? App.theme.white : App.theme.grey500,
                                          ),
                                        ),
                                        SvgPicture.asset(_vomitingSelected == true ? 'assets/icons/icon_remove.svg' : 'assets/icons/icon_plus.svg',
                                            color: _vomitingSelected == true ? App.theme.white : App.theme.grey500, width: 18)
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: _vomitingSelected == true ? App.theme.turquoise : App.theme.white,
                                        onPrimary: App.theme.white,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                                        elevation: 0),
                                    onPressed: () {
                                      setState(() {
                                        _vomitingSelected = !_vomitingSelected;
                                        if (_vomitingSelected) {
                                          _selectedSymptoms.add('Vomiting');
                                        } else {
                                          _selectedSymptoms.remove('Vomiting');
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                child: Container(
                                  height: 36,
                                  child: ElevatedButton(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Diarrhoea',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: _diarrhoeaSelected == true ? App.theme.white : App.theme.grey500,
                                          ),
                                        ),
                                        SvgPicture.asset(_diarrhoeaSelected == true ? 'assets/icons/icon_remove.svg' : 'assets/icons/icon_plus.svg',
                                            color: _diarrhoeaSelected == true ? App.theme.white : App.theme.grey500, width: 18)
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: _diarrhoeaSelected == true ? App.theme.turquoise : App.theme.white,
                                        onPrimary: App.theme.white,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                                        elevation: 0),
                                    onPressed: () {
                                      setState(() {
                                        _diarrhoeaSelected = !_diarrhoeaSelected;
                                        if (_diarrhoeaSelected) {
                                          _selectedSymptoms.add('Diarrhoea');
                                        } else {
                                          _selectedSymptoms.remove('Diarrhoea');
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                child: Container(
                                  height: 36,
                                  child: ElevatedButton(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Fever',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: _feverSelected == true ? App.theme.white : App.theme.grey500,
                                          ),
                                        ),
                                        SvgPicture.asset(_feverSelected == true ? 'assets/icons/icon_remove.svg' : 'assets/icons/icon_plus.svg',
                                            color: _feverSelected == true ? App.theme.white : App.theme.grey500, width: 18)
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: _feverSelected == true ? App.theme.turquoise : App.theme.white,
                                        onPrimary: App.theme.white,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                                        elevation: 0),
                                    onPressed: () {
                                      setState(() {
                                        _feverSelected = !_feverSelected;
                                        if (_feverSelected) {
                                          _selectedSymptoms.add('Fever');
                                        } else {
                                          _selectedSymptoms.remove('Fever');
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                child: Container(
                                  height: 36,
                                  child: ElevatedButton(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Chest Pain',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: _chestPainSelected == true ? App.theme.white : App.theme.grey500,
                                          ),
                                        ),
                                        SvgPicture.asset(_chestPainSelected == true ? 'assets/icons/icon_remove.svg' : 'assets/icons/icon_plus.svg',
                                            color: _chestPainSelected == true ? App.theme.white : App.theme.grey500, width: 18)
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: _chestPainSelected == true ? App.theme.turquoise : App.theme.white,
                                        onPrimary: App.theme.white,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                                        elevation: 0),
                                    onPressed: () {
                                      setState(() {
                                        _chestPainSelected = !_chestPainSelected;
                                        if (_chestPainSelected) {
                                          _selectedSymptoms.add('Chest Pain');
                                        } else {
                                          _selectedSymptoms.remove('Chest Pain');
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                child: Container(
                                  height: 36,
                                  child: ElevatedButton(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Palpitations',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: _palpitationsSelected == true ? App.theme.white : App.theme.grey500,
                                          ),
                                        ),
                                        SvgPicture.asset(
                                            _palpitationsSelected == true ? 'assets/icons/icon_remove.svg' : 'assets/icons/icon_plus.svg',
                                            color: _palpitationsSelected == true ? App.theme.white : App.theme.grey500,
                                            width: 18)
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: _palpitationsSelected == true ? App.theme.turquoise : App.theme.white,
                                        onPrimary: App.theme.white,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                                        elevation: 0),
                                    onPressed: () {
                                      setState(() {
                                        _palpitationsSelected = !_palpitationsSelected;
                                        if (_palpitationsSelected) {
                                          _selectedSymptoms.add('Palpitations');
                                        } else {
                                          _selectedSymptoms.remove('Palpitations');
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Other Reasons',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: App.theme.grey600,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            maxLines: 5,
                            style: TextStyle(fontSize: 18, color: App.theme.darkText),
                            controller: otherReasonsController,
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
                          SizedBox(height: 16),
                          Text(
                            'Has the patient been in contact with anyone diagnosed with or suspected to have COVID-19 within the past 14 days?',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: App.theme.grey600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              CupertinoSwitch(
                                value: _contactCheck,
                                onChanged: (bool value) {
                                  setState(() {
                                    _contactCheck = value;
                                    if (_contactCheck == true) {
                                      _contactStatus = 'Yes';
                                    } else {
                                      _contactStatus = 'No';
                                    }
                                  });
                                },
                              ),
                              SizedBox(width: 8),
                              Text(_contactStatus,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: App.theme.grey600,
                                  )),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Does the patient have any other reason to suspect they have COVID-19?',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: App.theme.grey600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              CupertinoSwitch(
                                value: _suspicionCheck,
                                onChanged: (bool value) {
                                  setState(() {
                                    _suspicionCheck = value;
                                    if (_suspicionCheck == true) {
                                      _suspicionStatus = 'Yes';
                                    } else {
                                      _suspicionStatus = 'No';
                                    }
                                  });
                                },
                              ),
                              SizedBox(width: 8),
                              Text(_suspicionStatus,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: App.theme.grey600,
                                  )),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Does the patient have confirmed COVID-19?',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: App.theme.grey600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              CupertinoSwitch(
                                value: _covidCheck,
                                onChanged: (bool value) {
                                  setState(() {
                                    _covidCheck = value;
                                    if (_covidCheck == true) {
                                      _covidStatus = 'Yes';
                                    } else {
                                      _covidStatus = 'No';
                                    }
                                  });
                                },
                              ),
                              SizedBox(width: 8),
                              Text(_covidStatus,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: App.theme.grey600,
                                  )),
                            ],
                          ),
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
          child: Container(
              padding: EdgeInsets.all(16),
              child: PrimaryLargeButton(
                  title: 'Confirm Details',
                  iconWidget: SizedBox(),
                  onPressed: () {
                    if (_selectedSymptoms.length > 0) {
                      App.progressBooking!.bookingReason = BookingReason.init();
                      App.progressBooking!.bookingReason!.symptoms = _selectedSymptoms;
                    }
                    App.progressBooking!.bookingReason!.isGeneralCheckUp = checked;
                    App.progressBooking!.bookingReason!.otherReasons = otherReasonsController.value.text;
                    App.progressBooking!.bookingReason!.isCovidPositive = _covidCheck;
                    App.progressBooking!.bookingReason!.patientCovidContact = _contactCheck;
                    App.progressBooking!.bookingReason!.suspectsCovidPositive = _suspicionCheck;
                    if (!checked && _selectedSymptoms.length == 0 && otherReasonsController.value.text.isEmpty) {
                      setState(() {
                        _hasError = true;
                      });
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return PatientNewBookingChronicConditions();
                      }));
                    }
                  })),
          elevation: 0,
        ),
      ),
    );
  }
}
