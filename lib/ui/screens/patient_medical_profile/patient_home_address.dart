import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/saved_address.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/providers/places.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/location_card.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';

class PatientHomeAddress extends StatefulWidget {
  const PatientHomeAddress({Key? key}) : super(key: key);

  @override
  _PatientHomeAddressState createState() => _PatientHomeAddressState();
}

class _PatientHomeAddressState extends State<PatientHomeAddress> {
  ApiProvider _provider = new ApiProvider();
  late LatLng? selectedPosition;
  final locationController = TextEditingController();
  final unitController = TextEditingController();
  final additionalController = TextEditingController();
  bool positionStreamStarted = false;
  final _formKey = GlobalKey<FormState>();
  List<Suggestion> _places = <Suggestion>[];
  bool loading = false;
  bool locationLoading = false;
  bool placesLoading = false;
  var locationField = FocusNode();
  final addressFieldKey = GlobalKey<FormFieldState>();
  bool additionalRequired = false;
  bool showAdditionalError = false;
  bool showAddressError = false;
  late String addressFieldError = ' Address field is required';
  late String _error = '';

  @override
  void initState() {
    locationController.text = '';
    super.initState();
    initApp();
  }

  void initApp() async {
    setState(() {
      locationLoading = true;
    });
    SavedAddress? dbAddress = await _provider.getPatientSavedAddress();
    if (dbAddress != null) {
      LatLng position = LatLng(double.parse(dbAddress.lat), double.parse(dbAddress.lng));
      setState(() {
        locationController.text = dbAddress.address;
        unitController.text = dbAddress.unit;
        additionalController.text = dbAddress.notes;
        selectedPosition = position;
      });
    } else {
      if (App.currentLocation != null) {
        var address = await Utilities.getAddressString(App.currentLocation!);
        setState(() {
          locationController.text = address;
          selectedPosition = App.currentLocation!;
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
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width,
                  height: 84,
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
                              builder: (context) => Home(3),
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
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add your home address',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 19,
                                  color: App.theme.grey900,
                                ),
                              ),
                              SizedBox(height: 8),
                              Form(
                                key: _formKey,
                                child: TextFormField(
                                  key: addressFieldKey,
                                  style: TextStyle(fontSize: 18, color: App.theme.darkText),
                                  controller: locationController,
                                  readOnly: locationLoading,
                                  validator: (value) {
                                    value = value != null ? value.trim() : value;
                                    setState(() {
                                      addressFieldError = " Address field is required";
                                      showAddressError = false;
                                    });
                                    if (value!.isEmpty) {
                                      setState(() {
                                        showAddressError = true;
                                      });
                                      return '';
                                    } else if (value.length < 10) {
                                      setState(() {
                                        showAddressError = true;
                                        addressFieldError = " Address must be at least 10 characters.";
                                      });
                                      return '';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) async {
                                    if (value.isNotEmpty && value.trim().length >= 3) {
                                      setState(() {
                                        placesLoading = true;
                                        _places = <Suggestion>[];
                                      });
                                      var places = await PlaceApiProvider(UniqueKey()).fetchSuggestions(value);
                                      setState(() {
                                        _places = places.take(5).toList();
                                        placesLoading = false;
                                      });
                                    } else {
                                      setState(() {
                                        _places = <Suggestion>[];
                                      });
                                    }
                                  },
                                  focusNode: locationField,
                                  decoration: InputDecoration(
                                      errorStyle: TextStyle(height: 0),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(left: 20, right: 14, top: 14, bottom: 14),
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
                                      fillColor: App.theme.white,
                                      filled: true,
                                      hintText: '',
                                      hintStyle: TextStyle(fontSize: 18, color: Colors.white),
                                      contentPadding: EdgeInsets.only(left: 8, right: 8),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                      errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0),
                                          borderRadius: BorderRadius.circular(10.0))),
                                ),
                              ),
                              if (showAddressError)
                                Column(
                                  children: [
                                    SizedBox(height: 6),
                                    Text(
                                      addressFieldError,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
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
                                      selectedPosition = loc;
                                    });
                                  }
                                  setState(() {
                                    locationLoading = false;
                                  });
                                },
                                child: ListTile(
                                  leading: Icon(Icons.location_searching_rounded, size: 20, color: App.theme.green),
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
                              Divider(
                                  color: App.activeApp == ActiveApp.DOCTOR ? App.theme.lightGreyColor : App.theme.grey600!.withOpacity(0.5),
                                  height: 2),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
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
                                      selectedPosition = position;
                                    });
                                    setState(() {
                                      locationLoading = false;
                                    });

                                    FocusScope.of(context).unfocus();
                                  },
                                  child: LocationCard(icon: 'icon_map.svg', title: suggestion.description, address: ''),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Unit Number and/or building and street',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              TextField(
                                style: TextStyle(fontSize: 15, color: App.theme.darkText),
                                controller: unitController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    fillColor: App.theme.white,
                                    filled: true,
                                    hintText: 'Unit number / Building number',
                                    hintStyle: TextStyle(fontSize: 15, color: App.theme.mutedLightColor),
                                    contentPadding: EdgeInsets.only(left: 8, right: 8),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0),
                                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0), borderRadius: BorderRadius.circular(10.0))),
                              ),
                              if (showAdditionalError)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 6),
                                    Text(
                                      " Field Required",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              SizedBox(height: 12),
                              Text(
                                'Do you think our provider might get lost or come to a wrong building?\nLeave additional address details here.',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              TextFormField(
                                style: TextStyle(
                                  fontSize: 15,
                                  color: App.theme.darkText,
                                ),
                                controller: additionalController,
                                keyboardType: TextInputType.text,
                                maxLines: 4,
                                decoration: InputDecoration(
                                    fillColor: App.theme.white,
                                    filled: true,
                                    hintText: 'Additional address notes',
                                    hintStyle: TextStyle(fontSize: 15, color: App.theme.mutedLightColor),
                                    contentPadding: EdgeInsets.all(8),
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
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_error.isNotEmpty)
                    Column(
                      children: [
                        Text(
                          _error,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 6),
                      ],
                    ),
                  loading
                      ? PrimaryButtonLoading()
                      : PrimaryLargeButton(
                          title: 'Confirm Base Location',
                          iconWidget: SizedBox(),
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            if (addressFieldKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                additionalRequired = false;
                                showAdditionalError = false;
                              });

                              if (locationController.value.text.contains('Unnamed') && unitController.value.text.isEmpty) {
                                setState(() {
                                  loading = false;
                                  additionalRequired = true;
                                  showAdditionalError = true;
                                });

                                return;
                              }

                              if (selectedPosition == null) {
                                print("============ POSITION IS NULL ========");
                                return;
                              }

                              App.currentUser.patientProfile!.savedAddress!.lat = selectedPosition!.latitude.toString();
                              App.currentUser.patientProfile!.savedAddress!.lng = selectedPosition!.longitude.toString();
                              App.currentUser.patientProfile!.savedAddress!.address = locationController.value.text;
                              App.currentUser.patientProfile!.savedAddress!.unit = unitController.value.text;
                              App.currentUser.patientProfile!.savedAddress!.notes = additionalController.value.text;

                              App.currentUser.patientProfile!.savedAddress!.patientProfileId = App.currentUser.patientProfile!.id!;

                              var address = await _provider.createUpdatePatientAddress();
                              if (address != null) {
                                _saveChangesDialog();
                              } else {
                                _error = ApiResponse.message;
                                ApiResponse.message = '';
                              }

                              setState(() {
                                loading = false;
                              });
                            } else {
                              setState(() {
                                selectedPosition = null;
                                loading = false;
                              });
                              return;
                            }
                          },
                        ),
                ],
              )),
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
          backgroundColor: App.theme.turquoise50,
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
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: App.theme.darkText),
                ),
                SizedBox(height: 16),
                Text(
                  'Your home location is now saved.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.mutedLightColor),
                ),
                SizedBox(height: 16),
                SuccessRegularButton(
                    title: 'Back to Menu',
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => Home(3),
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
