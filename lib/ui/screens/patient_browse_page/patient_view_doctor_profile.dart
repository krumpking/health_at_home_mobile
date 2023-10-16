import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/user/doctorProfile.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

class PatientViewDoctorProfile extends StatefulWidget {
  final DoctorProfile doctor;
  const PatientViewDoctorProfile({Key? key, required this.doctor}) : super(key: key);

  @override
  _PatientViewDoctorProfileState createState() => _PatientViewDoctorProfileState();
}

class _PatientViewDoctorProfileState extends State<PatientViewDoctorProfile> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.turquoise50,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 16, top: 16, right: 16),
                decoration: BoxDecoration(
                  color: App.theme.turquoise50,
                ),
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
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: App.theme.grey!.withOpacity(0.1),
                              backgroundImage: widget.doctor.profileImg != null ? NetworkImage(widget.doctor.profileImg!) : null,
                              radius: MediaQuery.of(context).size.width * 0.2,
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (widget.doctor.title.isNotEmpty ? widget.doctor.title.replaceAll('.', '') + '. ' : '') +
                                  Utilities.convertToTitleCase(widget.doctor.displayName),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: App.theme.grey800,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SimpleStarRating(
                              allowHalfRating: false,
                              starCount: 5,
                              rating: double.parse(widget.doctor.rating.toString()),
                              size: 32,
                              filledIcon: Icon(Icons.star, color: App.theme.btnDarkSecondary, size: 32),
                              nonFilledIcon: Icon(Icons.star_border, color: App.theme.btnDarkSecondary, size: 32),
                              onRated: (rate) {},
                              spacing: 4,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.doctor.rating.toString() + ' Stars',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: App.theme.grey800,
                              ),
                            ),
                            SizedBox(width: 8),
                            SvgPicture.asset(
                              'assets/icons/icon_info.svg',
                              width: 16,
                              color: App.theme.grey800,
                            )
                          ],
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Specialisations',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: App.theme.grey800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.doctor.specialities,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: App.theme.grey600,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Languages',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: App.theme.grey800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.doctor.languages,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: App.theme.grey600,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Bio',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: App.theme.grey800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.doctor.bio!.length > 0 ? widget.doctor.bio! : '--',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: App.theme.grey600,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'About',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: App.theme.grey800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.doctor.about!.length > 0 ? widget.doctor.about! : '--',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: App.theme.grey600,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'OPC Registration Number',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: App.theme.grey800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.doctor.opcNumber != null ? widget.doctor.opcNumber! : '-- ---',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: App.theme.grey600,
                          ),
                        ),
                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
