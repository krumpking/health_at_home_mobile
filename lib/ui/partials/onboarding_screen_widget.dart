import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';

class OnBoardingLightWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageTitle;
  final bool topAligned;

  const OnBoardingLightWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageTitle,
    required this.topAligned,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: topAligned,
          child: Expanded(
            child: SizedBox(),
          ),
        ),
        Expanded(
            flex: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: Image.asset(imageTitle),
            )),
        Visibility(
          visible: !topAligned,
          child: Expanded(
            child: SizedBox(),
          ),
        ),
        Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: App.theme.grey50,
                boxShadow: [
                  BoxShadow(color: (App.theme.darkBackground)!.withOpacity(0.3), spreadRadius: 0, blurRadius: 30),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 0.27,
                      color: App.theme.grey800,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '$subtitle',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: App.theme.grey600,
                    ),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}

class OnBoardingDarkWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageTitle;
  final bool topAligned;

  const OnBoardingDarkWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageTitle,
    required this.topAligned,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: topAligned,
          child: Expanded(
            child: SizedBox(),
          ),
        ),
        Expanded(
            flex: 7,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: Image.asset(imageTitle),
            )),
        Visibility(
          visible: !topAligned,
          child: Expanded(
            child: SizedBox(),
          ),
        ),
        Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              color: App.theme.darkBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 0.27,
                      color: App.theme.grey50,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '$subtitle',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: App.theme.grey50,
                    ),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
