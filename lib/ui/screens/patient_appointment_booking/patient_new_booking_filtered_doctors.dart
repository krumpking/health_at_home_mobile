import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/user/doctorProfile.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/doctor_search.dart';
import 'package:mobile/providers/places.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_new_booking_availabilities.dart';
import 'package:mobile/ui/screens/patient_browse_page/patient_view_doctor_profile.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

class PatientNewBookingFilteredDoctors extends StatefulWidget {
  const PatientNewBookingFilteredDoctors({Key? key}) : super(key: key);

  @override
  _PatientNewBookingFilteredDoctorsState createState() =>
      _PatientNewBookingFilteredDoctorsState();
}

class _PatientNewBookingFilteredDoctorsState
    extends State<PatientNewBookingFilteredDoctors> {
  ApiProvider _provider = new ApiProvider();
  late List<DoctorProfile> allDoctors = App.doctors;
  final locationController = TextEditingController();
  late Suggestion location;
  final sessionToken = Utilities.uuid();
  bool _loaded = false;
  late DoctorSearch _search = new DoctorSearch();
  late Gender _genderValue = App.doctorSearch.gender;
  late Rating _ratingValue = App.doctorSearch.rating;
  var _informationText = 'Select from these available doctors';

  @override
  void initState() {
    super.initState();
    startPage();
  }

  Future<void> startPage() async {
    setState(() {
      _search.location = LatLng(double.parse(App.progressBooking!.latitude),
          double.parse(App.progressBooking!.longitude));
    });

    var _docs = await _provider.getAllDoctors({});
    if (_docs != null) {
      setState(() {
        if (App.isLoggedIn && App.currentUser.doctorProfile != null) {
          allDoctors =
              _docs; //.where((doctor) => doctor.id != App.currentUser.doctorProfile!.id).toList();
        } else {
          allDoctors = _docs;
        }
        _loaded = true;
      });
    } else {
      print("Something failed");
    }
  }

  Future<List<DoctorProfile>?> _findDoctors() async {
    setState(() {
      _search.serviceIds = [App.progressBooking!.primaryService.id];
    });
    var docs = Utilities.searchDoctors(allDoctors, _search); // do searc;
    if (docs.length < 1) {
      setState(() {
        _informationText =
            'Sorry, there are no practitioners available for the location and/or filters you have selected. However please see below all doctors available';
      });
    }
    return docs;
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
                  children: [
                    Container(
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
                          TextField(
                            style:
                                TextStyle(fontSize: 18, color: App.theme.white),
                            controller: locationController,
                            readOnly: true,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                      'assets/icons/icon_location.svg'),
                                ),
                                fillColor: App.theme.white,
                                filled: true,
                                hintText: App.progressBooking!.address,
                                hintStyle: TextStyle(
                                    fontSize: 16, color: App.theme.grey800),
                                contentPadding:
                                    EdgeInsets.only(left: 8, right: 8),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: (App.theme.grey300)!,
                                        width: 1.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: (App.theme.grey300)!,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: (App.theme.grey300)!,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0))),
                          ),
                          SizedBox(height: 16),
                          Text(
                            _informationText,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 19,
                              color: App.theme.grey900,
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 16, left: 8),
                        color: App.theme.turquoise50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SecondarySelectButton(
                                title: 'Filters',
                                onPressed: () {
                                  _showModalBottomSheet(context);
                                }),
                          ],
                        )),
                  ],
                ),
              ),
              FutureBuilder<List<DoctorProfile>?>(
                  future: _findDoctors(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !_loaded) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.08),
                        child: Container(
                          child: SizedBox(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  App.theme.turquoise!),
                              strokeWidth: 3,
                            ),
                            height: MediaQuery.of(context).size.height * 0.04,
                            width: MediaQuery.of(context).size.height * 0.04,
                          ),
                        ),
                      );
                    } else if (snapshot.data!.length > 0 && _loaded) {
                      return Expanded(
                        child: MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final DoctorProfile doctorProfile =
                                  snapshot.data![index];
                              return GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  padding: EdgeInsets.only(left: 16),
                                  color: App.theme.white,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: App.theme.grey!
                                                .withOpacity(0.1),
                                            backgroundImage: doctorProfile
                                                        .profileImg !=
                                                    null
                                                ? NetworkImage(
                                                    doctorProfile.profileImg!)
                                                : null,
                                            radius: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                          ),
                                          SizedBox(width: 16),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  (doctorProfile
                                                              .title.isNotEmpty
                                                          ? doctorProfile.title
                                                                  .replaceAll(
                                                                      '.', '') +
                                                              '. '
                                                          : '') +
                                                      Utilities
                                                          .convertToTitleCase(
                                                              doctorProfile
                                                                  .displayName),
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    color: App.theme.grey900,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  doctorProfile.specialities
                                                          .isNotEmpty
                                                      ? doctorProfile
                                                          .specialities
                                                      : '',
                                                  textAlign: TextAlign.start,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 14,
                                                    color: App.theme.grey400,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SimpleStarRating(
                                                      allowHalfRating: false,
                                                      starCount: 5,
                                                      rating: double.parse(
                                                          doctorProfile.rating
                                                              .toString()),
                                                      size: 24,
                                                      filledIcon: Icon(
                                                          Icons.star,
                                                          color: App.theme
                                                              .btnDarkSecondary,
                                                          size: 24),
                                                      nonFilledIcon: Icon(
                                                          Icons.star,
                                                          color:
                                                              App.theme.grey300,
                                                          size: 24),
                                                      onRated: (rate) {},
                                                      spacing: 4,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        children: [
                                          (App.progressBooking!.latitude
                                                      .isNotEmpty &&
                                                  App.progressBooking!.longitude
                                                      .isNotEmpty &&
                                                  doctorProfile.savedAddress !=
                                                      null &&
                                                  doctorProfile.savedAddress!
                                                      .lat.isNotEmpty &&
                                                  doctorProfile.savedAddress!
                                                      .lng.isNotEmpty)
                                              ? Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 12,
                                                      ),
                                                      SvgPicture.asset(
                                                        'assets/icons/icon_map.svg',
                                                        color:
                                                            App.theme.turquoise,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        doctorProfile
                                                            .getDistance(
                                                              LatLng(
                                                                  double.parse(
                                                                      doctorProfile
                                                                          .savedAddress!
                                                                          .lat),
                                                                  double.parse(
                                                                      doctorProfile
                                                                          .savedAddress!
                                                                          .lng)),
                                                              LatLng(
                                                                  double.parse(App
                                                                      .progressBooking!
                                                                      .latitude),
                                                                  double.parse(App
                                                                      .progressBooking!
                                                                      .longitude)),
                                                              false,
                                                            )
                                                            .toUpperCase(),
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12,
                                                            color: App.theme
                                                                .turquoise),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 12,
                                                      ),
                                                      SvgPicture.asset(
                                                          'assets/icons/icon_calendar.svg'),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'ALL AVAILABILITIES',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12,
                                                            color: App.theme
                                                                .turquoise,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          Expanded(
                                            child: GestureDetector(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/icon_user.svg',
                                                      height: 18,
                                                      color:
                                                          App.theme.turquoise),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'VIEW PROFILE',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                        color:
                                                            App.theme.turquoise,
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return PatientViewDoctorProfile(
                                                      doctor: doctorProfile);
                                                }));
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  // this is the part that you need
                                  App.progressBooking!.selectedDoctor =
                                      doctorProfile;
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return PatientNewBookingAvailabilities(
                                        doctorProfile: doctorProfile,
                                        isEdit: false);
                                  }));
                                },
                              );
                            },
                          ),
                        ),
                      );
                    } else if (snapshot.data!.length == 0 && _loaded) {
                      return Container(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: allDoctors.length,
                            itemBuilder: (context, index) {
                              final DoctorProfile doctorProfile =
                                  allDoctors[index];
                              return GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  padding: EdgeInsets.only(left: 16),
                                  color: App.theme.white,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: App.theme.grey!
                                                .withOpacity(0.1),
                                            backgroundImage: doctorProfile
                                                        .profileImg !=
                                                    null
                                                ? NetworkImage(
                                                    doctorProfile.profileImg!)
                                                : null,
                                            radius: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                          ),
                                          SizedBox(width: 16),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  (doctorProfile
                                                              .title.isNotEmpty
                                                          ? doctorProfile.title
                                                                  .replaceAll(
                                                                      '.', '') +
                                                              '. '
                                                          : '') +
                                                      Utilities
                                                          .convertToTitleCase(
                                                              doctorProfile
                                                                  .displayName),
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    color: App.theme.grey900,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  doctorProfile.specialities
                                                          .isNotEmpty
                                                      ? doctorProfile
                                                          .specialities
                                                      : '',
                                                  textAlign: TextAlign.start,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 14,
                                                    color: App.theme.grey400,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SimpleStarRating(
                                                      allowHalfRating: false,
                                                      starCount: 5,
                                                      rating: double.parse(
                                                          doctorProfile.rating
                                                              .toString()),
                                                      size: 24,
                                                      filledIcon: Icon(
                                                          Icons.star,
                                                          color: App.theme
                                                              .btnDarkSecondary,
                                                          size: 24),
                                                      nonFilledIcon: Icon(
                                                          Icons.star,
                                                          color:
                                                              App.theme.grey300,
                                                          size: 24),
                                                      onRated: (rate) {},
                                                      spacing: 4,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        children: [
                                          (App.progressBooking!.latitude
                                                      .isNotEmpty &&
                                                  App.progressBooking!.longitude
                                                      .isNotEmpty &&
                                                  doctorProfile.savedAddress !=
                                                      null &&
                                                  doctorProfile.savedAddress!
                                                      .lat.isNotEmpty &&
                                                  doctorProfile.savedAddress!
                                                      .lng.isNotEmpty)
                                              ? Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 12,
                                                      ),
                                                      SvgPicture.asset(
                                                        'assets/icons/icon_map.svg',
                                                        color:
                                                            App.theme.turquoise,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        doctorProfile
                                                            .getDistance(
                                                              LatLng(
                                                                  double.parse(
                                                                      doctorProfile
                                                                          .savedAddress!
                                                                          .lat),
                                                                  double.parse(
                                                                      doctorProfile
                                                                          .savedAddress!
                                                                          .lng)),
                                                              LatLng(
                                                                  double.parse(App
                                                                      .progressBooking!
                                                                      .latitude),
                                                                  double.parse(App
                                                                      .progressBooking!
                                                                      .longitude)),
                                                              false,
                                                            )
                                                            .toUpperCase(),
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12,
                                                            color: App.theme
                                                                .turquoise),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 12,
                                                      ),
                                                      SvgPicture.asset(
                                                          'assets/icons/icon_calendar.svg'),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'ALL AVAILABILITIES',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12,
                                                            color: App.theme
                                                                .turquoise,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          Expanded(
                                            child: GestureDetector(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/icon_user.svg',
                                                      height: 18,
                                                      color:
                                                          App.theme.turquoise),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'VIEW PROFILE',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                        color:
                                                            App.theme.turquoise,
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return PatientViewDoctorProfile(
                                                      doctor: doctorProfile);
                                                }));
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  App.progressBooking!.selectedDoctor =
                                      doctorProfile;
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return PatientNewBookingAvailabilities(
                                        doctorProfile: doctorProfile,
                                        isEdit: false);
                                  }));
                                },
                              );
                            },
                          ));
                    } else {
                      return Container(
                        margin: EdgeInsets.only(top: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SvgPicture.asset(
                                'assets/icons/icon_circle_close_red.svg',
                                height: 32,
                                width: 32,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Sorry, something went wrong. Please try again.',
                                softWrap: true,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: App.theme.grey900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void changeSelectedGender(Gender? value, StateSetter modalState) {
    modalState(() {
      _genderValue = value!;
    });

    setState(() {
      _genderValue = value!;
      _search.gender = value;
      App.doctorSearch.gender = _search.gender;
    });
    _findDoctors();
  }

  void changeSelectedRating(Rating? value, StateSetter modalState) {
    modalState(() {
      _ratingValue = value!;
    });

    setState(() {
      _ratingValue = value!;
      _search.rating = value;
    });
    _findDoctors();
  }

  void changeSelectedServices() {
    setState(() {
      _search.serviceIds = App.doctorSearch.serviceIds;
    });
  }

  _showModalBottomSheet(context) async {
    showModalBottomSheet(
      elevation: 0,
      barrierColor: Colors.black.withAlpha(1),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            padding: EdgeInsets.all(24),
            height: MediaQuery.of(context).size.height * 0.95,
            decoration: BoxDecoration(
              color: App.theme.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text('Filters',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: App.theme.grey800,
                      )),
                  SizedBox(height: 32),
                  // Text('Services',
                  //     style: TextStyle(
                  //
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 16,
                  //       color: App.theme.grey800,
                  //     )),
                  // SizedBox(height: 4),
                  // Divider(color: App.theme.grey300),
                  // ListView.builder(
                  //     shrinkWrap: true,
                  //     itemCount: Utilities.getPrimaryServices().length,
                  //     itemBuilder: (context, index) {
                  //       Service service = Utilities.getPrimaryServices()[index];
                  //       return FilterCheckBoxItem(
                  //         service: service,
                  //         modalState: setModalState,
                  //         parentState: setState,
                  //         isChecked:
                  //             (_search.serviceIds.indexOf(service.id) > 0),
                  //       );
                  //     }),
                  // SizedBox(height: 8),
                  Text('Star Rating',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: App.theme.grey800,
                      )),
                  SizedBox(height: 4),
                  Divider(color: App.theme.grey300),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Radio<Rating>(
                            value: Rating.all,
                            groupValue: _ratingValue,
                            onChanged: (Rating? value) =>
                                {changeSelectedRating(value, setModalState)},
                            activeColor: App.theme.turquoise,
                          ),
                          Expanded(
                            child: Text(
                              'All',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: App.theme.grey900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(color: App.theme.grey300)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Radio<Rating>(
                            value: Rating.threeStarsPlus,
                            groupValue: _ratingValue,
                            onChanged: (Rating? value) =>
                                {changeSelectedRating(value, setModalState)},
                            activeColor: App.theme.turquoise,
                          ),
                          Expanded(
                            child: Text(
                              '3+ Stars',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: App.theme.grey900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(color: App.theme.grey300)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Radio<Rating>(
                            value: Rating.fourStarsPlus,
                            groupValue: _ratingValue,
                            onChanged: (Rating? value) =>
                                {changeSelectedRating(value, setModalState)},
                            activeColor: App.theme.turquoise,
                          ),
                          Expanded(
                            child: Text(
                              '4+ Stars',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: App.theme.grey900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(color: App.theme.grey300)
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Other Filters',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: App.theme.grey800,
                      )),
                  SizedBox(height: 4),
                  Divider(color: App.theme.grey300),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Radio<Gender>(
                            value: Gender.all,
                            groupValue: _genderValue,
                            onChanged: (Gender? value) =>
                                {changeSelectedGender(value, setModalState)},
                            activeColor: App.theme.turquoise,
                          ),
                          Expanded(
                            child: Text(
                              'All',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: App.theme.grey900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(color: App.theme.grey300)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Radio<Gender>(
                            value: Gender.male,
                            groupValue: _genderValue,
                            onChanged: (Gender? value) =>
                                {changeSelectedGender(value, setModalState)},
                            activeColor: App.theme.turquoise,
                          ),
                          Text(
                            'Male',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                              color: App.theme.grey900,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: App.theme.grey300)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Radio<Gender>(
                            value: Gender.female,
                            groupValue: _genderValue,
                            onChanged: (Gender? value) =>
                                {changeSelectedGender(value, setModalState)},
                            activeColor: App.theme.turquoise,
                          ),
                          Text(
                            'Female',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                              color: App.theme.grey900,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: App.theme.grey300)
                    ],
                  ),
                  PrimaryLargeButton(
                      title: 'Confirm Filters',
                      iconWidget: SizedBox(),
                      onPressed: () {
                        setState(() {
                          //_doctors = Utilities.searchDoctors(App.doctorSearch);
                        });
                        setModalState(() {
                          //_doctors = Utilities.searchDoctors(App.doctorSearch);
                        });
                        Navigator.pop(context);
                      }),
                  SizedBox(height: 16)
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
