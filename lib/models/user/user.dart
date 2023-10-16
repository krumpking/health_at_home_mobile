import 'package:mobile/models/user/patientProfile.dart';
import 'package:mobile/models/user/workHour.dart';

import 'doctorProfile.dart';

class User {
  late int id;
  late String uuid;
  late UserTypes userType = UserTypes.PATIENT;
  late String firstName;
  late String lastName;
  late bool isActive = false;
  late String email;
  late String phone;
  late bool termsAccepted;
  late bool hasPasscode;
  late bool marketingAccepted;
  late DateTime createdAt;
  late DateTime updatedAt;
  late DoctorProfile? doctorProfile = DoctorProfile.init();
  late PatientProfile? patientProfile = PatientProfile.init();
  late String passcode;
  late List<WorkHour> workHours = <WorkHour>[];

  static User fromJson(userData) {
    User user = new User();

    if (userData.containsKey('id')) user.id = userData['id'];
    if (userData.containsKey('uuid')) user.uuid = userData['uuid'];
    if (userData.containsKey('userType'))
      user.userType = (userData['userType'] == 'doctor'
          ? UserTypes.DOCTOR
          : (userData['userType'] == 'patient')
              ? UserTypes.PATIENT
              : UserTypes.NONE);
    if (userData.containsKey('firstName'))
      user.firstName = userData['firstName'];
    if (userData.containsKey('lastName')) user.lastName = userData['lastName'];
    if (userData.containsKey('isActive'))
      user.isActive = (userData['isActive'] == 1) ? true : false;
    if (userData.containsKey('email')) user.email = userData['email'];
    if (userData.containsKey('phone')) user.phone = userData['phone'];
    if (userData.containsKey('termsAccepted'))
      user.termsAccepted = (userData['termsAccepted'] == 1) ? true : false;
    if (userData.containsKey('hasPasscode'))
      user.hasPasscode = (userData['hasPasscode'] == 1) ? true : false;
    if (userData.containsKey('marketingAccepted'))
      user.marketingAccepted =
          (userData['marketingAccepted'] == 1) ? true : false;
    if (userData.containsKey('createdAt'))
      user.createdAt = DateTime.parse(userData['createdAt']);
    if (userData.containsKey('updatedAt'))
      user.updatedAt = DateTime.parse(userData['updatedAt']);

    if (userData.containsKey('doctorProfile'))
      user.doctorProfile = DoctorProfile.fromJson(userData['doctorProfile']);
    if (userData.containsKey('patientProfile'))
      user.patientProfile = PatientProfile.fromJson(userData['patientProfile']);
    if (userData.containsKey('workHours'))
      user.workHours = userData['workHours']
          .map<WorkHour>((p) => WorkHour(p['day'], p['from'], p['to']))
          .toList();

    return user;
  }

  static bool isAuthentic(User user) {
    try {
      if (user.firstName.isEmpty || user.lastName.isEmpty) {
        return false;
      }
    } catch (e) {
      return false;
    }
    return true;
  }
}

enum UserTypes { DOCTOR, PATIENT, NONE }
