import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/onboarding_screen_widget.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';

class DoctorOnBoarding extends StatefulWidget {
  const DoctorOnBoarding({Key? key}) : super(key: key);

  @override
  _DoctorOnBoardingState createState() => _DoctorOnBoardingState();
}

class _DoctorOnBoardingState extends State<DoctorOnBoarding> {


  int currentIndex = 0;
  late PageController _controller = PageController();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }


  List <Widget> onBoardingScreens = [
    OnBoardingDarkWidget(
        title: 'Enter your times and area of availability',
        subtitle: 'Mark yourself available for up to three timeframes for each day of the week. Also say how far you’re willing to travel from home or the office.',
        imageTitle: 'assets/onboarding/onboarding_doctor_a.png',
        topAligned: false),
    OnBoardingDarkWidget(
        title: 'You’re in control of your commitments',
        subtitle: 'Review and confirm an appointment to add it to your schedule or decline it for another doctor to pick up.',
        imageTitle: 'assets/onboarding/onboarding_doctor_b.png',
        topAligned: true),
    OnBoardingDarkWidget(
        title: 'Keep track of your upcoming appointments',
        subtitle: 'View your upcoming appointments day by day or even your week at a glance. Quickly execute administration tasks.',
        imageTitle: 'assets/onboarding/onboarding_doctor_c.png',
        topAligned: false),
    OnBoardingDarkWidget(
        title: 'Log appointment reports quickly and easily',
        subtitle: 'Log your appointment reports with ease and precision, on the go or from the comfort of your home.',
        imageTitle: 'assets/onboarding/onboarding_doctor_d.png',
        topAligned: true),
    OnBoardingDarkWidget(
        title: 'Complete reports within 24 hours to secure your bonus',
        subtitle: 'Stay above 95% of reports complete within 24 hours each month and you’ll receive a 5% revenue bonus.',
        imageTitle: 'assets/onboarding/onboarding_doctor_e.png',
        topAligned: false),
    OnBoardingDarkWidget(
        title: 'Be proactive: Request reviews with your patients',
        subtitle: 'Don’t rely on them to reach out. Make sure they book that next visit with an automatic follow-up notification.',
        imageTitle: 'assets/onboarding/onboarding_doctor_f.png',
        topAligned: true),
  ];

  @override
  Widget build(BuildContext context) {



    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: [0.5, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [(App.theme.turquoiseLight)!, (App.theme.darkBackground)!])),
      child: DarkStatusNavigationBarWidget(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Expanded(
                child:
                PageView(
                    pageSnapping: true,
                    scrollDirection: Axis.horizontal,
                    controller: _controller,
                    onPageChanged: (value) {
                      setState(() {
                        currentIndex = value;
                      });
                    },
                    children: onBoardingScreens
                ),
              ),
              Container(
                color: App.theme.darkBackground,
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
                        color: currentIndex + 1 >= 2 ? App.theme.turquoise : App.theme.white,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 1),
                        height: 2,
                        color: currentIndex + 1 >= 3 ? App.theme.turquoise : App.theme.white,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 1),
                        height: 2,
                        color: currentIndex + 1 >= 4 ? App.theme.turquoise : App.theme.white,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 1),
                        height: 2,
                        color: currentIndex + 1 >= 5 ? App.theme.turquoise : App.theme.white,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 1),
                        height: 2,
                        color: currentIndex + 1 >= 6 ? App.theme.turquoise : App.theme.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 70,
                width: double.infinity,
                color: App.theme.darkBackground,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: currentIndex == 0 ? SizedBox() : GestureDetector(
                          child: Text('Previous',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: App.theme.mutedLightColor,
                              decoration: TextDecoration.underline,
                            ),),
                          onTap: (){
                            _controller.previousPage(duration: Duration(milliseconds: 750), curve: Curves.easeInOut);
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('${currentIndex + 1}/${onBoardingScreens.length}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: App.theme.mutedLightColor
                          ),),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: currentIndex + 1 != onBoardingScreens.length ?
                          PrimarySmallButton(
                              title: 'Next', onPressed: (){
                            _controller.nextPage(duration: Duration(milliseconds: 750), curve: Curves.easeInOut);
                          }) : PrimarySmallButton(
                              title: 'Finish', onPressed: (){
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => DoctorHome()),
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
    );
  }
}
