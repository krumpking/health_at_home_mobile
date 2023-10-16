class SavedAddress {
  late int id;
  late String address = '';
  late String unit = '';
  late String notes = '';
  late String lat = '';
  late String lng = '';
  late int doctorProfileId = 0;
  late int patientProfileId = 0;

  SavedAddress.init();

  SavedAddress.fromJson(Map data) {
    id = data['id'];
    address = data['address'];
    unit = data['unit'] == null ? '' : data['unit'];
    notes = data['notes'] == null ? '' : data['notes'];
    lat = data['lat'];
    lng = data['lng'];
  }

  Map<String, dynamic> toJson() => {
        'doctorProfileId': doctorProfileId,
        'patientProfileId': patientProfileId,
        'address': address,
        'unit': unit,
        'notes': notes,
        'lat': lat,
        'lng': lng,
      };
}
