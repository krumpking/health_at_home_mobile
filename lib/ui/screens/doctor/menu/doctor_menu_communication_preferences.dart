import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';

class DoctorMenuCommunicationPreferences extends StatefulWidget {
  const DoctorMenuCommunicationPreferences({Key? key}) : super(key: key);

  @override
  _DoctorMenuCommunicationPreferencesState createState() => _DoctorMenuCommunicationPreferencesState();
}

class _DoctorMenuCommunicationPreferencesState extends State<DoctorMenuCommunicationPreferences> {
  bool emailReminders = true;
  bool emailAppointmentRequests = true;
  bool emailNewFeatures = false;
  bool emailMarketing = false;
  bool smsReminderAppointmentReports = false;
  bool smsAppointmentRequest = false;
  bool pushNotificationsReminderAppointmentReports = true;
  bool pushNotificationsAppointmentRequest = true;
  bool loading = false;

  @override
  void initState() {
    if (App.currentUser.doctorProfile!.preferences != null) {
      setState(() {
        emailReminders = App.currentUser.doctorProfile!.preferences!.emailReminders;
        emailAppointmentRequests = App.currentUser.doctorProfile!.preferences!.emailAppointmentRequests;
        emailNewFeatures = App.currentUser.doctorProfile!.preferences!.emailNewFeatures;
        emailMarketing = App.currentUser.doctorProfile!.preferences!.emailMarketing;
        smsReminderAppointmentReports = App.currentUser.doctorProfile!.preferences!.smsReminderAppointmentReports;
        smsAppointmentRequest = App.currentUser.doctorProfile!.preferences!.smsAppointmentRequest;
        pushNotificationsReminderAppointmentReports = App.currentUser.doctorProfile!.preferences!.pushNotificationsReminderAppointmentReports;
        pushNotificationsAppointmentRequest = App.currentUser.doctorProfile!.preferences!.pushNotificationsAppointmentRequest;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DarkStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.darkBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
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
                    color: App.theme.white,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(
                    color: App.theme.darkGrey,
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
                        color: App.theme.white,
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
                            checkColor: App.theme.darkBackground,
                            focusColor: App.theme.turquoise,
                            activeColor: App.theme.turquoise,
                            value: emailReminders,
                            onChanged: (newValue) {
                              setState(() {
                                emailReminders = newValue!;
                              });
                              App.currentUser.doctorProfile!.preferences!.emailReminders = emailReminders;
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              emailReminders = !emailReminders;
                            });
                            App.currentUser.doctorProfile!.preferences!.emailReminders = emailReminders;
                          },
                          child: Text('Reminders - Appointments and Reports',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: App.theme.mutedLightColor,
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
                            checkColor: App.theme.darkBackground,
                            focusColor: App.theme.turquoise,
                            activeColor: App.theme.turquoise,
                            value: emailAppointmentRequests,
                            onChanged: (newValue) {
                              setState(() {
                                emailAppointmentRequests = newValue!;
                              });
                              App.currentUser.doctorProfile!.preferences!.emailAppointmentRequests = emailAppointmentRequests;
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              emailAppointmentRequests = !emailAppointmentRequests;
                            });
                            App.currentUser.doctorProfile!.preferences!.emailAppointmentRequests = emailAppointmentRequests;
                          },
                          child: Text('Appointment Requests',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: App.theme.mutedLightColor,
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
                            checkColor: App.theme.darkBackground,
                            focusColor: App.theme.turquoise,
                            activeColor: App.theme.turquoise,
                            value: emailNewFeatures,
                            onChanged: (newValue) {
                              setState(() {
                                emailNewFeatures = newValue!;
                              });
                              App.currentUser.doctorProfile!.preferences!.emailNewFeatures = emailNewFeatures;
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              emailNewFeatures = !emailNewFeatures;
                            });
                            App.currentUser.doctorProfile!.preferences!.emailNewFeatures = emailNewFeatures;
                          },
                          child: Text('New Features',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: App.theme.mutedLightColor,
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
                            checkColor: App.theme.darkBackground,
                            focusColor: App.theme.turquoise,
                            activeColor: App.theme.turquoise,
                            value: emailMarketing,
                            onChanged: (newValue) {
                              setState(() {
                                emailMarketing = newValue!;
                              });
                              App.currentUser.doctorProfile!.preferences!.emailMarketing = emailMarketing;
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              emailMarketing = !emailMarketing;
                            });
                            App.currentUser.doctorProfile!.preferences!.emailMarketing = emailMarketing;
                          },
                          child: Text('Marketing Emails',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: App.theme.mutedLightColor,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(
                    color: App.theme.darkGrey,
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
                        color: App.theme.white,
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
                            checkColor: App.theme.darkBackground,
                            focusColor: App.theme.turquoise,
                            activeColor: App.theme.turquoise,
                            value: smsReminderAppointmentReports,
                            onChanged: (newValue) {
                              setState(() {
                                smsReminderAppointmentReports = newValue!;
                              });
                              App.currentUser.doctorProfile!.preferences!.smsReminderAppointmentReports = smsReminderAppointmentReports;
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              smsReminderAppointmentReports = !smsReminderAppointmentReports;
                            });
                            App.currentUser.doctorProfile!.preferences!.smsReminderAppointmentReports = smsReminderAppointmentReports;
                          },
                          child: Text('Reminders - Appointments and Reports',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: App.theme.mutedLightColor,
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
                            checkColor: App.theme.darkBackground,
                            focusColor: App.theme.turquoise,
                            activeColor: App.theme.turquoise,
                            value: smsAppointmentRequest,
                            onChanged: (newValue) {
                              setState(() {
                                smsAppointmentRequest = newValue!;
                              });
                              App.currentUser.doctorProfile!.preferences!.smsAppointmentRequest = smsAppointmentRequest;
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              smsAppointmentRequest = !smsAppointmentRequest;
                            });
                            App.currentUser.doctorProfile!.preferences!.smsAppointmentRequest = smsAppointmentRequest;
                          },
                          child: Text('Appointment Requests',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: App.theme.mutedLightColor,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(
                    color: App.theme.darkGrey,
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
                        color: App.theme.white,
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
                            checkColor: App.theme.darkBackground,
                            focusColor: App.theme.turquoise,
                            activeColor: App.theme.turquoise,
                            value: pushNotificationsReminderAppointmentReports,
                            onChanged: (newValue) {
                              setState(() {
                                pushNotificationsReminderAppointmentReports = newValue!;
                              });
                              App.currentUser.doctorProfile!.preferences!.pushNotificationsReminderAppointmentReports =
                                  pushNotificationsReminderAppointmentReports;
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              pushNotificationsReminderAppointmentReports = !pushNotificationsReminderAppointmentReports;
                            });
                            App.currentUser.doctorProfile!.preferences!.pushNotificationsReminderAppointmentReports =
                                pushNotificationsReminderAppointmentReports;
                          },
                          child: Text('Reminders - Appointments and Reports',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: App.theme.mutedLightColor,
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
                            checkColor: App.theme.darkBackground,
                            focusColor: App.theme.turquoise,
                            activeColor: App.theme.turquoise,
                            value: pushNotificationsAppointmentRequest,
                            onChanged: (newValue) {
                              setState(() {
                                pushNotificationsAppointmentRequest = newValue!;
                              });
                              App.currentUser.doctorProfile!.preferences!.pushNotificationsAppointmentRequest = pushNotificationsAppointmentRequest;
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              pushNotificationsAppointmentRequest = !pushNotificationsAppointmentRequest;
                            });
                            App.currentUser.doctorProfile!.preferences!.pushNotificationsAppointmentRequest = pushNotificationsAppointmentRequest;
                          },
                          child: Text('Appointment Requests',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: App.theme.mutedLightColor,
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
                    color: App.theme.darkGrey,
                    thickness: 1,
                  ),
                ),
              ],
            ),
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
                      var success = await _provider.updateDoctorPreferences();
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
          backgroundColor: App.theme.darkGrey,
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
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: App.theme.white),
                ),
                SizedBox(height: 16),
                Text(
                  'Your preferences have been updated.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.white),
                ),
                SizedBox(height: 16),
                SuccessRegularButton(
                    title: 'Back to Menu',
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => DoctorHome(index: 3),
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
