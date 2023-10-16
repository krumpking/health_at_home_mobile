import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/onboarding_screen_widget.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';

class GeneralOnBoarding extends StatefulWidget {
  const GeneralOnBoarding({Key? key}) : super(key: key);

  @override
  _GeneralOnBoardingState createState() => _GeneralOnBoardingState();
}

class _GeneralOnBoardingState extends State<GeneralOnBoarding> {
  final _storage = FlutterSecureStorage();

  int currentIndex = 0;
  late PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
    _storage.write(key: 'patientOnboardingComplete', value: 'yes');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> onBoardingScreens = [
    OnBoardingLightWidget(
        title: 'Find a doctor or service you can trust - from home!',
        subtitle:
            'Browse our practitioners and services to get the kind of help you need. We have a wide range of assistance available.',
        imageTitle: 'assets/onboarding/preview_find_a_service.png',
        topAligned: false),
    OnBoardingLightWidget(
        title: 'Or get care from any doctor as soon as possible',
        subtitle:
            'Need to see someone urgently? We have doctors on call most hours of the day. Simply select “anyone ASAP” and we’ll send someone to you. ',
        imageTitle: 'assets/onboarding/preview_asap.png',
        topAligned: true),
    OnBoardingLightWidget(
        title: 'View practitioners’ profiles. Review their performance',
        subtitle:
            'It’s important to know you’re in safe hands. Our doctors are hand-picked for the best quality of care. Don’t believe us? Check out their profiles!',
        imageTitle: 'assets/onboarding/preview_doctor_profile.png',
        topAligned: false),
    OnBoardingLightWidget(
        title: 'Get updates when doctors are on their way',
        subtitle:
            'Have peace of mind that your doctor’s on their way. We give you an estimated time of arrival so you can plan ahead. ',
        imageTitle: 'assets/onboarding/preview_doctor_tracking.png',
        topAligned: true),
  ];

  @override
  Widget build(BuildContext context) {
    return OnboardLightStatusNavigationBarWidget(
      child: Scaffold(
        extendBody: true,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  stops: [0.5, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    (App.theme.turquoise)!,
                    (App.theme.darkBackground)!
                  ])),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                      pageSnapping: true,
                      scrollDirection: Axis.horizontal,
                      controller: _controller,
                      onPageChanged: (value) {
                        setState(() {
                          currentIndex = value;
                        });
                      },
                      children: onBoardingScreens),
                ),
                Container(
                  color: App.theme.grey50,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          height: 2,
                          color: App.theme.turquoise,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          height: 2,
                          color: currentIndex + 1 >= 2
                              ? App.theme.turquoise
                              : App.theme.grey300,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          height: 2,
                          color: currentIndex + 1 >= 3
                              ? App.theme.turquoise
                              : App.theme.grey300,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          height: 2,
                          color: currentIndex + 1 >= 4
                              ? App.theme.turquoise
                              : App.theme.grey300,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    height: 70,
                    width: double.infinity,
                    color: App.theme.grey50,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: currentIndex == 0
                                ? SizedBox()
                                : GestureDetector(
                                    child: Text(
                                      'Previous',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: App.theme.grey800,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    onTap: () {
                                      _controller.previousPage(
                                          duration: Duration(milliseconds: 750),
                                          curve: Curves.easeInOut);
                                    },
                                  ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${currentIndex + 1}/${onBoardingScreens.length}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: App.theme.grey800),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: currentIndex + 1 !=
                                      onBoardingScreens.length
                                  ? PrimarySmallButton(
                                      title: 'Next',
                                      onPressed: () {
                                        _controller.nextPage(
                                            duration:
                                                Duration(milliseconds: 400),
                                            curve: Curves.easeInOut);
                                      })
                                  : PrimarySmallButton(
                                      title: 'Finish',
                                      onPressed: () async {
                                        _storage.write(
                                            key: 'patientOnboardingComplete',
                                            value: 'yes');
                                        App.patientOnboardingComplete = true;
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Home(0)),
                                        );
                                      }),
                            ),
                          ),
                        ],
                      ),
                    )

                    // FlatButton(
                    //   child: Text(
                    //       currentIndex == 3 - 1 ? "Continue": "Next"),
                    //   onPressed: (){
                    //     if(currentIndex == 3 - 1){
                    //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()),
                    //       );
                    //     }
                    //     _controller.nextPage(duration: Duration(milliseconds: 100), curve: Curves.bounceIn);
                    //   },
                    //   textColor: Colors.white,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(25),
                    //   ),
                    // ),

                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
