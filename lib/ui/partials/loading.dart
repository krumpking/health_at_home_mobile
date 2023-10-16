import 'package:mobile/config/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: App.theme.white,
            borderRadius: BorderRadius.all(
              Radius.circular(MediaQuery.of(context).size.height * 0.03),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    SvgPicture.asset(
                      "assets/images/logo.svg",
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),
                    SizedBox(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(App.theme.green!.withOpacity(0.5)),
                      ),
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.height * 0.08,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
