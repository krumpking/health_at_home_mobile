import 'package:mobile/models/user/subscription.dart';

class Dependent {
  late int? id;
  late int patientProfileId;
  late String firstName = '';
  late String lastName = '';
  late String gender;
  late String dob;
  late String relationship;
  late bool isOnMedicalPlan = false;
  late bool isSelf = false;
  late Subscription? subscription;

  Dependent.init();

  Dependent.fromJson(data) {
    if (data.containsKey('id')) id = data['id'];
    if (data.containsKey('patientProfileId'))
      patientProfileId = data['patientProfileId'];
    if (data.containsKey('firstName')) firstName = data['firstName'];
    if (data.containsKey('lastName')) lastName = data['lastName'];
    if (data.containsKey('gender')) gender = data['gender'];
    if (data.containsKey('dob')) dob = data['dob'];
    if (data.containsKey('relationship')) relationship = data['relationship'];
    if (data.containsKey('isOnMedicalPlan'))
      isOnMedicalPlan = data['isOnMedicalPlan'] == 1;
    if (data.containsKey('isSelf')) isSelf = data['isSelf'] == 1;
    if (data.containsKey('subscription') && data['subscription'] != null) {
      subscription = Subscription.fromJson(data['subscription']);
    } else {
      subscription = null;
    }
  }

  hasSubscription<bool>() {
    return this.subscription != null;
  }

  isSubscriptionValid<bool>() {
    return this.hasSubscription() &&
        DateTime.now().compareTo(this.subscription!.expiresOn) < 0;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender.toLowerCase() == 'female'
            ? 1
            : (gender.toLowerCase() == 'male' ? 2 : 3),
        'dob': dob,
        'relationship': relationship
      };

  Map<String, dynamic> toJsonCreate() => {
        'patientProfileId': patientProfileId,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender.toLowerCase() == 'female'
            ? 1
            : (gender.toLowerCase() == 'male' ? 2 : 3),
        'dob': dob,
        'relationship': relationship
      };
}
