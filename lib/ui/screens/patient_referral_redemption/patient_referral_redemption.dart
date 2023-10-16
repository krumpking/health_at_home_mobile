import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';
import 'package:share/share.dart';

class PatientReferralRedemption extends StatefulWidget {
  const PatientReferralRedemption({Key? key}) : super(key: key);

  @override
  _PatientReferralRedemptionState createState() => _PatientReferralRedemptionState();
}

class _PatientReferralRedemptionState extends State<PatientReferralRedemption> {
  final oCcy = new NumberFormat("#,##0", "en_US");

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.turquoise50,
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: App.theme.turquoise,
                                size: 24,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            GestureDetector(
                              child: Icon(
                                Icons.close,
                                color: App.theme.turquoise,
                                size: 32,
                              ),
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => Home(0),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Text(
                      'Get \$${oCcy.format(App.settings!.shareDiscount)} off your next visit!',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 23,
                        color: App.theme.grey900,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Share your single-use referral code and a link to the app with your friends and family.',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: App.theme.grey800,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Once one of them enters your unique code through the menu of the app, they’ll receive \$${oCcy.format(App.settings!.shareDiscount)} off their first visit.',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: App.theme.grey800,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Once they’ve completed their first visit, you’ll get \$${oCcy.format(App.settings!.shareDiscount)} off your next visit!',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: App.theme.grey800,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Your Unique Referral Code',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: App.theme.grey700,
                      ),
                    ),
                    SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(new ClipboardData(text: App.currentUser.patientProfile!.referralCode!.code)).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              elevation: 0,
                              backgroundColor: Colors.black.withOpacity(0.5),
                              content: Container(
                                  child: Text(
                                'Copied to clipboard',
                                textAlign: TextAlign.center,
                              )),
                            ),
                          );
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: App.theme.turquoise!,
                                width: 1,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                App.currentUser.patientProfile!.referralCode!.code,
                                style: TextStyle(color: App.theme.turquoise, fontSize: 21, fontWeight: FontWeight.bold),
                              ),
                              SvgPicture.asset('assets/icons/icon_copy.svg')
                            ],
                          )),
                    ),
                    SizedBox(height: 24),
                    PrimaryLargeButton(
                      title: 'Share app link & code',
                      iconWidget: SizedBox(),
                      onPressed: () {
                        String iosLink = "https://apps.apple.com/us/app/health-at-home-mobile/id1601263619";
                        String androidLink = "https://play.google.com/store/apps/details?id=zw.co.healthathome.mobile";
                        Share.share(
                            'Try Health At Home\nOrder a doctor, physio and more to your doorstep! Use referral code ${App.currentUser.patientProfile!.referralCode!.code} for \$${oCcy.format(App.settings!.shareDiscount)} off your first visit.\nIOS: $iosLink\nAndroid: $androidLink');
                      },
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
