import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile/models/saved_address.dart';
import 'package:mobile/models/service.dart';
import 'package:mobile/models/user/preferences.dart';
import 'package:mobile/models/user/workHour.dart';
import 'package:mobile/providers/places.dart';

class DoctorProfile {
  late int? id = 0;
  late String? uuid;
  late String? gender;
  late String? opcNumber;
  late String title = '';
  late String firstName = '';
  late String lastName = '';
  late String displayName = '';
  late String? email;
  late String? phoneCode;
  late String? phone;
  late String? address;
  late String? bio;
  late String? profileImg;
  late String? about;
  late bool isPracticing;
  late bool isAway;
  late double rating = 5.0;
  late DateTime? holidayFrom;
  late DateTime? holidayTo;
  late Place? baseLocation;
  late int? operationRadius;
  late bool isMedicalRegistrationVerified;
  late bool isActive;
  late String specialities = '';
  late String languages = '';
  late List<Service> services = <Service>[];
  late List<WorkHour> workHours = <WorkHour>[];
  late SavedAddress? savedAddress = SavedAddress.init();
  late DoctorPreferences? preferences;

  DoctorProfile.init();

  DoctorProfile.fromJson(profileData) {
    if (profileData.containsKey('id')) id = profileData['id'];
    if (profileData.containsKey('uuid')) uuid = profileData['uuid'];
    if (profileData.containsKey('gender')) gender = profileData['gender'];
    if (profileData.containsKey('opcNumber')) opcNumber = profileData['opcNumber'];
    if (profileData.containsKey('title')) title = profileData['title'] != null ? profileData['title'] : '';
    if (profileData.containsKey('firstName')) firstName = profileData['firstName'];
    if (profileData.containsKey('lastName')) lastName = profileData['lastName'];
    if (profileData.containsKey('email')) email = profileData['email'];
    if (profileData.containsKey('phoneCode')) phoneCode = profileData['phoneCode'];
    if (profileData.containsKey('phone')) phone = profileData['phone'];
    if (profileData.containsKey('address')) address = profileData['address'];
    if (profileData.containsKey('bio')) bio = profileData['bio'];
    if (profileData.containsKey('about')) about = profileData['about'];
    if (profileData.containsKey('rating')) rating = double.parse(profileData['rating'].toString());
    if (profileData.containsKey('specialities')) specialities = profileData['specialities'];
    if (profileData.containsKey('languages')) languages = profileData['languages'];
    if (profileData.containsKey('profileImg')) profileImg = profileData['profileImg'];
    if (profileData.containsKey('isPracticing')) isPracticing = (profileData['isPracticing'] == 1) ? true : false;
    if (profileData.containsKey('isAway')) isAway = (profileData['isAway'] == 1) ? true : false;
    if (profileData.containsKey('holidayFrom')) holidayFrom = profileData['holidayFrom'] != null ? DateTime.parse(profileData['holidayFrom']) : null;
    if (profileData.containsKey('holidayTo')) holidayTo = profileData['holidayTo'] != null ? DateTime.parse(profileData['holidayTo']) : null;
    if (profileData.containsKey('baseLocationLat') &&
        profileData.containsKey('baseLocationLng') &&
        profileData['baseLocationLat'].toString().isNotEmpty &&
        profileData['baseLocationLng'].toString().isNotEmpty) {
      Place place = new Place();
      place.lat = profileData['baseLocationLat'];
      place.lng = profileData['baseLocationLng'];
      baseLocation = place;
    }
    if (profileData.containsKey('operationRadius')) operationRadius = profileData['operationRadius'];
    if (profileData.containsKey('isMedicalRegistrationVerified')) isMedicalRegistrationVerified = (profileData['isMedicalRegistrationVerified'] == 1) ? true : false;
    if (profileData.containsKey('isActive')) isActive = (profileData['isActive'] == 1) ? true : false;

    if (profileData.containsKey('workHours')) workHours = profileData['workHours'].map<WorkHour>((p) => WorkHour(p['day'], p['from'], p['to'])).toList();

    if (profileData.containsKey('services')) services = profileData['services'].map<Service>((p) => Service.fromJson(p)).toList();

    if (profileData.containsKey('savedAddress') && profileData['savedAddress'] != null) {
      savedAddress = SavedAddress.fromJson(profileData['savedAddress']);
    } else {
      savedAddress = SavedAddress.init();
    }

    if (profileData.containsKey('preferences')) {
      preferences = DoctorPreferences.fromJson(profileData['preferences']);
    }

    displayName = firstName + ' ' + lastName;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'gender': gender == 'male' ? 2 : (gender == 'female' ? 1 : 3),
        'profileImg': profileImg,
        'opcNumber': opcNumber,
        "about": about,
        "bio": bio,
        'title': title,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'address': address,
        'isPracticing': isPracticing,
        'languages': languages,
        'specialities': specialities,
        'isAway': isAway,
        'holidayFrom': holidayFrom == null ? null : holidayFrom!.toIso8601String(),
        'holidayTo': holidayTo == null ? null : holidayTo!.toIso8601String(),
        'baseLocationLat': baseLocation!.lat,
        'baseLocationLng': baseLocation!.lng,
        'operationRadius': operationRadius
      };

  String getDistance(LatLng locationA, LatLng locationB, bool forEta) {
    double distance = Geolocator.distanceBetween(locationA.latitude, locationA.longitude, locationB.latitude, locationB.longitude);
    String distanceStr = '';

    if (distance < 100 && forEta) {
      return 'Arrived';
    }

    if (distance >= 1000) {
      distanceStr = (distance / 1000).toStringAsFixed(2) + ' km away';
    } else {
      distanceStr = distance.toStringAsFixed(2) + ' m away';
    }

    return distanceStr;
  }
}
