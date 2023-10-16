import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/places.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/location_card.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_new_booking_filtered_doctors.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_new_booking_reasons_visit.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_new_booking_visit_summary.dart';
import 'package:permission_handler/permission_handler.dart';

class PatientNewBookingAddress extends StatefulWidget {
  final bool isEdit;
  const PatientNewBookingAddress({Key? key, required this.isEdit})
      : super(key: key);

  @override
  _PatientNewBookingAddressState createState() =>
      _PatientNewBookingAddressState();
}

class _PatientNewBookingAddressState extends State<PatientNewBookingAddress> {
  ApiProvider apiProvider = new ApiProvider();
  late LatLng _selectedPosition;
  final locationController = TextEditingController();
  final unitController = TextEditingController();
  final additionalController = TextEditingController();
  bool positionStreamStarted = false;
  List<Suggestion> _places = <Suggestion>[];
  bool loading = false;
  bool locationLoading = false;
  bool placesLoading = false;
  var locationField = FocusNode();
  bool additionalRequired = false;
  bool showAdditionalError = false;
  bool locationGranted = true;

  @override
  void initState() {
    locationController.text = '';
    super.initState();
    initApp();
  }

  void initApp() async {
    if (App.currentUser.patientProfile!.savedAddress!.lat.isNotEmpty &&
        App.currentUser.patientProfile!.savedAddress!.lng.isNotEmpty) {
      LatLng position = LatLng(
          double.parse(App.currentUser.patientProfile!.savedAddress!.lat),
          double.parse(App.currentUser.patientProfile!.savedAddress!.lng));
      setState(() {
        locationController.text =
            App.currentUser.patientProfile!.savedAddress!.address;
        unitController.text =
            App.currentUser.patientProfile!.savedAddress!.unit;
        additionalController.text =
            App.currentUser.patientProfile!.savedAddress!.notes;
        _selectedPosition = position;
      });
    } else {
      var position = await Utilities.getUserLocation();
      if (position != null) {
        App.currentLocation = position;
        var address = await Utilities.getAddressString(position);
        setState(() {
          locationController.text = address;
          _selectedPosition = position;
        });
      }
    }
    if (App.currentLocation == null) {
      if (await Permission.location.serviceStatus.isEnabled) {
        var status = await Permission.location.status;
        if (status.isGranted) {
          var position = await Utilities.getUserLocation();
          if (position != null) {
            App.currentLocation = position;
            var address = await Utilities.getAddressString(position);
            setState(() {
              locationController.text = address;
              _selectedPosition = position;
            });
          }
        } else {
          Fluttertoast.showToast(
            msg: 'Please allow location permissions for Health At Home ',
            backgroundColor: App.theme.primary100,
          );
          AppSettings.openAppSettings(type: AppSettingsType.location);
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Please allow location permissions for Health At Home ',
          backgroundColor: App.theme.primary100,
        );
        AppSettings.openAppSettings(type: AppSettingsType.location);
      }
    } else {
      setState(() {
        locationLoading = true;
      });
    }

    if (locationController.value.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(locationField);
    }

    if (widget.isEdit && App.progressBooking!.address.isNotEmpty) {
      setState(() {
        locationController.text = App.progressBooking!.address;
      });
    }

    setState(() {
      locationLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        extendBody: true,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24),
                      Text(
                        'Where will the appointment be?',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                          color: App.theme.grey900,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        style:
                            TextStyle(fontSize: 18, color: App.theme.darkText),
                        controller: locationController,
                        keyboardType: TextInputType.text,
                        readOnly: locationLoading,
                        onChanged: (value) async {
                          if (value.isNotEmpty && value.trim().length >= 3) {
                            setState(() {
                              placesLoading = true;
                              _places = <Suggestion>[];
                            });
                            var places = await PlaceApiProvider(UniqueKey())
                                .fetchSuggestions(value);
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          App.theme.turquoise!),
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
                            hintStyle:
                                TextStyle(fontSize: 18, color: Colors.white),
                            contentPadding: EdgeInsets.only(left: 8, right: 8),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: (App.theme.grey300)!, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: (App.theme.grey300)!, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: (App.theme.grey300)!, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0))),
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
                          leading: Icon(Icons.location_searching_rounded,
                              size: 20, color: Colors.green),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          minLeadingWidth: 16,
                          minVerticalPadding: 10,
                          title: Text(
                            'Use my current location',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: App.theme.darkText,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                          color: App.theme.grey600!.withOpacity(0.5),
                          height: 2),
                      MediaQuery.removePadding(
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
                                Place place = await PlaceApiProvider(
                                        UniqueKey())
                                    .getPlaceDetailFromId(suggestion.placeId);
                                LatLng position = LatLng(
                                    double.parse(place.lat!),
                                    double.parse(place.lng!));
                                setState(() {
                                  locationController.text = suggestion
                                      .description
                                      .replaceAll(', Zimbabwe', '');
                                  _places = <Suggestion>[];
                                  _selectedPosition = position;
                                });

                                FocusScope.of(context).unfocus();
                              },
                              child: LocationCard(
                                  icon: 'icon_map.svg',
                                  title: suggestion.description,
                                  address: ''),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Column(
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
                            style: TextStyle(
                                fontSize: 15, color: App.theme.darkText),
                            controller: unitController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                fillColor: App.theme.white,
                                filled: true,
                                hintText: 'Unit number / Building number',
                                hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: App.theme.mutedLightColor),
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
                                hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: App.theme.mutedLightColor),
                                contentPadding: EdgeInsets.all(8),
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
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        //TODO MAKE SURE THIS BOTTON NAVIGATION IS SHOWING WHETHER OR NOT LOCATION IS GRANTED
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: locationGranted
              ? Container(
                  padding: EdgeInsets.all(16),
                  child: loading
                      ? PrimaryButtonLoading()
                      : PrimaryLargeButton(
                          title: 'Confirm Location',
                          iconWidget: SizedBox(),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              additionalRequired = false;
                              showAdditionalError = false;
                            });

                            if (locationController.value.text
                                    .contains('Unnamed') &&
                                unitController.value.text.isEmpty) {
                              setState(() {
                                additionalRequired = true;
                                showAdditionalError = true;
                              });

                              return;
                            }
                            setState(() {
                              loading = true;
                            });

                            try {
                              App.progressBooking!.latitude =
                                  _selectedPosition.latitude.toString();
                              App.progressBooking!.longitude =
                                  _selectedPosition.longitude.toString();
                              App.progressBooking!.address =
                                  locationController.value.text;

                              if (unitController.value.text.isNotEmpty)
                                App.progressBooking!.unitNumber =
                                    unitController.value.text;
                              if (additionalController.value.text.isNotEmpty)
                                App.progressBooking!.addressNotes =
                                    additionalController.value.text;

                              if (widget.isEdit) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PatientNewBookingVisitSummary();
                                }));

                                return;
                              }

                              if (App.progressBooking!.bookingCriteria ==
                                  BookingCriteria.ASAP) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PatientNewBookingReasonsVisit();
                                }));
                              } else {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PatientNewBookingFilteredDoctors();
                                }));
                              }
                              setState(() {
                                loading = false;
                              });
                            } catch (_er) {
                              setState(() {
                                loading = false;
                              });
                            }
                          },
                        ),
                )
              : null,
          elevation: 0,
        ),
      ),
    );
  }
}
