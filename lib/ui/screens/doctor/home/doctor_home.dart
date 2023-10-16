import 'package:eventsubscriber/eventsubscriber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking_notification.dart';
import 'package:mobile/ui/partials/dynamic_menu.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/doctor/appointment/doctor_appointments.dart';
import 'package:mobile/ui/screens/doctor/profile/doctor_profile.dart';
import 'package:mobile/ui/screens/doctor/settings/doctor_notifications.dart';

class DoctorHome extends StatefulWidget {
  final int? index;
  const DoctorHome({Key? key, this.index}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: App.theme.darkBackground,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: App.theme.darkBackground,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    return DoctorHomeState();
  }
}

class DoctorHomeState extends State<DoctorHome> {
  late int _selectedIndex = widget.index != null ? widget.index! : 0;

  @override
  void initState() {
    super.initState();
    initPage();
  }

  Future<void> initPage() async {
    await BookingNotification.getNotifications();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      DoctorAppointments(),
      DoctorProfilePage(),
      DoctorNotification(),
      DynamicMenu(),
    ];

    return DarkStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.darkBackground,
        body: SafeArea(
          child: _children[_selectedIndex],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24)),
            boxShadow: [
              BoxShadow(color: (App.theme.darkBackground)!, spreadRadius: 0, blurRadius: 20),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: App.theme.turquoise,
              unselectedItemColor: App.theme.white,
              backgroundColor: App.theme.grey700,
              onTap: _onItemTapped,
              items: [
                BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset('assets/icons/icon_home.svg', color: App.theme.turquoise),
                    icon: SvgPicture.asset('assets/icons/icon_home.svg', color: App.theme.white),
                    label: ''),
                BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset('assets/icons/icon_user.svg', color: App.theme.turquoise),
                    icon: SvgPicture.asset('assets/icons/icon_user.svg', color: App.theme.white),
                    label: ''),
                BottomNavigationBarItem(
                  activeIcon: EventSubscriber(
                    event: BookingNotification.notificationReadEvent,
                    builder: (context, args) => Stack(
                      children: [
                        SvgPicture.asset('assets/icons/icon_bell.svg', color: App.theme.turquoise),
                        BookingNotification.totalNotifications > 0
                            ? Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 14,
                                    minHeight: 14,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${BookingNotification.totalNotifications}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: App.theme.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox()
                      ],
                    ),
                  ),
                  icon: EventSubscriber(
                    event: BookingNotification.notificationReadEvent,
                    builder: (context, args) => Stack(
                      children: [
                        SvgPicture.asset('assets/icons/icon_bell.svg', color: App.theme.white),
                        BookingNotification.totalNotifications > 0
                            ? Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 14,
                                    minHeight: 14,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${BookingNotification.totalNotifications}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: App.theme.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox()
                      ],
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset('assets/icons/icon_menu.svg', color: App.theme.turquoise),
                    icon: SvgPicture.asset('assets/icons/icon_menu.svg', color: App.theme.white),
                    label: ''),
              ],
              type: BottomNavigationBarType.fixed,
            ),
          ),
        ),
      ),
    );
  }
}
