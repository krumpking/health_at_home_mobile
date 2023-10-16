import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  ActiveApp _activeApp = App.activeApp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _activeApp == ActiveApp.DOCTOR ? App.theme.darkBackground : App.theme.turquoise50,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 18, top: 16, right: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
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
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 42),
                    Text(
                      'Contact Us',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: _activeApp == ActiveApp.DOCTOR ? App.theme.white : App.theme.grey900,
                      ),
                    ),
                    SizedBox(height: 24),
                    Divider(
                      color: _activeApp == ActiveApp.DOCTOR ? Color(0XFFCBD5E1).withOpacity(0.3) : Color(0XFFCBD5E1),
                      thickness: 1.5,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Contact Number',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: _activeApp == ActiveApp.DOCTOR ? App.theme.white : App.theme.grey900,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (await canLaunch('tel: +263 780 147 562')) {
                                await launch('tel: +263 780 147 562');
                              }
                            },
                            child: Text(
                              '+263 780 147 562',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: App.theme.turquoise,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: _activeApp == ActiveApp.DOCTOR ? Color(0XFFCBD5E1).withOpacity(0.3) : Color(0XFFCBD5E1),
                      thickness: 1.5,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Email Address',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: _activeApp == ActiveApp.DOCTOR ? App.theme.white : App.theme.grey900,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (await canLaunch('mailto:hello@healthathome.co.zw')) {
                                await launch('mailto:hello@healthathome.co.zw');
                              }
                            },
                            child: Text(
                              'hello@healthathome.co.zw',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: App.theme.turquoise,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: _activeApp == ActiveApp.DOCTOR ? Color(0XFFCBD5E1).withOpacity(0.3) : Color(0XFFCBD5E1),
                      thickness: 1.5,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
