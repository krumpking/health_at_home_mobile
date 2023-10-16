import 'package:flutter/material.dart';

class AppTheme {
  Color? turquoise;
  Color? turquoise50;
  Color? notWhite;
  Color? nearlyWhite;
  Color? white;
  Color? nearlyBlack;
  Color? grey;
  Color? darkGrey;
  Color? grey700;
  MaterialColor? primary;
  Color? btnColor;
  Color? btnColorDark;
  Color? primaryLight;
  Color? green;
  Color? greenLight;
  Color? red;
  Color? redLight;
  Color? darkText;
  Color? darkerText;
  Color? lightText;
  Color? deactivatedText;
  Color? dismissibleBackground;
  Color? chipBackground;
  Color? spacer;
  Color? darkBackground;
  Color? btnDarkSecondary;
  Color? mutedLightColor;
  Color? mutedLightFillColor;
  Color? lightGreyColor;
  Color? errorRedColor;
  Color? turquoiseLight;
  Color? turqoiseDisabled;
  Color? purple;
  Color? orange;
  Color? grey50;
  Color? grey100;
  Color? grey200;
  Color? grey300;
  Color? grey400;
  Color? grey500;
  Color? grey600;
  Color? grey800;
  Color? grey900;
  Color? red500;
  Color? green500;
  String fontName = 'Jost';
  Color? primary100;
  Color? turqoise300;
  Color disabledButton = Color(0xFFE2E8F0);
  TextStyle? display1;
  TextStyle? headline;
  TextStyle? title;
  TextStyle? subtitle;
  TextStyle? body2;
  TextStyle? body1;
  TextStyle? caption;
  TextTheme? textTheme;

  AppTheme() {
    // Addition Colors Not Related to Theme
    darkBackground = Color(0xFF131825);
    btnDarkSecondary = Color(0xFFF7CE46);
    mutedLightColor = Color(0xFF94A3B8);
    mutedLightFillColor = Color(0xFF262A36);
    lightGreyColor = Color(0xFFEBF2F4);
    errorRedColor = Color(0xFFF87171);
    grey900 = Color(0xFF0F172A);
    grey800 = Color(0xFF1E293B);
    grey700 = Color(0xFF262A36);
    grey600 = Color(0xFF475569);
    grey400 = Color(0xFF94A3B8);
    grey300 = Color(0xFFCBD5E1);
    grey200 = Color(0xFFE2E8F0);
    grey50 = Color(0xFFF8FAFC);
    purple = Color(0xFF5D5FEF);
    orange = Color(0xFFF59E0B);
    red500 = Color(0xFFEF4444);
    green = Color(0xFF059669);
    green500 = Color(0xFF10B981);
    grey500 = Color(0xFF64748B);
    grey100 = Color(0xFFF1F5F9);
    turqoiseDisabled = Color(0xFF032D3A);
    primary100 = Color(0xFF032D3A);
    turqoise300 = Color(0xFF87C1D4);
    turquoise = Color(0xFF137EA0);
    turquoiseLight = Color(0xFF87C1D4);

    notWhite = Color(0xFFEDF0F2);
    nearlyWhite = Color(0xFFFEFEFE);
    white = Color(0xFFFFFFFF);
    nearlyBlack = Color(0xFF213333);
    grey = Color(0xFF3A5160);
    darkGrey = Color(0xFF313A44);
    btnColor = Color(0xFF67BE13);
    btnColorDark = Color(0xFF509C07);
    green = Color(0xFF059669);
    greenLight = Color(0xFFBFF1E9);
    red = Colors.redAccent;
    redLight = Colors.redAccent.withOpacity(0.2);
    turquoise50 = Color(0xFFEBF2F4);
    primary = MaterialColor(
      0XFF407CDE,
      const <int, Color>{
        50: const Color(0XFF407CDE),
        100: const Color(0XFF407CDE),
        200: const Color(0XFF407CDE),
        300: const Color(0XFF407CDE),
        400: const Color(0XFF407CDE),
        500: const Color(0XFF407CDE),
        600: const Color(0XFF407CDE),
        700: const Color(0XFF407CDE),
        800: const Color(0XFF407CDE),
        900: const Color(0XFF407CDE),
      },
    );
    darkText = Color(0xFF253840);
    darkerText = Color(0xFF17262A).withOpacity(0.8);
    lightText = Color(0xFF94A3B8);
    deactivatedText = Color(0xFF767676);
    dismissibleBackground = Color(0xFF364A54);
    chipBackground = Color(0xFFEEF1F3);
    spacer = Color(0xFFF2F2F2);

    primaryLight = primary!.withOpacity(0.2);

    display1 = TextStyle(
      fontFamily: fontName,
      fontWeight: FontWeight.bold,
      fontSize: 36,
      letterSpacing: 0.4,
      height: 0.9,
      color: darkerText,
    );

    headline = TextStyle(
      // h5 -> headline
      fontFamily: fontName,
      fontWeight: FontWeight.bold,
      fontSize: 24,
      letterSpacing: 0.27,
      color: darkerText,
    );

    title = TextStyle(
      // h6 -> title
      fontFamily: fontName,
      fontWeight: FontWeight.bold,
      fontSize: 16,
      letterSpacing: 0.18,
      color: darkerText,
    );

    subtitle = TextStyle(
      // subtitle2 -> subtitle
      fontFamily: fontName,
      fontWeight: FontWeight.w400,
      fontSize: 14,
      letterSpacing: -0.04,
      color: darkText,
    );

    body2 = TextStyle(
      // body1 -> body2
      fontFamily: fontName,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: 0.2,
      color: darkText,
    );

    body1 = TextStyle(
      // body2 -> body1
      fontFamily: fontName,
      fontWeight: FontWeight.w500,
      fontSize: 12,
      letterSpacing: -0.05,
      color: darkText,
    );

    caption = TextStyle(
      // Caption -> caption
      fontFamily: fontName,
      fontWeight: FontWeight.w500,
      fontSize: 12,
      letterSpacing: 0.2,
      color: lightText, // was lightText
    );

    textTheme = TextTheme(
      headline4: display1,
      headline5: headline,
      headline6: title,
      subtitle2: subtitle,
      bodyText2: body2,
      bodyText1: body1,
      caption: caption,
    );
  }
}
