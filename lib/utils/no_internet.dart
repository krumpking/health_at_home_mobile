import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/config/theme.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:app_settings/app_settings.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    App.theme = new AppTheme();
    return Container(
      padding: EdgeInsets.only(left: 16, top: 60, right: 16, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Please check your internet connection',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16,
              color: App.theme.turquoise,
            ),
          ),
          SizedBox(height: 16),
          Column(
            children: [
              PrimaryRegularButton(
                  title: "Open Internet Settings",
                  onPressed: () {
                    AppSettings.openAppSettings(type: AppSettingsType.wifi);
                  }),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Color(0XFFF8FAFC),
        boxShadow: [
          BoxShadow(
            color: App.theme.grey!.withOpacity(0.05),
            spreadRadius: 8,
            blurRadius: 10,
            offset: Offset(-2, -2), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
