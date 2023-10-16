import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/user/dependent.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';
import 'package:mobile/ui/screens/patient/booking/new_booking_service_type.dart';
import 'package:mobile/ui/screens/patient_medical_profile/patient_medical_profile_manage_dependents.dart';

class NewDependent extends StatefulWidget {
  final bool? isFromList;
  const NewDependent({Key? key, this.isFromList}) : super(key: key);

  @override
  _NewDependentState createState() => _NewDependentState();
}

class _NewDependentState extends State<NewDependent> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1920, 1),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primaryColor: App.theme.turquoise!,
            colorScheme: ColorScheme.light(primary: App.theme.turquoise!),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dob = DateFormat.y().format(selectedDate) + '-' + DateFormat.M().format(selectedDate) + '-' + DateFormat.d().format(selectedDate);
      });
  }

  String _relationshipHint = 'Select';
  String _genderHint = 'Select';
  String _error = '';
  bool _loading = false;
  late String _gender = '';
  late String _relationship = '';
  late String _dob = '';

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  List<String> gender = ['Male', 'Female'];
  List<String> relationships = ['Child', 'Brother', 'Sister', 'Mother', 'Father', 'Spouse', 'Other'];

  @override
  void initState() {
    super.initState();
    if (widget.isFromList != true) {
      App.progressBooking!.dependent = Dependent.init();
    }
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
                    'Add your dependent’s details',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 19,
                      color: App.theme.grey900,
                    ),
                  ),
                  if (_error.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(height: 16),
                        Text(
                          _error,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                            color: App.theme.red,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 24),
                  Text(
                    'First Name',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.grey600),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    style: TextStyle(fontSize: 16, color: App.theme.darkText),
                    controller: firstNameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        fillColor: App.theme.white,
                        filled: true,
                        hintText: 'Input text here',
                        hintStyle: TextStyle(fontSize: 16, color: App.theme.mutedLightColor),
                        contentPadding: EdgeInsets.only(left: 8, right: 8),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: App.theme.grey300!, width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: App.theme.grey300!, width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: App.theme.grey300!, width: 1.0), borderRadius: BorderRadius.circular(10.0))),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Last Name',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.grey600),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    style: TextStyle(fontSize: 16, color: App.theme.darkText),
                    controller: lastNameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        fillColor: App.theme.white,
                        filled: true,
                        hintText: 'Input text here',
                        hintStyle: TextStyle(fontSize: 16, color: App.theme.mutedLightColor),
                        contentPadding: EdgeInsets.only(left: 8, right: 8),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: App.theme.grey300!, width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: App.theme.grey300!, width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: App.theme.grey300!, width: 1.0), borderRadius: BorderRadius.circular(10.0))),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'D.O.B.',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.grey600),
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12.0),
                                      decoration: BoxDecoration(
                                        color: App.theme.white,
                                        borderRadius: BorderRadius.circular(12.0),
                                        border: Border.all(color: App.theme.grey300!, style: BorderStyle.solid, width: 0.1),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(_dob.isEmpty ? 'Select' : "${selectedDate.toLocal()}".split(' ')[0],
                                              style: TextStyle(fontSize: 16, color: App.theme.mutedLightColor)),
                                          SvgPicture.asset('assets/icons/icon_calendar.svg'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                _selectDate(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sex',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: App.theme.grey600),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                                    decoration: BoxDecoration(
                                      color: App.theme.white,
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(color: (App.theme.white)!, style: BorderStyle.solid, width: 0.1),
                                    ),
                                    child: DropdownButton(
                                      isDense: false,
                                      dropdownColor: App.theme.white,
                                      underline: SizedBox(),
                                      items: gender
                                          .map((value) => DropdownMenuItem(
                                                child: Text(value, style: TextStyle(fontSize: 14, color: App.theme.grey800)),
                                                value: value,
                                              ))
                                          .toList(),
                                      isExpanded: true,
                                      icon: SvgPicture.asset('assets/icons/icon_down_caret.svg', color: App.theme.turquoise),
                                      hint: Row(
                                        children: [
                                          Text(_genderHint, style: TextStyle(fontSize: 16, color: App.theme.grey600)),
                                        ],
                                      ),
                                      onChanged: (String? value) {
                                        _genderHint = value!;
                                        setState(() {
                                          _genderHint = value;
                                          _gender = value;
                                        });
                                      },
                                      // value: _dropdownValues.first,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Relationship',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.grey600),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: App.theme.white,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: (App.theme.white)!, style: BorderStyle.solid, width: 0.1),
                          ),
                          child: DropdownButton(
                            isDense: false,
                            dropdownColor: App.theme.white,
                            underline: SizedBox(),
                            items: relationships
                                .map((value) => DropdownMenuItem(
                                      child: Text(value, style: TextStyle(fontSize: 14, color: App.theme.grey800)),
                                      value: value,
                                    ))
                                .toList(),
                            isExpanded: true,
                            icon: SvgPicture.asset('assets/icons/icon_down_caret.svg', color: App.theme.turquoise),
                            hint: Row(
                              children: [
                                Text(_relationshipHint, style: TextStyle(fontSize: 16, color: App.theme.grey600)),
                              ],
                            ),
                            onChanged: (String? value) {
                              _relationshipHint = value!;
                              setState(() {
                                _relationshipHint = value;
                                _relationship = value;
                              });
                            },
                            // value: _dropdownValues.first,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            child: _loading
                ? PrimaryButtonLoading()
                : PrimaryLargeButton(
                    title: 'Save Dependant',
                    iconWidget: SizedBox(),
                    onPressed: () {
                      setState(() {
                        _loading = true;
                        _error = "";
                      });

                      if (firstNameController.value.text.isNotEmpty &&
                          lastNameController.value.text.isNotEmpty &&
                          _dob.isNotEmpty &&
                          _gender.isNotEmpty &&
                          _relationship.isNotEmpty) {
                        App.progressBooking!.dependent = Dependent.init();
                        App.progressBooking!.dependent!.id = null;
                        App.progressBooking!.dependent!.patientProfileId = App.currentUser.patientProfile!.id!;
                        App.progressBooking!.dependent!.firstName = firstNameController.value.text;
                        App.progressBooking!.dependent!.lastName = lastNameController.value.text;
                        App.progressBooking!.dependent!.dob = _dob;
                        App.progressBooking!.dependent!.gender = _gender;
                        App.progressBooking!.dependent!.relationship = _relationship;
                        ApiProvider _provider = new ApiProvider();
                        _provider.createDependent(App.progressBooking!.dependent!).then((dependent) {
                          if (dependent != null) {
                            if (widget.isFromList != null && widget.isFromList! == true) {
                              Navigator.pop(context, "true");
                            } else {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                return PatientAppointmentNewBookingServiceType();
                              }));
                            }
                          } else {
                            setState(() {
                              _loading = false;
                              _error = ApiResponse.message;
                            });
                          }
                        });
                      } else {
                        setState(() {
                          _loading = false;
                          _error = 'Please fill in all the fields.';
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
