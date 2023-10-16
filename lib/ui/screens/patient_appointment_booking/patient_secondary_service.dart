import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/models/service.dart';
import 'package:mobile/models/user/user.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/patient_select_list_card.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/auth/login.dart';
import 'package:mobile/ui/screens/home.dart';
import 'package:mobile/ui/screens/patient/booking/new_booking.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_new_booking_address.dart';

import '../auth/verify.code.dart';

class PatientSecondaryService extends StatefulWidget {
  final Service primaryService;

  const PatientSecondaryService({Key? key, required this.primaryService}) : super(key: key);

  @override
  _PatientSecondaryServiceState createState() => _PatientSecondaryServiceState(primaryService: primaryService);
}

class _PatientSecondaryServiceState extends State<PatientSecondaryService> {
  ApiProvider _provider = new ApiProvider();
  final Service primaryService;
  List<Service> _services = <Service>[];
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  late double _totalPrice;
  bool _loading = true;
  String _error = '';

  _PatientSecondaryServiceState({required this.primaryService});

  @override
  void initState() {
    super.initState();
    App.progressBooking!.secondaryServices = <Service>[];
    App.progressBooking!.totalPrice = primaryService.price;
    _totalPrice = App.progressBooking!.totalPrice;

    _initPage();
  }

  Future<void> _initPage() async {
    try {
      var services = await _provider.getSecondaryServices(primaryService.id);
      if (services != null) {
        setState(() {
          _services = services;
        });
      } else {
        setState(() {
          _error = ApiResponse.message;
        });
        ApiResponse.message = '';
      }
      setState(() {
        _loading = false;
      });
    } catch (_err) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load services.';
          _loading = false;
        });
      }
    }
  }

  void callBack() {
    setState(() {
      _totalPrice = App.progressBooking!.totalPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        extendBody: true,
        backgroundColor: App.theme.turquoise50,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(left: 16, top: 16, right: 16),
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
                  SizedBox(height: 24),
                  Text(
                    'Select optional secondary service(s)',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: App.theme.grey900,
                    ),
                  ),
                  SizedBox(height: 24),
                  _loading
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Center(
                            child: SizedBox(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(App.theme.turquoise!.withOpacity(0.5)),
                              ),
                              height: MediaQuery.of(context).size.height * 0.03,
                              width: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ),
                        )
                      : _error.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _error,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: App.theme.red,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await _initPage();
                                  },
                                  child: Text(
                                    'Re-try',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: App.theme.turquoise,
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Column(
                              children: [
                                MediaQuery.removePadding(
                                  removeTop: true,
                                  removeBottom: true,
                                  context: context,
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _services.length,
                                    itemBuilder: (context, index) {
                                      Service currentService = _services[index];
                                      return SecondaryServiceListCard(callback: callBack, service: currentService);
                                    },
                                  ),
                                ),
                                SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Total: \$${oCcy.format(_totalPrice)}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: App.theme.grey900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: App.theme.turquoise50,
          child: (_services.length > 0 && !_loading)
              ? Container(
                  padding: EdgeInsets.all(16),
                  child: PrimaryLargeButton(
                      title: 'Confirm Services',
                      iconWidget: SizedBox(),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          if (App.progressBooking!.bookingFlow == BookingFlow.HOME_PLUS) {
                            return PatientNewBookingAddress(isEdit: false);
                          } else {
                            return App.isLoggedIn
                                ? (User.isAuthentic(App.currentUser) && !App.currentUser.isActive)
                                    ? VerifyCode(goBack: true, uuid: App.currentUser.uuid)
                                    : PatientAppointmentNewBooking()
                                : Login(goBack: true);
                          }
                        }));
                      }))
              : Container(height: 1),
          elevation: 0,
        ),
      ),
    );
  }
}
