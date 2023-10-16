import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/language.dart';
import 'package:mobile/models/specialisation.dart';
import 'package:mobile/models/user/doctorProfile.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/my_app_bar.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/doctor/home/doctor_home.dart';

import '../../contact_us.dart';

class DoctorEditProfile extends StatefulWidget {
  const DoctorEditProfile({Key? key}) : super(key: key);

  @override
  _DoctorEditProfileState createState() => _DoctorEditProfileState();
}

class _DoctorEditProfileState extends State<DoctorEditProfile> {
  ApiProvider _provider = new ApiProvider();
  final DoctorProfile? doctor = App.currentUser.doctorProfile!;
  final ImagePicker _picker = ImagePicker();

  final titleController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final languageController = TextEditingController();
  final bioController = TextEditingController();
  final moreInfoController = TextEditingController();
  final registrationNumberController = TextEditingController();
  late File _image;
  bool _imageSelected = false;
  bool _loading = false;
  bool showTitleError = false;
  bool showFirstNameError = false;
  bool showLastNameError = false;
  bool showBioError = false;
  bool showAboutError = false;
  bool imageUploading = false;
  List<Specialisation> _specialisations = <Specialisation>[];
  List<Language> _languages = <Language>[];
  bool _specialisationsLoading = true;
  bool _languagesLoading = true;
  String _specialisationsError = '';
  String _languagesError = '';

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

    setState(() {
      titleController.text = doctor!.title;
      firstNameController.text = doctor!.firstName;
      lastNameController.text = doctor!.lastName;
      bioController.text = doctor!.bio ?? '';
      moreInfoController.text = doctor!.about ?? '';
      registrationNumberController.text = doctor!.opcNumber ?? '';
    });

    _initPage();
  }

  Future<void> _initPage() async {
    try {
      var specialisations = await _provider.getSpecialisations();
      if (specialisations != null) {
        setState(() {
          _specialisations = specialisations;
        });
      } else {
        setState(() {
          _specialisationsError = ApiResponse.message;
        });
        ApiResponse.message = '';
      }
      setState(() {
        _specialisationsLoading = false;
      });
    } catch (_err) {
      if (mounted) {
        setState(() {
          _specialisationsError = 'Failed to load specialisations.';
          _specialisationsLoading = false;
        });
      }
    }

    try {
      var languages = await _provider.getLanguages();
      if (languages != null) {
        setState(() {
          _languages = languages;
        });
      } else {
        setState(() {
          _languagesError = ApiResponse.message;
        });
        ApiResponse.message = '';
      }
      setState(() {
        _languagesLoading = false;
      });
    } catch (_err) {
      if (mounted) {
        setState(() {
          _languagesError = 'Failed to load languages.';
          _languagesLoading = false;
        });
      }
    }
  }

  Future<void> _eraseChangesDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: App.theme.darkGrey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
          contentPadding: EdgeInsets.all(16),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 8),
                SvgPicture.asset('assets/icons/icon_error.svg'),
                SizedBox(height: 24),
                Text(
                  'Erase Changes?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: App.theme.white),
                ),
                SizedBox(height: 8),
                Text(
                  'Exiting this page without saving your changes will erase them. Do you want to erase your changes?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.mutedLightColor),
                ),
                SizedBox(height: 8),
                DangerRegularButton(
                    title: 'Erase Changes',
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }),
                SizedBox(height: 8),
                GestureDetector(
                  child: Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: App.theme.turquoiseLight),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    doUpdateProfile();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveChangesDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: App.theme.darkGrey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
          contentPadding: EdgeInsets.all(16),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 8),
                SvgPicture.asset('assets/icons/icon_success.svg'),
                SizedBox(height: 24),
                Text(
                  'Changes Saved',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: App.theme.white),
                ),
                SizedBox(height: 16),
                SuccessRegularButton(
                    title: 'Okay',
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => DoctorHome(index: 1),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    }),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            color: App.theme.darkBackground,
            child: new Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                new ListTile(
                    leading: new Icon(
                      Icons.photo_library,
                      color: App.theme.white,
                    ),
                    title: new Text(
                      'Gallery',
                      style: TextStyle(color: App.theme.white),
                    ),
                    onTap: () async {
                      var image = await _picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        _image = File(image!.path);
                        _imageSelected = true;
                      });
                      uploadImage();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera, color: App.theme.white),
                  title: new Text(
                    'Camera',
                    style: TextStyle(color: App.theme.white),
                  ),
                  onTap: () async {
                    var image = await _picker.pickImage(source: ImageSource.camera);
                    setState(() {
                      _image = File(image!.path);
                      _imageSelected = true;
                    });
                    uploadImage();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void uploadImage() {
    setState(() {
      imageUploading = true;
    });
    ApiProvider _provider = new ApiProvider();
    _provider.uploadDoctorImage(_image).then((path) {
      if (path != null) {
        setState(() {
          doctor!.profileImg = path;
        });
      } else {
        //print(ApiResponse.message);
      }
      setState(() {
        imageUploading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DarkStatusNavigationBarWidget(
      child: Scaffold(
        appBar: myAppBar(),
        body: SafeArea(
          child: Container(
            color: App.theme.darkBackground,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: Icon(
                            Icons.close,
                            color: App.theme.white,
                            size: 32,
                          ),
                          onTap: () {
                            _eraseChangesDialog();
                            // Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            _imageSelected
                                ? Stack(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: Image.file(_image, width: 500, height: 500).image,
                                        radius: MediaQuery.of(context).size.width * 0.19,
                                      ),
                                      if (imageUploading)
                                        Positioned(
                                          top: MediaQuery.of(context).size.width * 0.15,
                                          left: MediaQuery.of(context).size.width * 0.15,
                                          child: SizedBox(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                              valueColor: AlwaysStoppedAnimation<Color>(App.theme.green500!),
                                            ),
                                            height: MediaQuery.of(context).size.height * 0.03,
                                            width: MediaQuery.of(context).size.height * 0.03,
                                          ),
                                        ),
                                    ],
                                  )
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      doctor!.profileImg != null ? doctor!.profileImg! : 'https://via.placeholder.com/140x100',
                                    ),
                                    radius: MediaQuery.of(context).size.width * 0.19,
                                  ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  _showPicker(context);
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  child: Container(
                                    child: Center(
                                        child: SvgPicture.asset(
                                      'assets/icons/icon_edit_square.svg',
                                      width: 24,
                                      height: 24,
                                    )),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: App.theme.turquoise,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        color: App.theme.darkGrey,
                        thickness: 1,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Personal Details',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: App.theme.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Title',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: App.theme.mutedLightColor),
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      style: TextStyle(fontSize: 18, color: App.theme.white),
                      controller: titleController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          fillColor: App.theme.mutedLightFillColor,
                          filled: true,
                          hintText: 'Dr.',
                          hintStyle: TextStyle(fontSize: 18, color: App.theme.lightText),
                          contentPadding: EdgeInsets.only(left: 8, right: 8),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF131825), width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF131825), width: 1.0), borderRadius: BorderRadius.circular(10.0))),
                    ),
                    if (showTitleError)
                      Column(
                        children: [
                          SizedBox(height: 6),
                          Text(
                            'Field Required',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 16),
                    Text(
                      'First Name',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: App.theme.mutedLightColor),
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      style: TextStyle(fontSize: 18, color: App.theme.white),
                      controller: firstNameController,
                      decoration: InputDecoration(
                          fillColor: App.theme.mutedLightFillColor,
                          filled: true,
                          hintText: 'Simba',
                          hintStyle: TextStyle(fontSize: 18, color: App.theme.lightText),
                          contentPadding: EdgeInsets.only(left: 8, right: 8),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF131825), width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF131825), width: 1.0), borderRadius: BorderRadius.circular(10.0))),
                    ),
                    if (showFirstNameError)
                      Column(
                        children: [
                          SizedBox(height: 6),
                          Text(
                            'Field Required',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 16),
                    Text(
                      'Last Name',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: App.theme.mutedLightColor),
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      style: TextStyle(fontSize: 18, color: App.theme.white),
                      controller: lastNameController,
                      decoration: InputDecoration(
                          fillColor: App.theme.mutedLightFillColor,
                          filled: true,
                          hintText: 'Mazorodze',
                          hintStyle: TextStyle(fontSize: 18, color: App.theme.lightText),
                          contentPadding: EdgeInsets.only(left: 8, right: 8),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF131825), width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF131825), width: 1.0), borderRadius: BorderRadius.circular(10.0))),
                    ),
                    if (showLastNameError)
                      Column(
                        children: [
                          SizedBox(height: 6),
                          Text(
                            'Field Required',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        color: App.theme.darkGrey,
                        thickness: 1,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Specialisations',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: App.theme.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Select your Areas of Specialisation',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: App.theme.mutedLightColor),
                    ),
                    SizedBox(height: 8),
                    (!_specialisationsLoading && _specialisations.length > 0)
                        ? Wrap(
                            children: [
                              for (Specialisation specialisation in _specialisations)
                                SpecialisationPillButton(title: specialisation.name, onPressed: () {}),
                            ],
                          )
                        : Center(
                            child: SizedBox(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(App.theme.turquoise!.withOpacity(0.5)),
                              ),
                              height: MediaQuery.of(context).size.height * 0.03,
                              width: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ),
                    SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Want to specialise in another area? ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: App.theme.mutedLightColor,
                            ),
                          ),
                          TextSpan(
                            text: 'Contact us ',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 14, color: App.theme.turquoise, decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ContactUs();
                                    },
                                  ),
                                );
                              },
                          ),
                          TextSpan(
                            text: 'to request additions.',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: App.theme.mutedLightColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        color: App.theme.darkGrey,
                        thickness: 1,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Languages',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: App.theme.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Spoken Languages',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: App.theme.mutedLightColor),
                    ),
                    SizedBox(height: 4),
                    (!_languagesLoading && _languages.length > 0)
                        ? Wrap(
                            children: [
                              for (Language language in _languages) LanguagePillButton(title: language.name, onPressed: () {}),
                            ],
                          )
                        : Center(
                            child: SizedBox(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(App.theme.turquoise!.withOpacity(0.5)),
                              ),
                              height: MediaQuery.of(context).size.height * 0.03,
                              width: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        color: App.theme.darkGrey,
                        thickness: 1,
                      ),
                    ),
                    Text(
                      'Bio',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: App.theme.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Bio: A short statement about you (Max. 300 characters)',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: App.theme.grey300,
                      ),
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      maxLines: 9,
                      style: TextStyle(fontSize: 18, color: App.theme.white),
                      controller: bioController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          fillColor: App.theme.mutedLightFillColor,
                          filled: true,
                          hintText: 'Type your bio here...',
                          hintStyle: TextStyle(fontSize: 18, color: App.theme.lightText),
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF131825), width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF131825), width: 1.0), borderRadius: BorderRadius.circular(10.0))),
                    ),
                    if (showBioError)
                      Column(
                        children: [
                          SizedBox(height: 6),
                          Text(
                            'Field Required',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        color: App.theme.darkGrey,
                        thickness: 1,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'More about You',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: App.theme.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'More about you: Help your patients get to know more about you, your professional career, medical interests and what sets you apart as a practitioner (Max. 1000 characters)',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: App.theme.grey300,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      maxLines: 12,
                      style: TextStyle(fontSize: 18, color: App.theme.white),
                      controller: moreInfoController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          fillColor: App.theme.mutedLightFillColor,
                          filled: true,
                          hintText: 'Enter more information about yourself.',
                          hintStyle: TextStyle(fontSize: 18, color: App.theme.lightText),
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF131825), width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF131825), width: 1.0), borderRadius: BorderRadius.circular(10.0))),
                    ),
                    if (showAboutError)
                      Column(
                        children: [
                          SizedBox(height: 6),
                          Text(
                            'Field Required',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        color: App.theme.darkGrey,
                        thickness: 1,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'OPC Registration Number',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: App.theme.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Number',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: App.theme.mutedLightColor),
                    ),
                    SizedBox(height: 4),
                    TextField(
                      style: TextStyle(fontSize: 18, color: App.theme.white),
                      controller: registrationNumberController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          fillColor: App.theme.mutedLightFillColor,
                          filled: true,
                          hintText: 'Enter your OPC number',
                          hintStyle: TextStyle(fontSize: 18, color: App.theme.lightText),
                          contentPadding: EdgeInsets.only(left: 8, right: 8),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF131825), width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF131825), width: 1.0), borderRadius: BorderRadius.circular(10.0))),
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: App.theme.darkGrey,
          child: Container(
            padding: EdgeInsets.all(16),
            child: _loading
                ? PrimaryButtonLoading()
                : PrimaryLargeButton(
                    title: 'Save Profile',
                    iconWidget: SizedBox(),
                    onPressed: () {
                      doUpdateProfile();
                    },
                  ),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  void doUpdateProfile() {
    FocusScope.of(context).unfocus();
    setState(() {
      showTitleError = false;
      showFirstNameError = false;
      showLastNameError = false;
      showBioError = false;
      showAboutError = false;
      _loading = true;
    });

    if (titleController.value.text.isEmpty) showTitleError = true;
    if (firstNameController.value.text.isEmpty) showFirstNameError = true;
    if (lastNameController.value.text.isEmpty) showLastNameError = true;
    if (bioController.value.text.isEmpty) showBioError = true;
    if (moreInfoController.value.text.isEmpty) showAboutError = true;

    if (showFirstNameError || showTitleError || showLastNameError || showBioError || showAboutError) {
      setState(() {
        _loading = false;
      });

      return null;
    }

    App.currentUser.doctorProfile!.title = titleController.value.text;
    App.currentUser.doctorProfile!.firstName = firstNameController.value.text;
    App.currentUser.doctorProfile!.lastName = lastNameController.value.text;
    App.currentUser.doctorProfile!.bio = bioController.value.text;
    App.currentUser.doctorProfile!.about = moreInfoController.value.text;

    if (registrationNumberController.value.text.isNotEmpty) {
      App.currentUser.doctorProfile!.opcNumber = registrationNumberController.value.text;
    }

    final ApiProvider provider = new ApiProvider();
    provider.updateDoctorProfile().then((success) {
      if (success) {
        _saveChangesDialog();
      }
      setState(() {
        _loading = false;
      });
    });
  }
}
