import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/config/app.dart';

class OnboardLightStatusNavigationBarWidget extends StatefulWidget {
  final Widget child;

  OnboardLightStatusNavigationBarWidget({Key? key, required this.child})
      : super(key: key);

  @override
  State<OnboardLightStatusNavigationBarWidget> createState() =>
      _OnboardLightStatusNavigationBarWidgetState();
}

class _OnboardLightStatusNavigationBarWidgetState
    extends State<OnboardLightStatusNavigationBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: widget.child,
    );
  }
}

class LightStatusNavigationBarWidget extends StatefulWidget {
  final Widget child;

  LightStatusNavigationBarWidget({Key? key, required this.child})
      : super(key: key);

  @override
  State<LightStatusNavigationBarWidget> createState() =>
      _LightStatusNavigationBarWidgetState();
}

class _LightStatusNavigationBarWidgetState
    extends State<LightStatusNavigationBarWidget> {
  @override
  Widget build(BuildContext context) {
    App.setActiveApp(ActiveApp.PATIENT);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Platform.isIOS
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: App.theme.turquoise50,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
      child: widget.child,
    );
  }
}

class HomeStatusNavigationBarWidget extends StatefulWidget {
  final Widget child;

  HomeStatusNavigationBarWidget({Key? key, required this.child})
      : super(key: key);

  @override
  State<HomeStatusNavigationBarWidget> createState() =>
      _HomeStatusNavigationBarWidgetState();
}

class _HomeStatusNavigationBarWidgetState
    extends State<HomeStatusNavigationBarWidget> {
  @override
  Widget build(BuildContext context) {
    App.setActiveApp(ActiveApp.PATIENT);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Platform.isIOS
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
      child: widget.child,
    );
  }
}

class DarkStatusNavigationBarWidget extends StatefulWidget {
  final Widget child;

  DarkStatusNavigationBarWidget({Key? key, required this.child})
      : super(key: key);

  @override
  State<DarkStatusNavigationBarWidget> createState() =>
      _DarkStatusNavigationBarWidgetState();
}

class _DarkStatusNavigationBarWidgetState
    extends State<DarkStatusNavigationBarWidget> {
  @override
  Widget build(BuildContext context) {
    App.setActiveApp(ActiveApp.DOCTOR);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Platform.isIOS
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
              statusBarColor: App.theme.darkBackground,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarContrastEnforced: false,
              systemNavigationBarColor: App.theme.darkBackground,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
      child: widget.child,
    );
  }
}
