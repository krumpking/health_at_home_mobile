import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/saved_address.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/places.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/location_card.dart';
import 'package:mobile/ui/partials/my_app_bar.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';
import 'package:mobile/ui/screens/doctor/settings/doctor_availabilities.dart';

class DoctorBaseLocation extends StatefulWidget {
  const DoctorBaseLocation({Key? key}) : super(key: key);

  @override
  _DoctorBaseLocationState createState() => _DoctorBaseLocationState();
}

class _DoctorBaseLocationState extends State<DoctorBaseLocation> {
  ApiProvider _provider = new ApiProvider();
  late LatLng _selectedPosition;
  late TextEditingController locationController = TextEditingController();
  final unitController = TextEditingController();
  final additionalController = TextEditingController();
  bool positionStreamStarted = false;
  List<Suggestion> _places = <Suggestion>[];
  bool loading = false;
  bool locationLoading = true;
  bool placesLoading = false;
  bool additionalRequired = false;
  bool showAdditionalError = false;
  var locationField = FocusNode();

  @override
  void initState() {
    locationController.text = '';
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    setState(() {
      locationLoading = true;
    });
    SavedAddress? dbAddress = await _provider.getDoctorSavedAddress();
    if (dbAddress != null) {
      setState(() {
        locationController.text = dbAddress.address;
        unitController.text = dbAddress.unit;
        additionalController.text = dbAddress.notes;
        _selectedPosition = LatLng(double.parse(dbAddress.lat), double.parse(dbAddress.lng));
      });
    } else {
      if (App.currentLocation != null) {
        var address = await Utilities.getAddressString(App.currentLocation!);
        setState(() {
          locationController.text = address;
          _selectedPosition = LatLng(App.currentLocation!.longitude, App.currentLocation!.longitude);
        });
      }
    }

    if (locationController.value.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(locationField);
    }
    setState(() {
      locationLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DarkStatusNavigationBarWidget(
      child: Scaffold(
        appBar: myAppBar(),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: App.theme.darkBackground,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width,
                  height: 84,
                  color: App.theme.darkGrey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add a Base Location',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: App.theme.white,
                        ),
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.close,
                          color: App.theme.white,
                          size: 32,
                        ),
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => DoctorHome(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 16, left: 16, bottom: 0, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Base Location',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: App.theme.mutedLightColor,
                                  )),
                              SizedBox(height: 8),
                              TextField(
                                style: TextStyle(fontSize: 18, color: Colors.white),
                                controller: locationController,
                                keyboardType: TextInputType.text,
                                readOnly: locationLoading,
                                onChanged: (value) async {
                                  if (value.isNotEmpty && value.trim().length >= 3) {
                                    setState(() {
                                      placesLoading = true;
                                    });
                                    var places = await PlaceApiProvider(UniqueKey()).fetchSuggestions(value);
                                    setState(() {
                                      _places = places.take(5).toList();
                                      placesLoading = false;
                                    });
                                  }
                                },
                                focusNode: locationField,
                                decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: SvgPicture.asset(
                                        'assets/icons/icon_location.svg',
                                        height: 8,
                                        width: 8,
                                      ),
                                    ),
                                    suffixIcon: locationLoading || placesLoading
                                        ? Container(
                                            padding: EdgeInsets.all(16),
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(App.theme.turquoise!),
                                              strokeWidth: 3,
                                            ),
                                            height: 16,
                                            width: 16,
                                          )
                                        : locationController.value.text.isNotEmpty
                                            ? GestureDetector(
                                                onTap: () {
                                                  locationController.clear();
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Icon(
                                                    Icons.delete_outline_rounded,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                    fillColor: App.theme.mutedLightFillColor,
                                    filled: true,
                                    hintText: '',
                                    hintStyle: TextStyle(fontSize: 18, color: Colors.white),
                                    contentPadding: EdgeInsets.only(left: 8, right: 8),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: (App.theme.darkBackground)!, width: 1.0),
                                        borderRadius: BorderRadius.circular(10.0))),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Tip: Add the location you travel from the most.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: App.theme.mutedLightColor,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    locationLoading = true;
                                    _places = <Suggestion>[];
                                  });
                                  var loc = await Utilities.getUserLocation();
                                  if (loc != null) {
                                    var address = await Utilities.getAddressString(loc);
                                    setState(() {
                                      locationController.text = address;
                                      locationLoading = false;
                                      _selectedPosition = loc;
                                    });
                                  } else {
                                    setState(() {
                                      locationLoading = false;
                                    });
                                  }
                                },
                                child: ListTile(
                                  leading: Icon(Icons.location_searching_rounded, size: 20, color: Colors.green),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                  minLeadingWidth: 16,
                                  minVerticalPadding: 10,
                                  title: Text(
                                    'Use my current location',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: App.activeApp == ActiveApp.DOCTOR ? App.theme.white : App.theme.darkText,
                                    ),
                                  ),
                                ),
                              ),
                              Divider(color: App.theme.grey600!.withOpacity(0.5), height: 2),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 0, left: 16, bottom: 0, right: 16),
                          child: MediaQuery.removePadding(
                            removeTop: true,
                            removeBottom: true,
                            context: context,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _places.length,
                              itemBuilder: (context, index) {
                                Suggestion suggestion = _places[index];
                                return GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      locationLoading = true;
                                    });
                                    Place place = await PlaceApiProvider(UniqueKey()).getPlaceDetailFromId(suggestion.placeId);
                                    LatLng position = LatLng(double.parse(place.lat!), double.parse(place.lng!));
                                    setState(() {
                                      locationController.text = suggestion.description.replaceAll(', Zimbabwe', '');
                                      _places = <Suggestion>[];
                                      _selectedPosition = position;
                                    });

                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      locationLoading = false;
                                    });
                                  },
                                  child: LocationCard(icon: 'icon_map.svg', title: suggestion.description, address: ''),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: App.theme.darkBackground,
          child: Container(
            padding: EdgeInsets.all(16),
            child: loading
                ? PrimaryButtonLoading()
                : PrimaryLargeButton(
                    title: 'Confirm Base Location',
                    iconWidget: SizedBox(),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        additionalRequired = false;
                        showAdditionalError = false;
                      });

                      if (locationController.value.text.contains('Unnamed') && unitController.value.text.isEmpty) {
                        setState(() {
                          additionalRequired = true;
                          showAdditionalError = true;
                        });

                        return;
                      }
                      setState(() {
                        loading = true;
                      });

                      App.currentUser.doctorProfile!.savedAddress!.lat = _selectedPosition.latitude.toString();
                      App.currentUser.doctorProfile!.savedAddress!.lng = _selectedPosition.longitude.toString();
                      App.currentUser.doctorProfile!.savedAddress!.address = locationController.value.text;
                      App.currentUser.doctorProfile!.savedAddress!.unit = unitController.value.text;
                      App.currentUser.doctorProfile!.savedAddress!.notes = additionalController.value.text;

                      App.currentUser.doctorProfile!.savedAddress!.doctorProfileId = App.currentUser.doctorProfile!.id!;

                      ApiProvider _provider = new ApiProvider();
                      var address = await _provider.createUpdateDoctorAddress();
                      if (address != null) {
                        _saveChangesDialog();
                      }

                      setState(() {
                        loading = false;
                      });
                    },
                  ),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Future<void> _saveChangesDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: App.theme.darkGrey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
          contentPadding: EdgeInsets.all(16),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 8),
                SvgPicture.asset('assets/icons/icon_success.svg'),
                SizedBox(height: 24),
                Text(
                  'Location Saved',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: App.theme.white),
                ),
                SizedBox(height: 16),
                Text(
                  'Your base location is now saved.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.mutedLightColor),
                ),
                SizedBox(height: 16),
                SuccessRegularButton(
                    title: 'Back to Availabilities',
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => DoctorAvailabilities(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    }),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
