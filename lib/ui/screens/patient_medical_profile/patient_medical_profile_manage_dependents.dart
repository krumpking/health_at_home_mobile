import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/user/dependent.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/patient_dependent_list_card.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/patient/dependents/dependent_details.dart';
import 'package:mobile/ui/screens/patient/dependents/new_dependent.dart';

import '../home.dart';

class PatientDependentManageDependents extends StatefulWidget {
  const PatientDependentManageDependents({Key? key}) : super(key: key);

  @override
  _PatientDependentManageDependentsState createState() => _PatientDependentManageDependentsState();
}

class _PatientDependentManageDependentsState extends State<PatientDependentManageDependents> {
  ApiProvider _provider = new ApiProvider();
  List<Dependent> _dependents = <Dependent>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  Future<void> _initPage() async {
    setState(() {
      _loading = true;
    });
    var dependants = await _provider.getDependents();
    if (dependants != null) {
      setState(() {
        _dependents = dependants;
      });
    }
    setState(() {
      _loading = false;
    });
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
                      'Dependents & Family',
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
              Expanded(
                child: Container(
                  child: _loading
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
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Text(
                                "You have not set up any dependents.",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            )
                          : MediaQuery.removePadding(
                              removeTop: true,
                              removeBottom: true,
                              context: context,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _dependents.length,
                                itemBuilder: (context, index) {
                                  Dependent dependent = _dependents[index];
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12),
                                    child: PatientDependentEditListCard(
                                      name: "${dependent.firstName} ${dependent.lastName}",
                                      age: Utilities.ageFromDob(dependent.dob),
                                      sex: dependent.gender,
                                      relationship: dependent.relationship,
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return DependentDetails(dependent: dependent);
                                        })).then((value) => _initPage());
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Container(
              padding: EdgeInsets.all(16),
              child: PrimaryLargeButton(
                  title: 'Add New Dependent ',
                  iconWidget: SvgPicture.asset(
                    'assets/icons/icon_plus.svg',
                    color: App.theme.white,
                    width: 18,
                    height: 18,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return NewDependent(isFromList: true);
                    })).then((value) => _initPage());
                  })),
          elevation: 0,
        ),
      ),
    );
  }
}
