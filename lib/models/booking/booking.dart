import 'package:mobile/config/app.dart';
import 'package:mobile/models/appointment/payment.dart';
import 'package:mobile/models/booking/reason.dart';
import 'package:mobile/models/booking_report.dart';
import 'package:mobile/models/service.dart';
import 'package:mobile/models/user/dependent.dart';
import 'package:mobile/models/user/doctorProfile.dart';
import 'package:mobile/models/user/patientProfile.dart';

import '../patient_report.dart';

class Booking {
  late int id;
  late int? parentBookingId;
  late BookingFor bookingFor;
  late BookingCriteria bookingCriteria;
  late Service primaryService;
  late Service? addOnService;
  late String status;
  late List<Service> secondaryServices = <Service>[];
  late double totalPrice = 0;
  late String address = '';
  late String unitNumber = '';
  late String addressNotes = '';
  late String diagnosis = '';
  late String doctorPlan = '';
  late DateTime? reviewDate;
  late bool reviewRequested;
  late bool isReview = false;
  late bool isRebook = false;
  late bool isEmergency = false;
  late bool reportComplete = false;
  late String latitude;
  late String longitude;
  late DoctorProfile? selectedDoctor = DoctorProfile.init();
  late String? startTime = '';
  late String? endTime = '';
  late DateTime selectedDate = DateTime.now();
  late BookingReason? bookingReason = BookingReason.init();
  late Dependent? dependent;
  late PatientProfile? patient = PatientProfile.init();
  late BookingFlow? bookingFlow;
  late BookingReport? report;
  late PatientReport? patientReport;
  late List<Booking> previousBookings = <Booking>[];
  late String paymentStatus = 'Pending';
  late Payment? payment;

  Booking.init() {
    addOnService = null;
    id = 0;
  }

  Booking.fromJson(data) {
    if (data.containsKey('id')) id = data['id'];
    if (data.containsKey('parentBookingId'))
      parentBookingId = data['parentBookingId'];
    if (data.containsKey('for'))
      bookingFor = data['for'] == 1 ? BookingFor.SELF : BookingFor.SOMEONE;
    if (data.containsKey('primaryService'))
      primaryService = Service.fromJson(data['primaryService']);
    if (data.containsKey('addOnService'))
      addOnService = data['addOnService'] != null
          ? Service.fromJson(data['addOnService'])
          : null;
    if (data.containsKey('totalPrice'))
      totalPrice = double.parse(data['totalPrice'].toString());
    if (data.containsKey('address')) address = data['address'];
    if (data.containsKey('unitNumber'))
      unitNumber = data['unitNumber'] != null ? data['unitNumber'] : '';
    if (data.containsKey('addressNotes'))
      addressNotes = data['addressNotes'] == null ? '' : data['addressNotes'];
    if (data.containsKey('latitude')) latitude = data['latitude'];
    if (data.containsKey('longitude')) longitude = data['longitude'];
    if (data.containsKey('status')) status = data['status'];
    if (data.containsKey('reviewDate'))
      reviewDate = data['reviewDate'] != null
          ? DateTime.parse(data['reviewDate'])
          : null;
    if (data.containsKey('diagnosis'))
      diagnosis = data['diagnosis'] == null ? '' : data['diagnosis'];
    if (data.containsKey('doctorPlan'))
      doctorPlan = data['doctorPlan'] == null ? '' : data['doctorPlan'];
    if (data.containsKey('reviewRequested'))
      reviewRequested = data['reviewRequested'] == 1 ? true : false;
    if (data.containsKey('isReview'))
      isReview = data['isReview'] == 1 ? true : false;
    if (data.containsKey('isEmergency'))
      isEmergency = data['isEmergency'] == 1 ? true : false;
    if (data.containsKey('reportComplete'))
      reportComplete = data['reportComplete'] == 1 ? true : false;
    if (data.containsKey('paymentStatus'))
      paymentStatus = data['paymentStatus'];
    if (data.containsKey('doctor')) {
      selectedDoctor = DoctorProfile.fromJson(data['doctor']);
    } else {
      selectedDoctor = null;
    }
    if (data.containsKey('report') && data['report'] != null) {
      report = BookingReport.fromJson(data['report']);
    } else {
      report = null;
    }
    if (data.containsKey('patientReport') && data['patientReport'] != null) {
      patientReport = PatientReport.fromJson(data['patientReport']);
    } else {
      patientReport = null;
    }
    if (data.containsKey('dependent'))
      dependent = Dependent.fromJson(data['dependent']);
    if (data.containsKey('payment') && data['payment'] != null) {
      payment = Payment.fromJson(data['payment']);
    } else {
      payment = null;
    }
    if (data.containsKey('startTime')) startTime = data['startTime'];
    if (data.containsKey('endTime')) endTime = data['endTime'];
    if (data.containsKey('date')) selectedDate = DateTime.parse(data['date']);
    if (data.containsKey('reason'))
      bookingReason = BookingReason.fromJson(data['reason']);
    if (data.containsKey('patient'))
      patient = PatientProfile.fromJson(data['patient']);

    if (data.containsKey('additionalServices') &&
        data['additionalServices'] != null) {
      List<dynamic> additional = data['additionalServices'];
      additional.forEach((element) {
        secondaryServices.add(Service.fromJson(element));
      });
    }

    if (data.containsKey('previousBookings') &&
        data['previousBookings'] != null) {
      List<dynamic> previous = data['previousBookings'];
      previous.forEach((element) {
          previousBookings.add(Booking.fromJson(element));
      });
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'isRebook': isRebook,
        'patientProfileId': App.currentUser.patientProfile!.id,
        'selectedDoctorId': selectedDoctor != null ? selectedDoctor!.id : 0,
        'primaryServiceId': primaryService.id,
        'addOnServiceId': addOnService != null ? addOnService!.id : null,
        'for': bookingFor == BookingFor.SELF ? 1 : 2,
        "totalPrice": totalPrice,
        "address": address,
        "unitNumber": unitNumber,
        "addressNotes": addressNotes,
        "latitude": latitude,
        "longitude": longitude,
        "isReview": isReview,
        "isEmergency": isEmergency,
        'date':
            "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
        'startTime': startTime,
        'reason': bookingReason!.toJson(),
        'dependentId': dependent != null && dependent!.firstName.isNotEmpty
            ? dependent!.id
            : null,
        'additionalServices': secondaryServices.map<int>((p) {
          Service service = p;
          return service.id;
        }).toList()
      };
}

enum BookingFor { SELF, SOMEONE }

enum BookingCriteria { SELECT_PROVIDERS, ASAP }

enum BookingFlow { HOME_PLUS, HOME_SERVICE, PRIMARY_SERVICE }
