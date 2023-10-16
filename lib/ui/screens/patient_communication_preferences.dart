import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';

import 'home.dart';

class PatientMenuCommunicationPreferences extends StatefulWidget {
  const PatientMenuCommunicationPreferences({Key? key}) : super(key: key);

  @override
  _PatientMenuCommunicationPreferencesState createState() => _PatientMenuCommunicationPreferencesState();
}

class _PatientMenuCommunicationPreferencesState extends State<PatientMenuCommunicationPreferences> {
  bool emailReminders = true;
  bool emailAppointmentRequests = true;
  bool emailNewFeatures = true;
  bool emailMarketing = true;
  bool emailReceipts = true;
  bool smsReminderAppointmentReports = false;
  bool visitStatusUpdates = false;
  bool pushNotificationsReminder = true;
  bool pushNotificationsVisitUpdateStatus = true;
  bool loading = false;

  @override
  void initState() {
    if (App.currentUser.patientProfile!.preferences != null) {
      setState(() {
        emailReminders = App.currentUser.patientProfile!.preferences!.emailReminders;
        emailAppointmentRequests = App.currentUser.patientProfile!.preferences!.emailAppointmentRequests;
        emailNewFeatures = App.currentUser.patientProfile!.preferences!.emailNewFeatures;
        emailMarketing = App.currentUser.patientProfile!.preferences!.emailMarketing;
        smsReminderAppointmentReports = App.currentUser.patientProfile!.preferences!.smsReminderAppointmentReports;
        visitStatusUpdates = App.currentUser.patientProfile!.preferences!.visitStatusUpdates;
        pushNotificationsReminder = App.currentUser.patientProfile!.preferences!.pushNotificationsReminder;
        pushNotificationsVisitUpdateStatus = App.currentUser.patientProfile!.preferences!.pushNotificationsVisitUpdateStatus;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.turquoise50,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                height: 84,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: App.theme.turquoise,
                        size: 24,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Communication Preferences',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: App.theme.grey800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(
                            color: App.theme.grey300,
                            thickness: 1,
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: App.theme.grey800,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: App.theme.turquoise,
                                  ),
                                  child: Checkbox(
                                    checkColor: App.theme.turquoise50,
                                    focusColor: App.theme.turquoise,
                                    activeColor: App.theme.turquoise,
                                    value: emailReminders,
                                    onChanged: (newValue) {
                                      setState(() {
                                        emailReminders = newValue!;
                                      });
                                      App.currentUser.patientProfile!.preferences!.emailReminders = emailReminders;
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      emailReminders = !emailReminders;
                                    });
                                    App.currentUser.patientProfile!.preferences!.emailReminders = emailReminders;
                                  },
                                  child: Text('Reminders - Visits and Reviews',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: App.theme.grey900,
                                      )),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: App.theme.turquoise,
                                  ),
                                  child: Checkbox(
                                    checkColor: App.theme.turquoise50,
                                    focusColor: App.theme.turquoise,
                                    activeColor: App.theme.turquoise,
                                    value: emailAppointmentRequests,
                                    onChanged: (newValue) {
                                      setState(() {
                                        emailAppointmentRequests = newValue!;
                                      });
                                      App.currentUser.patientProfile!.preferences!.emailAppointmentRequests = emailAppointmentRequests;
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      emailAppointmentRequests = !emailAppointmentRequests;
                                    });
                                    App.currentUser.patientProfile!.preferences!.emailAppointmentRequests = emailAppointmentRequests;
                                  },
                                  child: Text('Visit Status Updates',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: App.theme.grey900,
                                      )),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: App.theme.turquoise,
                                  ),
                                  child: Checkbox(
                                    checkColor: App.theme.turquoise50,
                                    focusColor: App.theme.turquoise,
                                    activeColor: App.theme.turquoise,
                                    value: emailNewFeatures,
                                    onChanged: (newValue) {
                                      setState(() {
                                        emailNewFeatures = newValue!;
                                      });
                                      App.currentUser.patientProfile!.preferences!.emailNewFeatures = emailNewFeatures;
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      emailNewFeatures = !emailNewFeatures;
                                    });
                                    App.currentUser.patientProfile!.preferences!.emailNewFeatures = emailNewFeatures;
                                  },
                                  child: Text('New Features',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: App.theme.grey900,
                                      )),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: App.theme.turquoise,
                                  ),
                                  child: Checkbox(
                                    checkColor: App.theme.turquoise50,
                                    focusColor: App.theme.turquoise,
                                    activeColor: App.theme.turquoise,
                                    value: emailMarketing,
                                    onChanged: (newValue) {
                                      setState(() {
                                        emailMarketing = newValue!;
                                      });
                                      App.currentUser.patientProfile!.preferences!.emailMarketing = emailMarketing;
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      emailMarketing = !emailMarketing;
                                    });
                                    App.currentUser.patientProfile!.preferences!.emailMarketing = emailMarketing;
                                  },
                                  child: Text('Marketing',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: App.theme.grey900,
                                      )),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: App.theme.turquoise,
                                  ),
                                  child: Checkbox(
                                    checkColor: App.theme.turquoise50,
                                    focusColor: App.theme.turquoise,
                                    activeColor: App.theme.turqoise300,
                                    value: emailReceipts,
                                    onChanged: (newValue) {},
                                  ),
                                ),
                                Text(
                                  'Recepits',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: App.theme.turqoise300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(
                            color: App.theme.grey300,
                            thickness: 1,
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SMS',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: App.theme.grey800,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: App.theme.turquoise,
                                  ),
                                  child: Checkbox(
                                    checkColor: App.theme.turquoise50,
                                    focusColor: App.theme.turquoise,
                                    activeColor: App.theme.turquoise,
                                    value: smsReminderAppointmentReports,
                                    onChanged: (newValue) {
                                      setState(() {
                                        smsReminderAppointmentReports = newValue!;
                                      });
                                      App.currentUser.patientProfile!.preferences!.smsReminderAppointmentReports = smsReminderAppointmentReports;
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      smsReminderAppointmentReports = !smsReminderAppointmentReports;
                                    });
                                    App.currentUser.patientProfile!.preferences!.smsReminderAppointmentReports = smsReminderAppointmentReports;
                                  },
                                  child: Text('Reminders - Visits and Reviews',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: App.theme.grey900,
                                      )),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: App.theme.turquoise,
                                  ),
                                  child: Checkbox(
                                    checkColor: App.theme.turquoise50,
                                    focusColor: App.theme.turquoise,
                                    activeColor: App.theme.turquoise,
                                    value: visitStatusUpdates,
                                    onChanged: (newValue) {
                                      setState(() {
                                        visitStatusUpdates = newValue!;
                                      });
                                      App.currentUser.patientProfile!.preferences!.visitStatusUpdates = visitStatusUpdates;
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      visitStatusUpdates = !visitStatusUpdates;
                                    });
                                    App.currentUser.patientProfile!.preferences!.visitStatusUpdates = visitStatusUpdates;
                                  },
                                  child: Text('Visit Status Updates',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: App.theme.grey900,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(
                            color: App.theme.grey300,
                            thickness: 1,
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Push Notifications',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: App.theme.grey800,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: App.theme.turquoise,
                                  ),
                                  child: Checkbox(
                                    checkColor: App.theme.turquoise50,
                                    focusColor: App.theme.turquoise,
                                    activeColor: App.theme.turquoise,
                                    value: pushNotificationsReminder,
                                    onChanged: (newValue) {
                                      setState(() {
                                        pushNotificationsReminder = newValue!;
                                      });
                                      App.currentUser.patientProfile!.preferences!.pushNotificationsReminder = pushNotificationsReminder;
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      pushNotificationsReminder = !pushNotificationsReminder;
                                    });
                                    App.currentUser.patientProfile!.preferences!.pushNotificationsReminder = pushNotificationsReminder;
                                  },
                                  child: Text('Reminders - Visits and Reviews',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: App.theme.grey900,
                                      )),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: App.theme.turquoise,
                                  ),
                                  child: Checkbox(
                                    checkColor: App.theme.turquoise50,
                                    focusColor: App.theme.turquoise,
                                    activeColor: App.theme.turquoise,
                                    value: pushNotificationsVisitUpdateStatus,
                                    onChanged: (newValue) {
                                      setState(() {
                                        pushNotificationsVisitUpdateStatus = newValue!;
                                      });
                                      App.currentUser.patientProfile!.preferences!.pushNotificationsVisitUpdateStatus =
                                          pushNotificationsVisitUpdateStatus;
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      pushNotificationsVisitUpdateStatus = !pushNotificationsVisitUpdateStatus;
                                    });
                                    App.currentUser.patientProfile!.preferences!.pushNotificationsVisitUpdateStatus =
                                        pushNotificationsVisitUpdateStatus;
                                  },
                                  child: Text('Visit Update Status',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: App.theme.grey900,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(
                            color: App.theme.grey300,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            child: loading
                ? PrimaryButtonLoading()
                : PrimaryLargeButton(
                    title: 'Confirm Settings',
                    iconWidget: SizedBox(),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        loading = true;
                      });

                      ApiProvider _provider = new ApiProvider();
                      var success = await _provider.updatePatientPreferences();
                      if (success) {
                        _saveChangesDialog();
                      }

                      setState(() {
                        loading = false;
                      });
                    },
                  ),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Future<void> _saveChangesDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: App.theme.turquoise50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
          contentPadding: EdgeInsets.all(16),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 8),
                SvgPicture.asset('assets/icons/icon_success.svg'),
                SizedBox(height: 24),
                Text(
                  'Changes Saved',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: App.theme.darkText),
                ),
                SizedBox(height: 16),
                Text(
                  'Your preferences have been updated.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.mutedLightColor),
                ),
                SizedBox(height: 16),
                SuccessRegularButton(
                    title: 'Back to Menu',
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => Home(3),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    }),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
