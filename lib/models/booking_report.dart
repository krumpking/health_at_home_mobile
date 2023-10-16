class BookingReport {
  int bookingId = 0;
  String checks = '';
  bool paidInFull = true;
  String symptoms = '';
  String otherSymptoms = '';
  String physicalExam = '';
  String chronicConditions = '';
  String familyHistory = '';
  String diagnosis = '';
  String doctorPlan = '';
  bool requestReview = false;
  DateTime? nextReviewDate;
  String reviewDate = '';
  String reviewTime = '';
  String supplies = '';
  int personalEffortRating = 0;
  int medicalEffortRating = 0;
  String privateMessage = '';

  BookingReport.init();

  BookingReport.fromJson(data) {
    bookingId = data['bookingId'];
    checks = data['checks'] != null ? data['checks'] : '';
    paidInFull = data['paidInFull'] == 1 ? true : false;
    symptoms = data['symptoms'] != null ? data['symptoms'] : '';
    otherSymptoms = data['otherSymptoms'] != null ? data['otherSymptoms'] : '';
    physicalExam = data['physicalExam'] != null ? data['physicalExam'] : '';
    chronicConditions =
        data['chronicConditions'] != null ? data['chronicConditions'] : '';
    familyHistory = data['familyHistory'] != null ? data['familyHistory'] : '';
    diagnosis = data['diagnosis'] != null ? data['diagnosis'] : '';
    doctorPlan = data['doctorPlan'] != null ? data['doctorPlan'] : '';
    requestReview = data['requestReview'] == 1 ? true : false;
    nextReviewDate = data['nextReviewDate'] != null
        ? DateTime.parse(data['nextReviewDate'])
        : null;
    supplies = data['supplies'] != null ? data['supplies'] : '';
    personalEffortRating =
        data['personalEffortRating'] != null ? data['personalEffortRating'] : 0;
    medicalEffortRating =
        data['medicalEffortRating'] != null ? data['medicalEffortRating'] : 0;
    privateMessage =
        data['privateMessage'] != null ? data['privateMessage'] : '';
  }

  Map<String, dynamic> toJson() => {
        'bookingId': bookingId,
        'checks': checks,
        'paidInFull': paidInFull,
        'symptoms': symptoms,
        'otherSymptoms': otherSymptoms,
        'physicalExam': physicalExam,
        'chronicConditions': chronicConditions,
        'familyHistory': familyHistory,
        'diagnosis': diagnosis,
        'doctorPlan': doctorPlan,
        'requestReview': requestReview,
        'nextReviewDate': nextReviewDate != null
            ? "${nextReviewDate!.year}-${nextReviewDate!.month}-${nextReviewDate!.day}"
            : null,
        'supplies': supplies,
        'personalEffortRating': personalEffortRating,
        'medicalEffortRating': medicalEffortRating,
        'privateMessage': privateMessage,
      };
}
