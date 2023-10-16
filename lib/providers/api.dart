import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/app_setting.dart';
import 'package:mobile/models/appointment/payment.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/models/booking/booking_travel.dart';
import 'package:mobile/models/booking_notification.dart';
import 'package:mobile/models/booking_report.dart';
import 'package:mobile/models/language.dart';
import 'package:mobile/models/patient_report.dart';
import 'package:mobile/models/saved_address.dart';
import 'package:mobile/models/service.dart';
import 'package:mobile/models/specialisation.dart';
import 'package:mobile/models/user/dependent.dart';
import 'package:mobile/models/user/doctorProfile.dart';
import 'package:mobile/models/user/subscription.dart';
import 'package:mobile/models/user/subscriptionPackage.dart';
import 'package:mobile/models/user/user.dart';
import 'package:mobile/providers/utilities.dart';

import 'api_response.dart';

class ApiProvider extends ChangeNotifier {
  static const HOST = "https://admin.healthathome.co.zw/api";
  //static const HOST = "https://health.abstrak.agency/api"; // prod
  //static const HOST = "http://192.168.0.13:8000/api"; // stg
  http.Client client = http.Client();
  final _storage = FlutterSecureStorage();
  var headers;

  _getDataList(key) async {
    ApiResponse.status = Status.LOADING;
    try {
      final response = await client.get(
        Uri.parse("$HOST/$key"),
        headers: headers,
      );

      return ApiResponse.handleApiResponse(response);
    } on TimeoutException catch (_) {
      ApiResponse.message = "Connection timed out";
    } on SocketException catch (_) {
      ApiResponse.message = "Connection to server failed";
    }

    return;
  }

  _postDataList(key, data) async {
    ApiResponse.status = Status.LOADING;
    try {
      final http.Response response = await client.post(
        Uri.parse("$HOST/$key"),
        headers: headers,
        body: jsonEncode(data),
      );
      print(response);
      return ApiResponse.handleApiResponse(response);
    } on TimeoutException catch (_) {
      ApiResponse.message = "connection timed out";
    } on SocketException catch (_) {
      ApiResponse.message = "Please check if you have internet access.";
    }

    return;
  }

  Future<bool> login(String email, String password) async {
    setHeaders();
    final data = await _postDataList('auth/login', {
      'email': email,
      'password': password,
      "deviceKey": App.deviceKey ?? await FirebaseMessaging.instance.getToken()
    });

    var log = Logger();
    log.wtf(data);
    if (ApiResponse.status == Status.COMPLETED) {
      final User user = User.fromJson(data['user']);

      final String token = data['token'];
      if (token.isNotEmpty) {
        if (!user.isActive) {
          App.signUpUser?.email = user.email;
          App.signUpUser?.firstName = user.firstName;
          App.signUpUser?.lastName = user.lastName;
          App.signUpUser?.uuid = user.uuid;
          App.signUpUser!.purpose = 1;

          return true;
        }

        App.currentUser = user;
        App.isLoggedIn = true;
        App.isLocked = false;
        _storage.write(key: 'currentUser', value: jsonEncode(data['user']));
        _storage.write(key: 'accessToken', value: data['token']);

        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  Future<bool> loginWithUUID(String uuid) async {
    setHeaders();
    final data = await _postDataList(
        'auth/login/uuid', {'uuid': uuid, "deviceKey": App.deviceKey});
    if (ApiResponse.status == Status.COMPLETED) {
      final User user = User.fromJson(data['user']);
      final String token = data['token'];
      if (token.isNotEmpty) {
        App.currentUser = user;
        App.isLoggedIn = true;
        App.isLocked = false;
        _storage.write(key: 'currentUser', value: jsonEncode(data['user']));
        _storage.write(key: 'accessToken', value: data['token']);

        return true;
      }
    }

    return false;
  }

  Future<bool> loginWithSocial(
      String email, String firstName, String lastName) async {
    setHeaders();
    final data = await _postDataList('auth/login/social', {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      "deviceKey": App.deviceKey
    });
    if (ApiResponse.status == Status.COMPLETED) {
      final User user = User.fromJson(data['user']);
      final String token = data['token'];
      if (token.isNotEmpty) {
        App.currentUser = user;
        App.isLoggedIn = true;
        App.isLocked = false;
        _storage.write(key: 'currentUser', value: jsonEncode(data['user']));
        _storage.write(key: 'accessToken', value: data['token']);

        return true;
      }
    }

    return false;
  }

  Future<String?> resendRegistrationCode(String uuid) async {
    setHeaders();
    var data = await _postDataList('auth/resend-registration-code',
        {'uuid': uuid, "deviceKey": App.deviceKey});
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      if (data['uuid'] != null && data['purpose'] != null) {
        return data['uuid'];
      }
    }
    return null;
  }

  Future<bool> checkEmail(String email) async {
    setHeaders();
    var data = await _postDataList('auth/check-email', {'email': email});
    print(data);
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      return true;
    }

    return false;
  }

  Future<String?> register() async {
    setHeaders();
    print(App.signUpUser!.toJson());
    var data = await _postDataList('auth/register', App.signUpUser!.toJson());
    print(data);
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      if (data['uuid'] != null && data['purpose'] != null) {
        App.signUpUser!.uuid = data['uuid'];
        App.signUpUser!.purpose = data['purpose'];
        return data['uuid'];
      }
    }
    return null;
  }

  Future<String?> forgotPassword(String email) async {
    setHeaders();
    var data = await _postDataList('auth/forgot-password', {'email': email});
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      if (data['uuid'] != null && data['purpose'] != null) {
        App.signUpUser!.uuid = data['uuid'];
        App.signUpUser!.purpose = data['purpose'];
        return data['uuid'];
      }
    }
    return null;
  }

  Future<bool> resetPassword(String password) async {
    setHeaders();
    var data = await _postDataList('auth/reset-password', {
      'uuid': App.signUpUser!.uuid,
      'newPassword': password,
      'passwordConfirmation': password
    });
    return (ApiResponse.status == Status.COMPLETED && data['success'] == true);
  }

  Future<bool> verifyCode(String code, String uuid, int purpose) async {
    setHeaders();
    var data = await _postDataList(
        'auth/verify-code', {'uuid': uuid, 'code': code, 'purpose': purpose});
    return (ApiResponse.status == Status.COMPLETED && data['success'] == true);
  }

  Future<bool> updateDoctorProfile() async {
    setHeaders();
    var data = await _postDataList(
        'doctor/profile/update', App.currentUser.doctorProfile!.toJson());
    await refreshUser();
    return (ApiResponse.status == Status.COMPLETED && data['success'] == true);
  }

  Future<SavedAddress?> getPatientSavedAddress() async {
    setHeaders();
    var data = await _postDataList('patient/get-saved-address',
        {'patientProfileId': App.currentUser.patientProfile!.id});
    await refreshUser();
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      if ((data.containsKey('message')) &&
          data['success'].toString().toLowerCase() == 'address not found') {
        return null;
      } else if ((data.containsKey('result'))) {
        return SavedAddress.fromJson(data['result']);
      }
    }

    return null;
  }

  Future<SavedAddress?> getDoctorSavedAddress() async {
    setHeaders();
    var data = await _postDataList('doctor/get-saved-address',
        {'doctorProfileId': App.currentUser.doctorProfile!.id});
    await refreshUser();
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      if ((data.containsKey('message')) &&
          data['success'].toString().toLowerCase() == 'address not found') {
        return null;
      } else if ((data.containsKey('result'))) {
        return SavedAddress.fromJson(data['result']);
      }
    }

    return null;
  }

  Future<String?> uploadDoctorImage(File image) async {
    setHeaders();
    var data = await _postDataList('doctor/profile/update-image', {
      'doctorProfileId': App.currentUser.doctorProfile!.id,
      'image': 'data:image/' +
          image.path.split('.').last +
          ';base64,' +
          base64Encode(image.readAsBytesSync())
    });
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      final token = Utilities.uuid();
      String path =
          data['result'].toString().replaceAll("\\", '') + '?token=$token';
      App.currentUser.doctorProfile!.profileImg = path;
      await refreshUser();
      return path;
    }
    return null;
  }

  Future<bool> updatePatientProfile() async {
    setHeaders();
    var data = await _postDataList(
        'patient/profile/update', App.currentUser.patientProfile!.toJson());
    await refreshUser();
    return (ApiResponse.status == Status.COMPLETED && data['success'] == true);
  }

  Future<SavedAddress?> createUpdateDoctorAddress() async {
    setHeaders();
    var data = await _postDataList('doctor/address-post',
        App.currentUser.doctorProfile!.savedAddress!.toJson());
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      await refreshUser();
      return App.currentUser.doctorProfile!.savedAddress;
    }
    return null;
  }

  Future<bool> updateDoctorPreferences() async {
    setHeaders();
    var data = await _postDataList('doctor/preferences',
        App.currentUser.doctorProfile!.preferences!.toJson());
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      await refreshUser();
      return true;
    } else {
      return false;
    }
  }

  Future<SavedAddress?> createUpdatePatientAddress() async {
    setHeaders();
    var data = await _postDataList('patient/address-post',
        App.currentUser.patientProfile!.savedAddress!.toJson());
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      await refreshUser();
      return App.currentUser.patientProfile!.savedAddress;
    }
    return null;
  }

  Future<bool> updatePatientPreferences() async {
    setHeaders();
    var data = await _postDataList('patient/preferences',
        App.currentUser.patientProfile!.preferences!.toJson());
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      await refreshUser();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> redeemCode(dynamic payload) async {
    setHeaders();
    var data = await _postDataList('patient/redeem-code', payload);
    return (ApiResponse.status == Status.COMPLETED && data['success'] == true);
  }

  Future<Booking?> createBooking() async {
    setHeaders();
    var data =
        await _postDataList('booking/create', App.progressBooking!.toJson());
    await refreshUser();
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      return Booking.fromJson(data['result']);
    }
    return null;
  }

  Future<BookingTravel?> updateBookingTravel(dynamic) async {
    setHeaders();
    var data = await _postDataList('doctor/update-booking-travel', dynamic);
    if (data != null &&
        ApiResponse.status == Status.COMPLETED &&
        (data.containsKey('success') && data['success'] == true)) {
      return BookingTravel.fromJson(data['result']);
    }

    return null;
  }

  Future<Booking?> getBooking(int bookingId) async {
    setHeaders();
    var data = await _getDataList(
        'app/get-single-booking?bookingId=' + bookingId.toString());
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      return Booking.fromJson(data['result']);
    }
    return null;
  }

  Future<BookingTravel?> getBookingTravel(int bookingId) async {
    setHeaders();
    var data = await _getDataList(
        'app/get-booking-travel?bookingId=' + bookingId.toString());
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      return BookingTravel.fromJson(data['result']);
    }
    return null;
  }

  Future<bool> deleteAccount(int userId) async {
    setHeaders();
    var data = await _postDataList('app/delete-account', {'user_id': userId});
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      return true;
    }

    return false;
  }

  Future<Dependent?> createDependent(Dependent dependent) async {
    setHeaders();
    var data = await _postDataList(
        'patient/create-dependent', dependent.toJsonCreate());
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      return Dependent.fromJson(data['result']);
    }
    return null;
  }

  Future<bool> deleteDependent(int id) async {
    setHeaders();
    var data = await _postDataList('patient/delete-dependent', {'id': id});
    return (ApiResponse.status == Status.COMPLETED && data['success'] == true);
  }

  Future<List<Booking>?> getPatientBookings() async {
    setHeaders();
    var data = await _postDataList('patient/bookings',
        {'patientProfileId': App.currentUser.patientProfile!.id});
    if (ApiResponse.status == Status.COMPLETED) {
      return data['result'].map<Booking>((p) => Booking.fromJson(p)).toList();
    }
    return null;
  }

  Future<AppSetting?> getAppSettings() async {
    setHeaders();
    var data = await _getDataList('app/get-settings');
    if (ApiResponse.status == Status.COMPLETED) {
      return AppSetting.fromJson(data['result']);
    }
    return null;
  }

  Future<List<Booking>?> getDoctorBookings() async {
    setHeaders();
    var data = await _postDataList('doctor/bookings',
        {'doctorProfileId': App.currentUser.doctorProfile!.id});
    if (ApiResponse.status == Status.COMPLETED) {
      List<Booking> bookings =
          data['result'].map<Booking>((p) => Booking.fromJson(p)).toList();
      App.doctorBookings = bookings;
      return bookings;
    }
    return null;
  }

  Future<List<Dependent>?> getDependents() async {
    setHeaders();
    var data = await _postDataList('patient/get-dependents',
        {'patientProfileId': App.currentUser.patientProfile!.id});
    if (ApiResponse.status == Status.COMPLETED) {
      return data['result']
          .map<Dependent>((p) => Dependent.fromJson(p))
          .toList();
    }
    return null;
  }

  Future<List<SubscriptionPackage>?> getAvailablePackages() async {
    setHeaders();
    var data = await _getDataList('subscriptions/get-all-packages');
    if (ApiResponse.status == Status.COMPLETED) {
      return data['result']
          .map<SubscriptionPackage>((p) => SubscriptionPackage.fromJson(p))
          .toList();
    }
    return null;
  }

  Future<List<Dependent>?> getSubscriptionBeneficiaries(
      Subscription subscription) async {
    setHeaders();
    var data = await _postDataList(
        'subscriptions/get-dependencies', {'subscriptionId': subscription.id});
    var logger = new Logger();
    logger.wtf(data);
    if (ApiResponse.status == Status.COMPLETED) {
      return data['result']
          .map<Dependent>((p) => Dependent.fromJson(p))
          .toList();
    }
    return null;
  }

  Future<List<Dependent>?> setSubscriptionBeneficiaries(
      Subscription subscription, List<int> beneficiaries) async {
    setHeaders();
    var data = await _postDataList('subscriptions/set-dependencies', {
      'subscriptionId': subscription.id,
      'dependencies': jsonEncode(beneficiaries)
    });
    var logger = new Logger();
    logger.wtf(data);
    if (ApiResponse.status == Status.COMPLETED) {
      return data['result']
          .map<Dependent>((p) => Dependent.fromJson(p))
          .toList();
    }
    return null;
  }

  Future<Subscription?> subscribe({required int packageId}) async {
    setHeaders();
    var data = await _postDataList('subscriptions/subscribe',
        {'packageId': packageId, 'userId': App.currentUser.id});
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      await refreshUser();
      return Subscription.fromJson(data['result']);
    }
    return null;
  }

  Future<dynamic> checkPaymentStatus(
      {required int paymentId, required String type}) async {
    setHeaders();
    var data = await _postDataList(
        'payment/status', {'paymentId': paymentId, 'type': type});
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      return data['result'];
    }
    return null;
  }

  Future<dynamic> paySubscription({
    required SubscriptionPackage subscriptionPackage,
    required Dependent dependant,
    required int period,
    required String method,
    required bool isRenewal,
  }) async {
    setHeaders();
    var data = await _postDataList('payment/subscription', {
      'packageId': subscriptionPackage.id,
      'dependantId': dependant.id,
      'period': period,
      'method': method,
      'is_renew': isRenewal,
    });
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      await refreshUser();
      return data['result'];
    }
    return null;
  }

  Future<dynamic> unSubscription(
      {required int subscriptionId, required int dependantId}) async {
    setHeaders();
    var data = await _postDataList('subscriptions/un-subscribe',
        {'subscriptionId': subscriptionId, 'dependantId': dependantId});
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      return data['result'];
    }
    return null;
  }

  Future<dynamic> payBooking({
    required int bookingId,
    required String method,
  }) async {
    setHeaders();
    var data = await _postDataList('payment/booking', {
      'bookingId': bookingId,
      'method': method,
    });
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      return data['result'];
    }
    return null;
  }

  Future<Subscription?> getSubscription({required int id}) async {
    setHeaders();
    var data = await _getDataList('subscriptions/$id');
    if (ApiResponse.status == Status.COMPLETED && data['success'] == true) {
      await refreshUser();
      return Subscription.fromJson(data['result']);
    }
    return null;
  }

  Future<List<BookingNotification>?> getNotifications() async {
    setHeaders();
    var data = await _postDataList(
        'app/get-notifications', {'userId': App.currentUser.id});
    if (ApiResponse.status == Status.COMPLETED) {
      return data['result']
          .map<BookingNotification>((p) => BookingNotification.fromJson(p))
          .toList();
    }
    return null;
  }

  Future<Booking?> getActiveTravel() async {
    setHeaders();
    var data = await _postDataList('doctor/get-active-travel',
        {'doctorProfileId': App.currentUser.doctorProfile!.id});
    if (ApiResponse.status == Status.COMPLETED) {
      return Booking.fromJson(data['result']);
    }
    return null;
  }

  Future<bool> openNotification(int id) async {
    setHeaders();
    await _postDataList('app/open-notifications', {'notificationId': id});
    return (ApiResponse.status == Status.COMPLETED);
  }

  Future<bool> updateWorkHours() async {
    setHeaders();
    await _postDataList('doctor/profile/update-work-hours', {
      'doctorProfileId': App.currentUser.doctorProfile!.id,
      'times': Utilities.getJsonWorkHours()
    });
    return (ApiResponse.status == Status.COMPLETED);
  }

  Future<BookingReport?> createReport() async {
    setHeaders();
    var data = await _postDataList(
        'doctor/create-report', App.progressReport.toJson());
    App.progressReport = BookingReport.init();
    if (ApiResponse.status == Status.COMPLETED && data['success']) {
      return BookingReport.fromJson(data['result']);
    }
    return null;
  }

  Future<PatientReport?> createPatientReport() async {
    setHeaders();
    var data = await _postDataList(
        'patient/create-report', App.patientReport.toJson());
    if (ApiResponse.status == Status.COMPLETED && data['success']) {
      return PatientReport.fromJson(data['result']);
    }
    return null;
  }

  Future<List<String>?> getAvailabilities(
      int doctorProfileId, String date) async {
    setHeaders();
    var data = await _postDataList('doctor/availability',
        {"date": date, "doctorProfileId": doctorProfileId});
    if (ApiResponse.status == Status.COMPLETED) {
      return data['result'].map<String>((p) => p.toString()).toList();
    }
    return null;
  }

  Future<bool> updateDoctorBookingStatus(dynamic) async {
    setHeaders();
    var data = await _postDataList('doctor/update-booking-status', dynamic);
    if (ApiResponse.status == Status.COMPLETED) {
      if (data['result'] != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> updatePatientBookingStatus(dynamic) async {
    setHeaders();
    var data = await _postDataList('patient/update-booking-status', dynamic);
    if (ApiResponse.status == Status.COMPLETED) {
      if (data['result'] != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> claimAppointment(dynamic) async {
    setHeaders();
    var data = await _postDataList('doctor/claim-appointment', dynamic);
    if (ApiResponse.status == Status.COMPLETED) {
      if (data['result'] != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<List<DoctorProfile>?> getAllDoctors(dynamic search) async {
    setHeaders();
    search = search == null ? {} : search;
    var data = await _postDataList('doctor/list', search);
    if (ApiResponse.status == Status.COMPLETED) {
      if (data['result'] != null) {
        return data['result']
            .map<DoctorProfile>((p) => DoctorProfile.fromJson(p))
            .toList();
      }
    }
    return null;
  }

  Future<List<Service>?> getServices() async {
    setHeaders();
    final data = await _getDataList('services');
    if (ApiResponse.status == Status.COMPLETED) {
      print("============= SERVICES ===========");
      print(data);
      App.services =
          data['result'].map<Service>((p) => Service.fromJson(p)).toList();
      return App.services;
    }
    return null;
  }

  Future<List<Service>?> getSecondaryServices(int serviceId) async {
    setHeaders();
    final data =
        await _postDataList('additional-services', {'serviceId': serviceId});
    if (ApiResponse.status == Status.COMPLETED) {
      return data['result'].map<Service>((p) => Service.fromJson(p)).toList();
    }
    return null;
  }

  Future refreshUser() async {
    setHeaders();
    final data = await _postDataList('auth/user', {'id': App.currentUser.id});
    var logger = Logger();
    logger.wtf('Here');
    logger.wtf(data);
    if (ApiResponse.status == Status.COMPLETED &&
        (data.containsKey('success') && data['success'] == true)) {
      App.currentUser = User.fromJson(data['result']);
      await _storage.write(
          key: 'currentUser', value: jsonEncode(data['result']));
    }
  }

  Future<List<Language>?> getLanguages() async {
    setHeaders();
    final data = await _getDataList('app/get-languages');
    if (ApiResponse.status == Status.COMPLETED) {
      App.languages =
          data['result'].map<Language>((p) => Language.fromJson(p)).toList();
      return App.languages;
    }
    return null;
  }

  Future<List<Specialisation>?> getSpecialisations() async {
    setHeaders();
    final data = await _getDataList('app/get-specialisations');
    if (ApiResponse.status == Status.COMPLETED) {
      App.specialisations = data['result']
          .map<Specialisation>((p) => Specialisation.fromJson(p))
          .toList();
      return App.specialisations;
    }
    return null;
  }

  setHeaders() {
    headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
}
