import 'package:mobile/models/user/subscriptionPackage.dart';

class Subscription {
  late int id;
  late DateTime expiresOn;
  late SubscriptionPackage package;
  late int remainingVisits;
  bool paymentDue = false;

  Subscription.fromJson(data) {
    if (data.containsKey('id')) id = data['id'];
    if (data.containsKey('expiresOn'))
      expiresOn = DateTime.parse(data['expiresOn']);
    if (data.containsKey('package')) {
      package = SubscriptionPackage.fromJson(data['package']);
    }
    if (data.containsKey('paymentDue')) paymentDue = data['paymentDue'];
    if (data.containsKey('remainingVisits'))
      remainingVisits = data['remainingVisits'];
  }
}
