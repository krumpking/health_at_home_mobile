import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/providers/utilities.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';

class PatientNewBookingVisitRequestSuccessful extends StatefulWidget {
  const PatientNewBookingVisitRequestSuccessful({Key? key}) : super(key: key);

  @override
  _PatientNewBookingVisitRequestSuccessfulState createState() => _PatientNewBookingVisitRequestSuccessfulState();
}

class _PatientNewBookingVisitRequestSuccessfulState extends State<PatientNewBookingVisitRequestSuccessful> {
  final oCcy = new NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    super.initState();

    //FirebaseMessaging.instance.sendMessage()
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/icon_big_check.svg',
                            height: 80,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Visit Request Successful!',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 23,
                              color: App.theme.grey900,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32),
                      App.progressBooking!.bookingCriteria == BookingCriteria.ASAP
                          ? Text(
                              'Your Visit request has been sent to all available practitioners for confirmation. We’ll notify you once it’s been claimed.\n\nYou can view and change this booking from the home page until it has been accepted, at which point changes and cancellations will not be possible.',
                              textAlign: TextAlign.start,
                              maxLines: 10,
                              softWrap: true,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: App.theme.grey600,
                              ),
                            )
                          : Column(
                              children: [
                                Text(
                                  'Your Visit request has been sent to Dr. ${Utilities.convertToTitleCase(App.progressBooking!.selectedDoctor!.displayName)} for confirmation. We’ll notify you once it’s been confirmed.\n\nYou can view and change this booking from the home page.',
                                  textAlign: TextAlign.start,
                                  maxLines: 10,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: App.theme.grey600,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(App.progressBooking!.selectedDoctor!.profileImg != null
                                          ? App.progressBooking!.selectedDoctor!.profileImg!
                                          : 'https://via.placeholder.com/140x100'),
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
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                      SizedBox(height: 24),
                      Text(
                        'Address',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: App.theme.grey900,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        App.progressBooking!.address,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: App.theme.grey600,
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
                              mainAxisAlignment: MainAxisAlignment.start,
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
                              ],
                            ),
                          ],
                        ),
                      SizedBox(height: 16),
                      Text(
                        'Total',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: App.theme.grey900,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '\$${oCcy.format(App.progressBooking!.totalPrice)}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: App.theme.grey600,
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
              child: PrimaryLargeButton(
                  title: 'Go Home',
                  iconWidget: SizedBox(),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home(0)),
                      (Route<dynamic> route) => false,
                    );
                  })),
          elevation: 0,
        ),
      ),
    );
  }
}
