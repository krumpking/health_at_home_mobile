class BookingReason {
  late bool isGeneralCheckUp = false;
  late List<String> symptoms = <String>[];
  late String otherReasons = '';
  late bool isCovidPositive = false;
  late bool patientCovidContact = false;
  late bool suspectsCovidPositive = false;

  BookingReason.init();

  BookingReason.fromJson(data) {
    if (data.containsKey('isGeneralCheckUp')) isGeneralCheckUp = data['isGeneralCheckUp'] == 1 ? true : false;
    if (data.containsKey('symptoms')) symptoms = data['symptoms'] != null ? data['symptoms'].toString().split(",") : <String>[];
    if (data.containsKey('otherReasons')) otherReasons = data['otherReasons'] != null ? data['otherReasons'] : '';
    if (data.containsKey('isCovidPositive')) isCovidPositive = data['isCovidPositive'] == 1 ? true : false;
    if (data.containsKey('patientCovidContact')) patientCovidContact = data['patientCovidContact'] == 1 ? true : false;
    if (data.containsKey('suspectsCovidPositive')) suspectsCovidPositive = data['suspectsCovidPositive'] == 1 ? true : false;
  }

  Map<String, dynamic> toJson() => {
        'isGeneralCheckUp': isGeneralCheckUp,
        'symptoms': symptoms.join(','),
        'otherReasons': otherReasons,
        'isCovidPositive': isCovidPositive,
        'patientCovidContact': patientCovidContact,
        'suspectsCovidPositive': suspectsCovidPositive
      };
}
