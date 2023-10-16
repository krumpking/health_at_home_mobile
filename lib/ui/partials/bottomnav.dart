import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/config/app.dart';

class BottomNav extends StatefulWidget {
  get index => null;

  @override
  State<StatefulWidget> createState() {
    return _BottomNavState(index);
  }
}

class _BottomNavState extends State<BottomNav> {
  late int _selectedIndex = 0;

  _BottomNavState(index);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: App.theme.turquoise,
      unselectedItemColor: App.theme.darkGrey,
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
  }

  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
