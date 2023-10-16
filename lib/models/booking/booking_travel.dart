class BookingTravel {
  int bookingId;
  String fromLat;
  String fromLng;
  String toLat;
  String toLng;

  BookingTravel(
      this.bookingId, this.fromLat, this.fromLng, this.toLat, this.toLng);

  static BookingTravel? fromJson(data) {
    if (data.containsKey('bookingId') &&
        data.containsKey('fromLat') &&
        data.containsKey('fromLng') &&
        data.containsKey('toLat') &&
        data.containsKey('toLng')) {
      return BookingTravel(data['bookingId'], data['fromLat'], data['fromLng'],
          data['toLat'], data['toLng']);
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        'bookingId': bookingId,
        'fromLat': fromLat,
        'fromLng': fromLng,
        'toLat': toLat,
        'toLng': toLng,
      };
}
