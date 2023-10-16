import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';

class PatientRedeemCode extends StatefulWidget {
  const PatientRedeemCode({Key? key}) : super(key: key);

  @override
  _PatientRedeemCodeState createState() => _PatientRedeemCodeState();
}

class _PatientRedeemCodeState extends State<PatientRedeemCode> {
  final oCcy = new NumberFormat("#,##0", "en_US");
  late String error = '';
  late String formError = '';
  bool loading = false;
  final referralCodeController = TextEditingController();
  final _referralCodeFieldKey = GlobalKey<FormFieldState>();

  Future<void> _redeemCode() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: App.theme.white,
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
                  'Code Applied Successfully!',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: App.theme.grey900),
                ),
                SizedBox(height: 16),
                Text(
                  'You’ll have a \$10 discount applied to your first visit. ',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.grey500),
                ),
                SizedBox(height: 16),
                SuccessRegularButton(title: 'Book Now', onPressed: () {}),
                SizedBox(height: 8),
                Text(
                  'Go Home',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.turqoise300),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

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
                    Text(
                      'Apply your referral code below for \$${oCcy.format(App.settings!.shareDiscount)} off your first appointment.',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 23,
                        color: App.theme.grey900,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Referral Code',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: App.theme.grey700,
                      ),
                    ),
                    TextFormField(
                      key: _referralCodeFieldKey,
                      style: TextStyle(fontSize: 18, color: App.theme.darkText),
                      controller: referralCodeController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        setState(() {
                          formError = '';
                        });
                        if (value!.isNotEmpty) {
                          RegExp regex = new RegExp(r'^[a-zA-Z0-9]{6,}$');
                          if (!regex.hasMatch(value) || value.length != 6) {
                            setState(() {
                              formError = 'Sorry, this is not a valid code.';
                            });
                            return '';
                          } else {
                            return null;
                          }
                        } else {
                          setState(() {
                            formError = "Referral Code Field Required";
                          });
                          return '';
                        }
                      },
                      onChanged: (value) {
                        _referralCodeFieldKey.currentState!.validate();
                      },
                      decoration: InputDecoration(
                          fillColor: App.theme.white,
                          filled: true,
                          hintText: 'abc123',
                          hintStyle: TextStyle(fontSize: 18, color: App.theme.grey400),
                          contentPadding: EdgeInsets.only(left: 8, right: 8),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: (App.theme.red)!, width: 1.0), borderRadius: BorderRadius.circular(10.0)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: (App.theme.grey300)!, width: 1.0), borderRadius: BorderRadius.circular(10.0))),
                    ),
                    if (formError.isNotEmpty)
                      Text(
                        formError,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: App.theme.errorRedColor,
                        ),
                      ),
                    SizedBox(height: 8),
                    if (error.isNotEmpty)
                      Text(
                        error,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: App.theme.errorRedColor,
                        ),
                      ),
                    SizedBox(height: 24),
                    loading
                        ? PrimaryButtonLoading()
                        : PrimaryLargeButton(
                            title: 'Redeem Code',
                            iconWidget: SizedBox(),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (_referralCodeFieldKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });

                                ApiProvider _provider = new ApiProvider();
                                _provider.redeemCode({
                                  'patientProfileId': App.currentUser.patientProfile!.id,
                                  'code': referralCodeController.value.text
                                }).then((success) {
                                  if (success) {
                                    _redeemCode();
                                  } else {
                                    error = ApiResponse.message;
                                    ApiResponse.message = '';
                                  }
                                  setState(() {
                                    loading = false;
                                  });
                                });
                              }
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
