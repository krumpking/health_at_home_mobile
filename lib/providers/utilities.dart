import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:maps_launcher/maps_launcher.dart';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/models/service.dart';
import 'package:mobile/models/user/doctorProfile.dart';
import 'package:mobile/models/user/workHour.dart';
import 'package:mobile/providers/doctor_search.dart';
import 'package:mobile/providers/places.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api.dart';

class Utilities {
  static WorkHour? findWorkHourByDay(String day) {
    for (var i = 0; i < App.currentUser.workHours.length; i++) {
      WorkHour hour = App.currentUser.workHours[i];
      if (hour.day.toLowerCase() == day.toLowerCase()) return hour;
    }

    return null;
  }

  static String displayTimeAgoFromTimestamp(DateTime date) {
    final String timestamp = date.toString();
    final year = int.parse(timestamp.substring(0, 4));
    final month = int.parse(timestamp.substring(5, 7));
    final day = int.parse(timestamp.substring(8, 10));
    final hour = int.parse(timestamp.substring(11, 13));
    final minute = int.parse(timestamp.substring(14, 16));

    final DateTime videoDate = DateTime(year, month, day, hour, minute);
    final int diffInHours = DateTime.now().difference(videoDate).inHours;

    String timeAgo = '';
    String timeUnit = '';
    int timeValue = 0;

    if (diffInHours < 1) {
      final diffInMinutes = DateTime.now().difference(videoDate).inMinutes;
      timeValue = diffInMinutes;
      timeUnit = 'minute';
    } else if (diffInHours < 24) {
      timeValue = diffInHours;
      timeUnit = 'hour';
    } else if (diffInHours >= 24 && diffInHours < 24 * 7) {
      timeValue = (diffInHours / 24).floor();
      timeUnit = 'day';
    } else if (diffInHours >= 24 * 7 && diffInHours < 24 * 30) {
      timeValue = (diffInHours / (24 * 7)).floor();
      timeUnit = 'week';
    } else if (diffInHours >= 24 * 30 && diffInHours < 24 * 12 * 30) {
      timeValue = (diffInHours / (24 * 30)).floor();
      timeUnit = 'month';
    } else {
      timeValue = (diffInHours / (24 * 365)).floor();
      timeUnit = 'year';
    }

    timeAgo = timeValue.toString() + ' ' + timeUnit;
    timeAgo += timeValue > 1 ? 's' : '';

    return timeAgo + ' ago';
  }

  static Service? findService(String name) {
    for (var i = 0; i < App.services.length; i++) {
      Service service = App.services[i];
      if (service.name.toLowerCase() == name.toLowerCase()) return service;
    }

    return null;
  }

  static Service? findServiceById(int id) {
    for (var i = 0; i < App.services.length; i++) {
      Service service = App.services[i];
      if (service.id == id) return service;
    }

    return null;
  }

  static bool serviceIsInList(List<Service> services, Service single) {
    for (var i = 0; i < services.length; i++) {
      Service service = services[i];
      if (service.id == single.id) return true;
    }

    return false;
  }

  static String getDayOfMonthSuffix(int dayNum) {
    if (!(dayNum >= 1 && dayNum <= 31)) {
      throw Exception('Invalid day of month');
    }

    if (dayNum >= 11 && dayNum <= 13) {
      return 'th';
    }

    switch (dayNum % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  static String ageFromDob(String dob) {
    var today = DateTime.now();
    DateTime dobDate = DateTime.parse(dob);

    int totalDays = today.difference(dobDate).inDays;
    int years = totalDays ~/ 365;
    int months = (totalDays - years * 365) ~/ 30;
    int days = totalDays - years * 365 - months * 30;

    String rtn = '';
    if (years > 0) rtn += "$years yrs";
    if (years > 0 && months > 0) {
      rtn += " $months mths";
    } else if (months > 0) {
      rtn += "$months mths";
    }

    if (years > 0 || months > 0) return rtn;

    if ((years > 0 && days > 0) ||
        (years > 0 && months > 0 && days > 0) ||
        (months > 0 && days > 0)) {
      rtn += " $days days";
    } else if (days > 0) {
      rtn += "$days days";
    }

    return rtn;
  }

  static List<dynamic> getJsonWorkHours() => App.currentUser.workHours
      .map<dynamic>((p) => {'day': p.day, 'from': p.from, 'to': p.to})
      .toList();

  static String convertToTitleCase(String text) {
    if (text.length <= 1) {
      return text.toUpperCase();
    }

    // Split string into multiple words
    final List<String> words = text.split(' ');

    // Capitalize first letter of each words
    final capitalizedWords = words.map((word) {
      if (word.trim().isNotEmpty) {
        final String firstLetter = word.trim().substring(0, 1).toUpperCase();
        final String remainingLetters = word.trim().substring(1);

        return '$firstLetter$remainingLetters';
      }
      return '';
    });

    // Join/Merge all words back to one String
    return capitalizedWords.join(' ');
  }

  static String getServiceListForBooking(Booking booking) {
    String services = booking.primaryService.name;

    if (booking.secondaryServices.length > 0) {
      services +=
          ', ' + booking.secondaryServices.map((e) => e.name).join(', ');

      if (booking.addOnService != null) {
        services += ', ' + booking.addOnService!.name;
      }
    } else {
      if (booking.addOnService != null) {
        services += booking.addOnService!.name;
      }
    }

    return services;
  }

  static List<int> getServiceIdsListForBooking(Booking booking) {
    List<int> services = <int>[];
    services.add(booking.primaryService.id);

    if (booking.secondaryServices.length > 0) {
      booking.secondaryServices.forEach((element) {
        services.add(element.id);
      });
    }

    return services;
  }

  static List<DoctorProfile> searchDoctors(
      List<DoctorProfile> doctorList, DoctorSearch search) {
    List<DoctorProfile> resultDoctors = <DoctorProfile>[];

    doctorList.forEach((doctor) {
      bool genderMatch = false;
      bool serviceMatch = false;
      bool ratingMatch = false;
      bool radiusMatch = false;

      if (search.gender == Gender.all) genderMatch = true;
      if (search.gender == Gender.female &&
          doctor.gender!.toLowerCase() == 'female') genderMatch = true;
      if (search.gender == Gender.male &&
          doctor.gender!.toLowerCase() == 'male') genderMatch = true;
      if (search.gender == Gender.other &&
          doctor.gender!.toLowerCase() == 'other') genderMatch = true;

      if (search.rating == Rating.all) ratingMatch = true;
      if (search.rating == Rating.threeStarsPlus && doctor.rating > 3)
        ratingMatch = true;
      if (search.rating == Rating.fourStarsPlus && doctor.rating > 4)
        ratingMatch = true;

      if (search.serviceIds.length > 0) {
        List<int> serviceIds =
            doctor.services.map((service) => service.id).toList();

        serviceMatch = search.serviceIds.any((id) => serviceIds.contains(id));
      } else {
        serviceMatch = true;
      }

      if (search.location != null) {
        if (doctor.savedAddress == null ||
            doctor.savedAddress!.lat.isEmpty ||
            doctor.savedAddress!.lng.isEmpty ||
            doctor.operationRadius == null) {
          radiusMatch = false;
        } else {
          double distance = Utilities.getLocationDistanceKm(
              LatLng(double.parse(doctor.savedAddress!.lat),
                  double.parse(doctor.savedAddress!.lng)),
              search.location!);

          radiusMatch =
              distance <= double.parse(doctor.operationRadius!.toString()) + 5;
        }
      } else {
        radiusMatch = true;
      }

      if (serviceMatch && genderMatch && ratingMatch && radiusMatch)
        resultDoctors.add(doctor);
    });

    return resultDoctors;
  }

  static List<Service> getPrimaryServices() {
    List<Service> services = <Service>[];
    App.services.forEach((element) {
      if (element.isPrimary) services.add(element);
    });

    return services;
  }

  static Booking? getBookingById(int id) {
    for (Booking booking in App.doctorBookings) {
      if (booking.id == id) return booking;
    }
  }

  static Booking? getBookingByStatus(String status) {
    for (Booking booking in App.doctorBookings) {
      if (booking.status.toLowerCase() == status.toLowerCase()) return booking;
    }
  }

  static String getTimeLapseBooking(Booking booking) {
    String rtn = '';

    if (booking.selectedDate.year == DateTime.now().year &&
        booking.selectedDate.month == DateTime.now().month &&
        booking.selectedDate.day == DateTime.now().day) {
      rtn += 'Today, ';
    } else if (booking.selectedDate.year == DateTime.now().year &&
        booking.selectedDate.month == DateTime.now().month &&
        booking.selectedDate.day == DateTime.now().day + 1) {
      rtn += 'Tomorrow, ';
    } else if (booking.selectedDate.year == DateTime.now().year &&
        booking.selectedDate.month == DateTime.now().month &&
        booking.selectedDate.day == DateTime.now().day - 1) {
      rtn += 'Yesterday, ';
    } else {
      rtn += DateFormat.yMMMd().format(booking.selectedDate) + ', ';
    }

    rtn += (booking.startTime != null)
        ? booking.startTime! + ' - ' + booking.endTime!
        : 'ASAP';

    return rtn;
  }

  static String getAllBookingReason(Booking booking) {
    String rtn = '';

    if (booking.bookingReason!.isGeneralCheckUp) rtn += 'General Checkup';
    if (booking.bookingReason!.symptoms.length > 0)
      rtn += booking.bookingReason!.symptoms.join(', ');
    if (booking.bookingReason!.otherReasons.isNotEmpty)
      rtn += ', ' + booking.bookingReason!.otherReasons;

    return rtn;
  }

  static String getAllBookingAlerts(Booking booking) {
    List<String> rtn = <String>[];
    if (booking.bookingReason!.isCovidPositive) rtn.add('COVID-19 positive');
    if (booking.bookingReason!.suspectsCovidPositive)
      rtn.add('Suspected COVID-19 positive');
    if (booking.bookingReason!.patientCovidContact)
      rtn.add('In contact with COVID-19 positive person');

    return rtn.join(', ');
  }

  static Future<LatLng?> getUserLocation() async {
    final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
    final hasPermission = await handleGeoPermissions();

    if (!hasPermission) {
      return null;
    }

    final position = await _geolocatorPlatform.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );

    App.currentLocation = LatLng(position.latitude, position.longitude);
    return App.currentLocation;
  }

  static Future<bool> handleGeoPermissions() async {
    final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static String getLocationDistance(LatLng locationA, LatLng locationB) {
    double distance = Geolocator.distanceBetween(locationA.latitude,
        locationA.longitude, locationB.latitude, locationB.longitude);
    String distanceStr = '';

    if (distance < 100) {
      return 'Arrived';
    }

    if (distance >= 1000) {
      distanceStr = (distance / 1000).toStringAsFixed(2) + ' km';
    } else {
      distanceStr = distance.toStringAsFixed(2) + ' m';
    }

    return distanceStr;
  }

  static double getLocationDistanceKm(LatLng locationA, LatLng locationB) {
    double distance = Geolocator.distanceBetween(locationA.latitude,
        locationA.longitude, locationB.latitude, locationB.longitude);

    return double.parse((distance / 1000).toStringAsFixed(4));
  }

  static Future<void> openMap(Booking booking) async {
    MapsLauncher.launchCoordinates(
      double.parse(booking.latitude),
      double.parse(booking.longitude),
      "${booking.patient!.firstName} + ${booking.patient!.lastName}",
    );
  }

  static bool bookingCanBeCancelled(Booking booking) {
    if (booking.status.toLowerCase() == 'cancelled' ||
        booking.status.toLowerCase() == 'declined' ||
        booking.status.toLowerCase() == 'complete' ||
        booking.status.toLowerCase() == 'en-route') return false;

    if (booking.selectedDoctor == null) {
      return true;
    }

    if (App.activeApp != ActiveApp.DOCTOR) {
      DateTime now = DateTime.now();
      DateTime startTime = DateTime.parse(
          "${booking.selectedDate.year}-${booking.selectedDate.month.toString().padLeft(2, '0')}-${booking.selectedDate.day.toString().padLeft(2, '0')} ${Utilities.paddedTime(booking.startTime != null ? booking.startTime! : now.hour.toString().padLeft(2, '0') + ':' + now.minute.toString().padLeft(2, '0'))}");

      if (startTime.difference(now).inHours >= 1) {
        return true;
      } else {
        if (booking.status.toLowerCase() == 'pending') return true;
        return false;
      }
    }

    return true;
  }

  static int getAppointmentMinutesFromNow(Booking booking) {
    if (booking.selectedDoctor == null) return -1;

    DateTime now = DateTime.now();
    DateTime startTime = DateTime.parse(
        "${booking.selectedDate.year}-${booking.selectedDate.month.toString().padLeft(2, '0')}-${booking.selectedDate.day.toString().padLeft(2, '0')} ${Utilities.paddedTime(booking.startTime!)}");
    return startTime.difference(now).inMinutes;
  }

  static bool canStartTravelling(Booking booking) {
    if (booking.selectedDoctor == null) return false;

    DateTime now = DateTime.now();
    DateTime startTime = DateTime.parse(
        "${booking.selectedDate.year}-${booking.selectedDate.month.toString().padLeft(2, '0')}-${booking.selectedDate.day.toString().padLeft(2, '0')} ${Utilities.paddedTime(booking.endTime!)}");
    var time = startTime.difference(now).inMinutes;
    return time > 0 && time <= 190; // 1h 30m
  }

  static Future<Booking> checkAndUpdateStatus(Booking booking) async {
    DateTime now = DateTime.now();
    DateTime startTime = DateTime.parse(
        "${booking.selectedDate.year}-${booking.selectedDate.month.toString().padLeft(2, '0')}-${booking.selectedDate.day.toString().padLeft(2, '0')} ${booking.startTime != null ? Utilities.paddedTime(booking.startTime!) : now.hour + now.minute}");

    if (startTime.difference(now).inMilliseconds < 1) {
      ApiProvider _provider = new ApiProvider();
      booking.status = "Cancelled";
      await _provider.updateDoctorBookingStatus(
          {'bookingId': booking.id, 'status': 'cancelled'});
    }

    return booking;
  }

  static String paddedTime(String time) {
    var hour = time.split(':')[0];
    if (int.parse(hour) <= 9 && hour.substring(0, 1) != "0")
      return "0$hour:${time.split(':')[1]}"
          .replaceAll(' AM', '')
          .replaceAll(' PM', '');

    return time.replaceAll(' AM', '').replaceAll(' PM', '');
  }

  static Future<String> getAddressString(LatLng location) async {
    var details = await PlaceApiProvider(UniqueKey()).fetchAddress(
        location.latitude.toString(), location.longitude.toString());

    String rtn = details!.description.replaceAll(', Zimbabwe', '');

    if (rtn.contains(RegExp(r'[a-zA-Z0-9][+][a-zA-Z0-9]'))) {
      return "Unnamed Road, " + rtn.replaceAll(rtn.split(' ')[0], '').trim();
    } else {
      return rtn;
    }
  }

  static String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static String uuid() {
    final rawNonce = generateNonce();
    return sha256ofString(rawNonce);
  }
}
