class PatientPreferences {
  late int patientProfileId;
  late bool emailReminders;
  late bool emailAppointmentRequests;
  late bool emailNewFeatures;
  late bool emailMarketing;
  late bool emailReceipts;
  late bool smsReminderAppointmentReports;
  late bool visitStatusUpdates;
  late bool pushNotificationsReminder;
  late bool pushNotificationsVisitUpdateStatus;

  PatientPreferences.fromJson(Map data) {
    patientProfileId = data['patientProfileId'];
    emailReminders = data['emailReminders'] == 1 ? true : false;
    emailAppointmentRequests = data['emailAppointmentRequests'] == 1 ? true : false;
    emailNewFeatures = data['emailNewFeatures'] == 1 ? true : false;
    emailMarketing = data['emailMarketing'] == 1 ? true : false;
    emailReceipts = data['emailReceipts'] == 1 ? true : false;
    smsReminderAppointmentReports = data['smsReminderAppointmentReports'] == 1 ? true : false;
    visitStatusUpdates = data['visitStatusUpdates'] == 1 ? true : false;
    pushNotificationsReminder = data['pushNotificationsReminder'] == 1 ? true : false;
    pushNotificationsVisitUpdateStatus = data['pushNotificationsVisitUpdateStatus'] == 1 ? true : false;
  }

  Map<String, dynamic> toJson() => {
        'patientProfileId': patientProfileId,
        'emailAppointmentRequests': emailAppointmentRequests,
        'emailNewFeatures': emailNewFeatures,
        'emailMarketing': emailMarketing,
        'emailReceipts': emailReceipts,
        'smsReminderAppointmentReports': smsReminderAppointmentReports,
        'visitStatusUpdates': visitStatusUpdates,
        'pushNotificationsReminder': pushNotificationsReminder,
        'pushNotificationsVisitUpdateStatus': pushNotificationsVisitUpdateStatus,
      };
}

class DoctorPreferences {
  late int doctorProfileId;
  late bool emailReminders;
  late bool emailAppointmentRequests;
  late bool emailNewFeatures;
  late bool emailMarketing;
  late bool smsReminderAppointmentReports;
  late bool smsAppointmentRequest;
  late bool pushNotificationsReminderAppointmentReports;
  late bool pushNotificationsAppointmentRequest;

  DoctorPreferences.fromJson(Map data) {
    doctorProfileId = data['doctorProfileId'];
    emailReminders = data['emailReminders'] == 1 ? true : false;
    emailAppointmentRequests = data['emailAppointmentRequests'] == 1 ? true : false;
    emailNewFeatures = data['emailNewFeatures'] == 1 ? true : false;
    emailMarketing = data['emailMarketing'] == 1 ? true : false;
    smsReminderAppointmentReports = data['smsReminderAppointmentReports'] == 1 ? true : false;
    smsAppointmentRequest = data['smsAppointmentRequest'] == 1 ? true : false;
    pushNotificationsReminderAppointmentReports = data['pushNotificationsReminderAppointmentReports'] == 1 ? true : false;
    pushNotificationsAppointmentRequest = data['pushNotificationsAppointmentRequest'] == 1 ? true : false;
  }

  Map<String, dynamic> toJson() => {
        'doctorProfileId': doctorProfileId,
        'emailAppointmentRequests': emailAppointmentRequests,
        'emailNewFeatures': emailNewFeatures,
        'emailMarketing': emailMarketing,
        'smsReminderAppointmentReports': smsReminderAppointmentReports,
        'smsAppointmentRequest': smsAppointmentRequest,
        'pushNotificationsReminderAppointmentReports': pushNotificationsReminderAppointmentReports,
        'pushNotificationsAppointmentRequest': pushNotificationsAppointmentRequest,
      };
}
