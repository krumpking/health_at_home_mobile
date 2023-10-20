import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/models/service.dart';
import 'package:mobile/models/user/doctorProfile.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/doctor_search.dart';
import 'package:mobile/providers/places.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/filter_item.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_new_booking_availabilities.dart';
import 'package:mobile/ui/screens/patient_browse_page/patient_view_doctor_profile.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

class Doctors extends StatefulWidget {
  const Doctors({Key? key}) : super(key: key);

  @override
  _DoctorsState createState() => _DoctorsState();
}

class _DoctorsState extends State<Doctors> {
  ApiProvider _provider = new ApiProvider();
  late List<DoctorProfile> allDoctors = [];
  late List<DoctorProfile> _searchDoctors = [];
  final locationController = TextEditingController();
  late Suggestion location;
  final sessionToken = Utilities.uuid();
  bool _loaded = false;
  late DoctorSearch _search = new DoctorSearch();
  late Gender _genderValue = App.doctorSearch.gender;
  late Rating _ratingValue = App.doctorSearch.rating;

  @override
  void initState() {
    super.initState();
    startPage();
    App.doctorSearch = new DoctorSearch();
  }

  Future<void> startPage() async {
    var _docs = await _provider.getAllDoctors({});
    App.doctorSearch.serviceIds =
        Utilities.getPrimaryServices().map((e) => e.id).toList();
    if (_docs != null) {
      if (!mounted) return;

      setState(() {
        if (App.isLoggedIn && App.currentUser.doctorProfile != null) {
          allDoctors =
              _docs; //.where((doctor) => doctor.id != App.currentUser.doctorProfile!.id && !doctor.isAway && doctor.workHours.length > 0).toList();
        } else {
          allDoctors = _docs;
        }
        _searchDoctors = allDoctors;
        _loaded = true;
      });
    }
  }

  Future<void> _findDoctors() async {
    setState(() {
      _searchDoctors = Utilities.searchDoctors(allDoctors, _search);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: LightStatusNavigationBarWidget(
          child: Scaffold(
            backgroundColor: App.theme.turquoise50,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16, top: 68, right: 16),
                  decoration: BoxDecoration(
                    color: App.theme.turquoise50,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'View Practitioners',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 23,
                          color: App.theme.grey900,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
                Container(
                    padding:
                        const EdgeInsets.only(top: 8.0, bottom: 16, left: 8),
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
                !_loaded
                    ? Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 32),
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
                      )
                    : _searchDoctors.length == 0
                        ? Container(
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
                                    'Sorry, there are no practitioners available for the location and/or filters you have selected.',
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
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ...List.generate(_searchDoctors.length,
                                      (index) {
                                    final DoctorProfile doctorProfile =
                                        _searchDoctors[index];
                                    bool doctorHasLocation =
                                        (doctorProfile.savedAddress != null &&
                                            doctorProfile
                                                .savedAddress!.lat.isNotEmpty &&
                                            doctorProfile
                                                .savedAddress!.lng.isNotEmpty);
                                    return GestureDetector(
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 4),
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
                                                  backgroundColor: App
                                                      .theme.grey!
                                                      .withOpacity(0.1),
                                                  backgroundImage: doctorProfile
                                                              .profileImg !=
                                                          null
                                                      ? NetworkImage(
                                                          doctorProfile
                                                              .profileImg!)
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        (doctorProfile.title
                                                                    .isNotEmpty
                                                                ? doctorProfile
                                                                        .title
                                                                        .replaceAll(
                                                                            '.',
                                                                            '') +
                                                                    '. '
                                                                : '') +
                                                            Utilities.convertToTitleCase(
                                                                doctorProfile
                                                                    .displayName),
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 18,
                                                          color:
                                                              App.theme.grey900,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      Text(
                                                        doctorProfile
                                                                .specialities
                                                                .isNotEmpty
                                                            ? doctorProfile
                                                                .specialities
                                                            : '',
                                                        textAlign:
                                                            TextAlign.start,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: 14,
                                                          color:
                                                              App.theme.grey400,
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SimpleStarRating(
                                                            allowHalfRating:
                                                                false,
                                                            starCount: 5,
                                                            rating: double.parse(
                                                                doctorProfile
                                                                    .rating
                                                                    .toString()),
                                                            size: 24,
                                                            filledIcon: Icon(
                                                                Icons.star,
                                                                color: App.theme
                                                                    .btnDarkSecondary,
                                                                size: 24),
                                                            nonFilledIcon: Icon(
                                                                Icons.star,
                                                                color: App.theme
                                                                    .grey300,
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
                                                Expanded(
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
                                                        doctorHasLocation
                                                            ? doctorProfile
                                                                .getDistance(
                                                                    LatLng(
                                                                        double.parse(doctorProfile
                                                                            .savedAddress!
                                                                            .lat),
                                                                        double.parse(doctorProfile
                                                                            .savedAddress!
                                                                            .lng)),
                                                                    LatLng(
                                                                        App.currentLocation!
                                                                            .latitude,
                                                                        App.currentLocation!
                                                                            .longitude),
                                                                    false)
                                                                .toUpperCase()
                                                            : '-- --',
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
                                                ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SvgPicture.asset(
                                                            'assets/icons/icon_user.svg',
                                                            height: 18,
                                                            color: App.theme
                                                                .turquoise),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'VIEW PROFILE',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12,
                                                              color: App.theme
                                                                  .turquoise,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline),
                                                        ),
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return PatientViewDoctorProfile(
                                                            doctor:
                                                                doctorProfile);
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
                                        App.progressBooking!.bookingFlow =
                                            BookingFlow.HOME_PLUS;
                                        App.progressBooking!.selectedDoctor =
                                            doctorProfile;

                                        App.isFromViewPractioners = true;
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return PatientNewBookingAvailabilities(
                                              doctorProfile: doctorProfile,
                                              isEdit: false);
                                        }));
                                      },
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
              ],
            ),
          ),
        ),
        onWillPop: () async => false);
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

  void changeSelectedServices(StateSetter stateSetter) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filters',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: App.theme.grey800,
                        ),
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.close,
                          color: App.theme.turquoise,
                          size: 32,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Text('Services',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: App.theme.grey800,
                      )),
                  SizedBox(height: 4),
                  Divider(color: App.theme.grey300),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: Utilities.getPrimaryServices().length,
                      itemBuilder: (context, index) {
                        Service service = Utilities.getPrimaryServices()[index];
                        return FilterCheckBoxItem(
                          service: service,
                          modalState: setModalState,
                          parentState: setState,
                          isChecked:
                              (_search.serviceIds.indexOf(service.id) > 0),
                          tapped: () {
                            changeSelectedServices(setModalState);
                          },
                        );
                      }),
                  SizedBox(height: 8),
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
                        _findDoctors();
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
