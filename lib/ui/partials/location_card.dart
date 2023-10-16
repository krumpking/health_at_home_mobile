import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';

class LocationCard extends StatefulWidget {
  final String icon;
  final String title;
  final String address;

  const LocationCard({required this.icon, required this.title, required this.address});

  @override
  _LocationCardState createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: SvgPicture.asset(
            'assets/icons/${widget.icon}',
            color: App.activeApp == ActiveApp.DOCTOR ? App.theme.white : App.theme.darkText,
            width: 20,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
          minLeadingWidth: 16,
          minVerticalPadding: 10,
          title: Text(
            '${widget.title}',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: App.activeApp == ActiveApp.DOCTOR ? App.theme.white : App.theme.darkText,
            ),
          ),
        ),
        Divider(color: App.activeApp == ActiveApp.DOCTOR ? App.theme.grey600!.withOpacity(0.5) : App.theme.grey600!.withOpacity(0.2), height: 2),
      ],
    );
  }
}

class LocationCardLight extends StatelessWidget {
  final String icon;
  final String title;
  final String address;

  const LocationCardLight({required this.icon, required this.title, required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: SvgPicture.asset(
            'assets/icons/$icon',
            color: App.theme.grey800,
            width: 20,
          ),
          title: Text('$title',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: App.theme.grey800,
              )),
        ),
        Container(
          height: 2,
          padding: EdgeInsets.symmetric(vertical: 2),
          child: Divider(
            color: App.theme.mutedLightColor,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
