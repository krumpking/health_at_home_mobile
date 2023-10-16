import 'package:mobile/models/referral_code.dart';
import 'package:mobile/models/saved_address.dart';
import 'package:mobile/models/user/preferences.dart';
import 'package:mobile/providers/places.dart';

import '../referred_code.dart';

class PatientProfile {
  late int? id;
  late String? uuid;
  late String? gender;
  late String firstName = '';
  late String lastName = '';
  late String displayName = '';
  late String? phoneCode;
  late String? phone;
  late String? dob;
  late String? address;
  late String? profileImg;
  late String? chronicConditions;
  late String? allergies;
  late ReferralCode? referralCode;
  late ReferredCode? referredCode;
  late double credit;
  late Place? baseLocation;
  late bool isActive;
  late SavedAddress? savedAddress = SavedAddress.init();
  late PatientPreferences? preferences;

  PatientProfile.init() {
    referredCode = null;
    referralCode = null;
    savedAddress = SavedAddress.init();
  }

  PatientProfile.fromJson(profileData) {
    if (profileData.containsKey('id')) id = profileData['id'];
    if (profileData.containsKey('uuid')) uuid = profileData['uuid'];
    if (profileData.containsKey('gender')) gender = profileData['gender'];
    if (profileData.containsKey('firstName')) firstName = profileData['firstName'];
    if (profileData.containsKey('lastName')) lastName = profileData['lastName'];
    if (profileData.containsKey('credit')) credit = double.parse(profileData['credit'].toString());
    if (profileData.containsKey('phoneCode')) phoneCode = profileData['phoneCode'];
    if (profileData.containsKey('phone')) phone = profileData['phone'];
    if (profileData.containsKey('dob')) dob = profileData['dob'];
    if (profileData.containsKey('address')) address = profileData['address'];
    if (profileData.containsKey('chronicConditions')) chronicConditions = profileData['chronicConditions'];
    if (profileData.containsKey('allergies')) allergies = profileData['allergies'];
    if (profileData.containsKey('profileImg')) profileImg = profileData['profileImg'];
    if (profileData.containsKey('baseLocationLat') &&
        profileData.containsKey('baseLocationLng') &&
        profileData['baseLocationLat'].toString().isNotEmpty &&
        profileData['baseLocationLng'].toString().isNotEmpty) {
      Place place = new Place();
      place.lat = profileData['baseLocationLat'];
      place.lng = profileData['baseLocationLng'];
      baseLocation = place;
    }
    if (profileData.containsKey('isActive')) isActive = (profileData['isActive'] == 1) ? true : false;
    if (profileData.containsKey('referralCode')) {
      referralCode = ReferralCode.fromJson(profileData['referralCode']);
    } else {
      referralCode = null;
    }
    if (profileData.containsKey('referredCode')) {
      referredCode = ReferredCode.fromJson(profileData['referredCode']);
    } else {
      referredCode = null;
    }

    if (profileData.containsKey('savedAddress') && profileData['savedAddress'] != null) {
      savedAddress = SavedAddress.fromJson(profileData['savedAddress']);
    } else {
      savedAddress = SavedAddress.init();
    }

    if (profileData.containsKey('preferences')) {
      preferences = PatientPreferences.fromJson(profileData['preferences']);
    }

    displayName = firstName + ' ' + lastName;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'gender': gender == 'male' ? 2 : (gender == 'female' ? 1 : 3),
        'profileImg': profileImg,
        'firstName': firstName,
        'lastName': lastName,
        'phoneCode': phoneCode,
        'phone': phone,
        'dob': dob,
        'address': address,
        'chronicConditions': chronicConditions,
        'allergies': allergies,
        'baseLocationLat': baseLocation!.lat,
        'baseLocationLng': baseLocation!.lng
      };
}
