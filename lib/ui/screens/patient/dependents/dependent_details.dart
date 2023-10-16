import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/user/dependent.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/patient_medical_profile/patient_medical_profile_manage_dependents.dart';

import '../../home.dart';

class DependentDetails extends StatefulWidget {
  final Dependent dependent;

  const DependentDetails({Key? key, required this.dependent}) : super(key: key);

  @override
  _DependentDetailsState createState() => _DependentDetailsState();
}

class _DependentDetailsState extends State<DependentDetails> {
  DateTime selectedDate = DateTime.now();

  String _error = '';
  bool _loading = false;
  late String _gender = '';
  late String _relationship = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedDate = DateTime.parse(widget.dependent.dob);
      _relationship = widget.dependent.relationship;
      _gender = widget.dependent.gender;
    });
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
                  'Are you sure you want to remove?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: App.theme.grey800),
                ),
                SizedBox(height: 8),
                Text(
                  'Removing this dependent will also remove all of their appointment records and data. This cannot be undone',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.grey500),
                ),
                SizedBox(height: 8),
                PrimaryRegularButton(
                    title: 'No, keep dependent',
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                SizedBox(height: 16),
                GestureDetector(
                  child: Text(
                    'Yes, remove dependent',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.red),
                  ),
                  onTap: () {
                    setState(() {
                      _loading = true;
                    });
                    ApiProvider _provider = new ApiProvider();
                    _provider.deleteDependent(widget.dependent.id!).then((success) {
                      setState(() {
                        _loading = false;
                      });
                      if (success) {
                        App.sessionMessage = 'Dependent deleted successfully';
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                        _error = ApiResponse.message;
                        ApiResponse.message = '';
                        _loading = false;
                      }
                    });
                  },
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
                    'Your dependent’s details',
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
                            fontWeight: FontWeight.w400,
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
                  TextFormField(
                    style: TextStyle(fontSize: 16, color: App.theme.lightText),
                    readOnly: true,
                    initialValue: widget.dependent.firstName,
                    decoration: InputDecoration(
                        fillColor: App.theme.grey100,
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
                  TextFormField(
                    style: TextStyle(fontSize: 16, color: App.theme.lightText),
                    readOnly: true,
                    initialValue: widget.dependent.lastName,
                    decoration: InputDecoration(
                        fillColor: App.theme.grey100,
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
                                        color: App.theme.grey100,
                                        borderRadius: BorderRadius.circular(12.0),
                                        border: Border.all(color: App.theme.grey300!, style: BorderStyle.solid, width: 1),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("${selectedDate.toLocal()}".split(' ')[0],
                                              style: TextStyle(fontSize: 16, color: App.theme.mutedLightColor)),
                                          SvgPicture.asset('assets/icons/icon_calendar.svg'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {},
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
                                      color: App.theme.grey100,
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(color: (App.theme.grey300)!, style: BorderStyle.solid, width: 1),
                                    ),
                                    child: DropdownButton(
                                      isDense: false,
                                      dropdownColor: App.theme.white,
                                      underline: SizedBox(),
                                      items: [],
                                      isExpanded: true,
                                      icon: SvgPicture.asset('assets/icons/icon_down_caret.svg', color: App.theme.turquoise),
                                      hint: Row(
                                        children: [
                                          Text(_gender, style: TextStyle(fontSize: 16, color: App.theme.lightText)),
                                        ],
                                      ),
                                      onChanged: null,
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
                            color: App.theme.grey100,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: (App.theme.grey300)!, style: BorderStyle.solid, width: 1),
                          ),
                          child: DropdownButton(
                            isDense: false,
                            dropdownColor: App.theme.grey300,
                            underline: SizedBox(),
                            items: [],
                            isExpanded: true,
                            icon: SvgPicture.asset('assets/icons/icon_down_caret.svg', color: App.theme.turquoise),
                            hint: Row(
                              children: [
                                Text(_relationship, style: TextStyle(fontSize: 16, color: App.theme.lightText)),
                              ],
                            ),
                            onChanged: null,
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
                ? SecondaryButtonLoading()
                : DangerLargeButton(
                    title: 'Remove Dependant',
                    onPressed: () {
                      _eraseChangesDialog();
                    },
                  ),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
