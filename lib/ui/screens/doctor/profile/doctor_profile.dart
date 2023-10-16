import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/user/doctorProfile.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';
import 'package:mobile/ui/screens/doctor/profile/doctor_edit_profile.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({Key? key}) : super(key: key);

  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> with TickerProviderStateMixin {
  final DoctorProfile? doctor = App.currentUser.doctorProfile!;
  bool showMore = false;

  @override
  void initState() {
    super.initState();

    if (doctor == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => DoctorHome(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16, top: 0, right: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrimaryExtraSmallIconButton(
                        title: 'Edit',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return DoctorEditProfile();
                          }));
                        }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: CircleAvatar(
                        backgroundColor: App.theme.grey!.withOpacity(0.1),
                        backgroundImage: doctor!.profileImg != null ? NetworkImage(doctor!.profileImg!) : null,
                        radius: MediaQuery.of(context).size.width * 0.19,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (doctor!.title.isNotEmpty ? doctor!.title.replaceAll('.', '') + '. ' : '') + Utilities.convertToTitleCase(doctor!.displayName),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: App.theme.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SimpleStarRating(
                      allowHalfRating: true,
                      starCount: 5,
                      rating: doctor!.rating,
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
                      '${doctor!.rating} Stars',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: App.theme.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/icons/icon_info.svg',
                      width: 16,
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
                    color: App.theme.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  doctor!.specialities,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: App.theme.grey300,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Languages',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: App.theme.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  doctor!.languages,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: App.theme.grey300,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Bio',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: App.theme.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  doctor!.bio!,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: App.theme.grey300,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'More about me',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: App.theme.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  doctor!.about!,
                  maxLines: (doctor!.about!.length > 200 && showMore) ? 10000 : 4,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: App.theme.grey300,
                  ),
                ),
                if (doctor!.about!.length > 200)
                  Column(
                    children: [
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showMore = !showMore;
                          });
                        },
                        child: Text(
                          showMore ? 'Read Less' : 'Read More',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: App.theme.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                Text(
                  'OPC Registration Number',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: App.theme.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  doctor!.opcNumber ?? '',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: App.theme.grey300,
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
