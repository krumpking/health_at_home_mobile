import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/models/service.dart';
import 'package:mobile/models/user/user.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/ui/partials/patient_select_list_card.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/auth/login.dart';
import 'package:mobile/ui/screens/home.dart';
import 'package:mobile/ui/screens/patient/booking/new_booking.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_new_booking_address.dart';
import 'package:mobile/ui/screens/patient_appointment_booking/patient_secondary_service.dart';

import '../auth/verify.code.dart';

class PatientPrimaryService extends StatefulWidget {
  const PatientPrimaryService({Key? key}) : super(key: key);

  @override
  _PatientPrimaryServiceState createState() => _PatientPrimaryServiceState();
}

class _PatientPrimaryServiceState extends State<PatientPrimaryService> {
  ApiProvider _provider = new ApiProvider();
  final oCcy = new NumberFormat("#,##0", "en_US");
  List<Service> _services = <Service>[];
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    _initPage();
    super.initState();
  }

  Future<void> _initPage() async {
    setState(() {
      _error = '';
      _loading = true;
    });
    try {
      var services = await _provider.getServices();
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
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
                    'Select your primary service',
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
                          : MediaQuery.removePadding(
                              removeTop: true,
                              context: context,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _services.length,
                                itemBuilder: (context, index) {
                                  Service currentService = _services[index];
                                  if (!currentService.isPrimary) return Container();
                                  return PrimaryServiceListCard(
                                      title: currentService.name,
                                      price: '\$${oCcy.format(currentService.price)}',
                                      onPressed: () {
                                        App.progressBooking!.primaryService = currentService;
                                        if (currentService.additionalServices.length < 1) {
                                          App.progressBooking!.totalPrice = currentService.price;
                                        }
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          if (App.progressBooking!.bookingFlow == BookingFlow.HOME_PLUS) {
                                            return (currentService.additionalServices.length > 0)
                                                ? PatientSecondaryService(primaryService: currentService)
                                                : PatientNewBookingAddress(isEdit: false);
                                          } else {
                                            return (currentService.additionalServices.length > 0)
                                                ? PatientSecondaryService(primaryService: currentService)
                                                : App.isLoggedIn
                                                    ? (User.isAuthentic(App.currentUser) && !App.currentUser.isActive)
                                                        ? VerifyCode(uuid: App.currentUser.uuid)
                                                        : PatientAppointmentNewBooking()
                                                    : Login(goBack: true);
                                          }
                                        }));
                                      });
                                },
                              ),
                            ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
