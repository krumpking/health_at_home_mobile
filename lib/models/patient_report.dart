class PatientReport {
  int bookingId = 0;
  double rating = 0;
  String timeKeeping = 'ON TIME';
  String patience = 'PATIENT';
  String professionalism = 'PROFESSIONAL';
  String presentable = 'WELL-PRESENTED';
  String informative = 'INFORMATIVE';
  String privateMessage = '';
  String checks = '';
  String doctorName = '';

  PatientReport.init();

  PatientReport.fromJson(data) {
    bookingId = data['bookingId'];
    rating = data['rating'] != null ? double.parse(data['rating'].toString()) : 0;
    checks = data['checks'] != null ? data['checks'] : '';
    timeKeeping = data['timeKeeping'] != null ? data['timeKeeping'] : '';
    patience = data['patience'] != null ? data['patience'] : '';
    professionalism = data['professionalism'] != null ? data['professionalism'] : '';
    presentable = data['presentable'] != null ? data['presentable'] : '';
    informative = data['informative'] != null ? data['informative'] : '';
    privateMessage = data['privateMessage'] != null ? data['privateMessage'] : '';
  }

  Map<String, dynamic> toJson() => {
        'bookingId': bookingId,
        'rating': rating,
        'checks': checks,
        'timeKeeping': timeKeeping,
        'patience': patience,
        'professionalism': professionalism,
        'presentable': presentable,
        'informative': informative,
        'privateMessage': privateMessage,
      };
}
