import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/config/theme.dart';
import 'package:mobile/ui/partials/dynamic_menu.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/patient/doctors.dart';
import 'package:mobile/ui/screens/patient_medical_profile/patient_medical_profile.dart';

import 'auth/login.dart';
import 'guest_home_page.dart';

class Home extends StatefulWidget {
  final int? selectedIndex;
  Home(this.selectedIndex);
  @override
  State<StatefulWidget> createState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return HomeState(selectedIndex);
  }
}

class HomeState extends State<Home> {
  final int? selectedIndex;
  HomeState(this.selectedIndex);

  @override
  void initState() {
    super.initState();

    if (selectedIndex != null) {
      Box box = Hive.box('app');
      box.put('home_index', selectedIndex);
    }
    App.theme = AppTheme();
  }

  void _onItemTapped(int index) {
    if (index == 1 && !App.isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );

      return;
    }
    Box box = Hive.box('app');
    box.put('home_index', index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      GuestHomePage(),
      PatientMedicalProfile(),
      Doctors(),
      DynamicMenu(),
    ];

    return HomeStatusNavigationBarWidget(
      child: Scaffold(
        body: ValueListenableBuilder<Box>(
          valueListenable: Hive.box('app').listenable(),
          builder: (context, box, widget) {
            int selectedIndex = box.get('home_index', defaultValue: 0);
            return _children[selectedIndex];
          },
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: App.theme.grey!.withOpacity(0.07),
                  spreadRadius: 8,
                  blurRadius: 10,
                  offset: Offset(-2, -2), // changes position of shadow
                ),
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            child: ValueListenableBuilder<Box>(
              valueListenable: Hive.box('app').listenable(),
              builder: (context, box, widget) {
                int selectedIndex = box.get('home_index', defaultValue: 0);
                return BottomNavigationBar(
                  currentIndex: selectedIndex,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  selectedItemColor: App.theme.turquoise,
                  unselectedItemColor: App.theme.darkGrey,
                  backgroundColor: Colors.white,
                  onTap: _onItemTapped,
                  items: [
                    BottomNavigationBarItem(
                        activeIcon: SvgPicture.asset('assets/icons/icon_home.svg', color: App.theme.turquoise),
                        icon: SvgPicture.asset('assets/icons/icon_home.svg', color: App.theme.darkGrey),
                        label: ''),
                    BottomNavigationBarItem(
                        activeIcon: SvgPicture.asset('assets/icons/icon_user.svg', color: App.theme.turquoise),
                        icon: SvgPicture.asset('assets/icons/icon_user.svg', color: App.theme.darkGrey),
                        label: ''),
                    BottomNavigationBarItem(
                        activeIcon: SvgPicture.asset('assets/icons/icon_search.svg', color: App.theme.turquoise),
                        icon: SvgPicture.asset('assets/icons/icon_search.svg', color: App.theme.darkGrey),
                        label: ''),
                    BottomNavigationBarItem(
                        activeIcon: SvgPicture.asset('assets/icons/icon_menu.svg', color: App.theme.turquoise),
                        icon: SvgPicture.asset('assets/icons/icon_menu.svg', color: App.theme.darkGrey),
                        label: ''),
                  ],
                  type: BottomNavigationBarType.fixed,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
