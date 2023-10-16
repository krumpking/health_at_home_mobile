import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/models/service.dart';
import 'package:mobile/models/user/doctorProfile.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_new_booking_address.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_new_booking_availabilities.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_new_booking_filtered_doctors.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_new_booking_payment.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_new_booking_visit_request_successful.dart';

import '../home.dart';

class PatientNewBookingVisitSummary extends StatefulWidget {
  const PatientNewBookingVisitSummary({Key? key}) : super(key: key);

  @override
  _PatientNewBookingVisitSummaryState createState() => _PatientNewBookingVisitSummaryState();
}

class _PatientNewBookingVisitSummaryState extends State<PatientNewBookingVisitSummary> {
  final chronicConditionsController = TextEditingController();
  final allergiesController = TextEditingController();
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  bool _loading = false;
  late String _error = '';

  @override
  void initState() {
    double total = App.progressBooking!.totalPrice;
    if ((App.currentUser.patientProfile!.referralCode != null &&
            App.currentUser.patientProfile!.referralCode!.isUsed &&
            !App.currentUser.patientProfile!.referralCode!.selfRedeemed) ||
        (App.currentUser.patientProfile!.referredCode != null && App.currentUser.patientProfile!.referredCode!.isUsed)) {
      setState(() {
        App.progressBooking!.totalPrice = total - App.settings!.shareDiscount;
      });
    }
    checkForCovid();
    super.initState();
  }

  Future<void> checkForCovid() async {
    if ((App.progressBooking!.bookingReason!.isCovidPositive || App.progressBooking!.bookingReason!.suspectsCovidPositive) &&
        App.progressBooking!.primaryService.addOnServiceId != null) {
      if (App.progressBooking!.addOnService != null) {
        App.progressBooking!.addOnService = null;
        App.progressBooking!.totalPrice -= App.progressBooking!.addOnService!.price;
      }

      var covidService = Utilities.findServiceById(App.progressBooking!.primaryService.addOnServiceId!);
      if (covidService != null) {
        if (!Utilities.serviceIsInList(App.progressBooking!.secondaryServices, covidService)) {
          App.progressBooking!.addOnService = covidService;
          App.progressBooking!.totalPrice += covidService.price;
        }
      }
    } else {
      App.progressBooking!.totalPrice = App.progressBooking!.isReview && App.progressBooking!.primaryService.reviewPrice > 0
          ? App.progressBooking!.primaryService.reviewPrice
          : App.progressBooking!.primaryService.price;
      for (var i = 0; i < App.progressBooking!.secondaryServices.length; i++) {
        Service service = App.progressBooking!.secondaryServices[i];
        App.progressBooking!.totalPrice += service.price;
      }
    }
  }

  Future<void> _cancelDismissDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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
                SvgPicture.asset('assets/icons/icon_circle_info_secondary.svg'),
                SizedBox(height: 24),
                Text(
                  'Progress will be lost',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: App.theme.grey900),
                ),
                SizedBox(height: 8),
                Text(
                  'Are you sure you want to exit/go back? You will lose any progress you have made to this point.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: App.theme.grey500),
                ),
                SizedBox(height: 16),
                SuccessRegularButton(
                    title: 'Continue',
                    onPressed: () {
                      App.progressBooking = Booking.init();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => Home(0),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    }),
                SizedBox(height: 16),
                GestureDetector(
                  child: Text(
                    'Keep current progress',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: App.theme.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
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
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
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
                                _cancelDismissDialog();
                              },
                            ),
                            GestureDetector(
                              child: Icon(
                                Icons.close,
                                color: App.theme.turquoise,
                                size: 32,
                              ),
                              onTap: () {
                                _cancelDismissDialog();
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text(
                        'Visit Summary',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 23,
                          color: App.theme.grey900,
                        ),
                      ),
                      SizedBox(height: 24),
                      App.progressBooking!.bookingCriteria == BookingCriteria.ASAP
                          ? Text(
                              'Visit Type: Urgent Visit',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: App.theme.grey900,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: App.theme.grey!.withOpacity(0.1),
                                  backgroundImage: App.progressBooking!.selectedDoctor!.profileImg != null
                                      ? NetworkImage(App.progressBooking!.selectedDoctor!.profileImg!)
                                      : null,
                                  radius: MediaQuery.of(context).size.width * 0.1,
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ((App.progressBooking!.selectedDoctor != null && App.progressBooking!.selectedDoctor!.title.isNotEmpty)
                                                ? App.progressBooking!.selectedDoctor!.title.replaceAll('.', '') + '. '
                                                : '') +
                                            Utilities.convertToTitleCase(App.progressBooking!.selectedDoctor!.displayName),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: App.theme.grey900,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      GestureDetector(
                                        child: Text(
                                          'Edit',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: App.theme.turquoise,
                                              decoration: TextDecoration.underline),
                                        ),
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                                            return PatientNewBookingFilteredDoctors();
                                          }));
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                      SizedBox(height: 24),
                      Text(
                        'Address',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: App.theme.grey900,
                        ),
                      ),
                      if (App.progressBooking!.unitNumber.isNotEmpty)
                        Text(
                          App.progressBooking!.unitNumber,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: App.theme.grey600,
                          ),
                        ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              App.progressBooking!.address,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: App.theme.grey600,
                              ),
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              'Edit',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16, color: App.theme.turquoise, decoration: TextDecoration.underline),
                            ),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return PatientNewBookingAddress(isEdit: true);
                              }));
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      if (App.progressBooking!.bookingCriteria == BookingCriteria.SELECT_PROVIDERS)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date/Time',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: App.theme.grey900,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat.E().format(App.progressBooking!.selectedDate) +
                                      ', ' +
                                      DateFormat.MMM().format(App.progressBooking!.selectedDate) +
                                      ' ' +
                                      DateFormat.d().format(App.progressBooking!.selectedDate) +
                                      Utilities.getDayOfMonthSuffix(App.progressBooking!.selectedDate.day) +
                                      ', ' +
                                      App.progressBooking!.startTime!,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: App.theme.grey600,
                                  ),
                                ),
                                if(App.progressBooking!.bookingCriteria != BookingCriteria.ASAP)
                                GestureDetector(
                                  child: Text(
                                    'Edit',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 16, color: App.theme.turquoise, decoration: TextDecoration.underline),
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return PatientNewBookingAvailabilities(
                                          doctorProfile: App.progressBooking!.selectedDoctor as DoctorProfile, isEdit: true,);
                                    }));
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                          ],
                        ),
                      Text(
                        'Services',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: App.theme.grey900,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                App.progressBooking!.primaryService.name + (App.progressBooking!.isReview ? ' (Review)' : ''),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: App.theme.grey600,
                                ),
                                maxLines: 3,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              App.progressBooking!.isReview && App.progressBooking!.primaryService.reviewPrice > 0
                                  ? '\$${oCcy.format(App.progressBooking!.primaryService.reviewPrice)}'
                                  : '\$${oCcy.format(App.progressBooking!.primaryService.price)}',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: App.theme.grey600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (App.progressBooking!.secondaryServices.length > 0)
                        MediaQuery.removePadding(
                          removeTop: true,
                          removeBottom: true,
                          context: context,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: App.progressBooking!.secondaryServices.length,
                            itemBuilder: (context, index) {
                              Service service = App.progressBooking!.secondaryServices[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        service.name,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: App.theme.grey600,
                                        ),
                                        maxLines: 3,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '\$${oCcy.format(service.price)}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: App.theme.grey600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      if (App.progressBooking!.addOnService != null)
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  App.progressBooking!.addOnService!.name,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: App.theme.red,
                                  ),
                                  maxLines: 3,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '\$${oCcy.format(App.progressBooking!.addOnService!.price)}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: App.theme.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if ((App.currentUser.patientProfile!.referralCode != null &&
                              App.currentUser.patientProfile!.referralCode!.isUsed &&
                              !App.currentUser.patientProfile!.referralCode!.selfRedeemed) ||
                          (App.currentUser.patientProfile!.referredCode != null && App.currentUser.patientProfile!.referredCode!.isUsed))
                        Column(
                          children: [
                            SizedBox(height: 8),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Referral Discount',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: App.theme.grey600,
                                    ),
                                  ),
                                  Text(
                                    '- \$${oCcy.format(App.settings!.shareDiscount)}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: App.theme.grey600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: App.theme.grey900,
                            ),
                          ),
                          Text(
                            '\$${oCcy.format(App.progressBooking!.totalPrice)}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: App.theme.grey600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      if (_error.isNotEmpty)
                        Text(
                          _error,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: App.theme.red,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: App.theme.turquoise50,
          child: Container(
            padding: EdgeInsets.all(16),
            child: _error.isNotEmpty
                ? PrimaryLargeButton(
                    title: 'Back to Home Page',
                    iconWidget: SizedBox(),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => Home(0),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    })
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _loading
                          ? PrimaryButtonLoading()
                          : PrimaryLargeButton(
                              title: 'Confirm Details',
                              iconWidget: SizedBox(),
                              onPressed: () async {
                                setState(() {
                                  _loading = true;
                                });
                                ApiProvider _provider = new ApiProvider();
                                var booking = await _provider.createBooking();
                                if (booking != null) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return PatientNewBookingPayment(booking: booking); //PatientNewBookingVisitRequestSuccessful();
                                  }));
                                } else {
                                  setState(() {
                                    _error = ApiResponse.message;
                                    ApiResponse.message = '';
                                  });
                                }
                                setState(() {
                                  _loading = false;
                                });
                              },
                            ),
                    ],
                  ),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
