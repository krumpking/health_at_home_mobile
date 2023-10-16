import 'package:event/event.dart';
import 'package:mobile/models/booking/booking.dart';

import '../providers/api.dart';

class BookingNotification {
  late int id;
  late String uuid;
  late String title;
  late Booking booking;
  late bool opened;
  late bool isEmergency;
  late DateTime createdAt;
  static var notificationReadEvent = Event();
  static int totalNotifications = 0;

  BookingNotification.fromJson(data) {
    id = data['id'];
    uuid = data['uuid'];
    title = data['title'];
    booking = Booking.fromJson(data['booking']);
    opened = data['opened'] == 1 ? true : false;
    isEmergency = data['isEmergency'] == 1 ? true : false;
    createdAt = DateTime.parse(data['createdAt']);
  }

  static Future<List<BookingNotification>> getNotifications() async {
    ApiProvider _provider = new ApiProvider();
    List<BookingNotification> notifications = [];
    var _notifications = await _provider.getNotifications();
    if (_notifications != null && _notifications.length > 0) {
      notifications = _notifications;
    }
    BookingNotification.totalNotifications = notifications
        .where((element) => element.opened == false)
        .toList()
        .length;
    notificationReadEvent.broadcast();
    return notifications;
  }

  static void markSeen() {
    BookingNotification.getNotifications();
    notificationReadEvent.broadcast();
  }
}
