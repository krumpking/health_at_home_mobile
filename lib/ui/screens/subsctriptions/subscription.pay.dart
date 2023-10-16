import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/user/dependent.dart';
import 'package:mobile/models/user/subscriptionPackage.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/home.dart';

class SubscriptionPay extends StatefulWidget {
  final SubscriptionPackage subscriptionPackage;
  final Dependent dependant;
  final bool isRenewal;
  const SubscriptionPay({Key? key, required this.subscriptionPackage, required this.dependant, required this.isRenewal}) : super(key: key);

  @override
  _SubscriptionPayState createState() => _SubscriptionPayState();
}

class _SubscriptionPayState extends State<SubscriptionPay> {
  ApiProvider provider = new ApiProvider();
  late String error = '';
  late bool loading = false;
  List<int> periodOptions = [1, 2, 3, 6, 12];
  String periodHint = 'Select a period';
  late int selectedPeriod = 0;
  late int selectedPackageId = 0;
  final int statusThreshold = 60;
  late int timerIteration = 0;
  late int paymentId = 0;
  late Timer? timer;
  late bool paymentSuccess = false;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _initPage() async {}

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.turquoise50,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: App.theme.turquoise50,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: App.theme.turquoise,
                                size: 24,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            Text(
                              'Make Payment',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: App.theme.grey900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Beneficiary"),
                      SizedBox(height: 5),
                      Text(
                        "${widget.dependant.firstName} ${widget.dependant.lastName} ${widget.dependant.isSelf ? '(YOU)' : ''}",
                        style: TextStyle(
                          color: App.theme.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text("Medical Plan"),
                      SizedBox(height: 5),
                      Text(
                        widget.subscriptionPackage.name,
                        style: TextStyle(
                          color: App.theme.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text("Price"),
                      SizedBox(height: 5),
                      Text(
                        "\$${widget.subscriptionPackage.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: App.theme.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: paymentSuccess ? Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    'Payment was successful',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: App.theme.green,
                    ),
                  ),
                ],
              ),) : Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (error.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(height: 16),
                        Text(
                          error,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: App.theme.red,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: App.theme.white,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: (App.theme.white)!, style: BorderStyle.solid, width: 0.1),
                          ),
                          child: DropdownButton(
                            isDense: false,
                            dropdownColor: App.theme.white,
                            underline: SizedBox(),
                            items: periodOptions
                                .map((value) => DropdownMenuItem(
                                      child: Text("${value.toString()} ${value > 1 ? 'Months' : 'Month'}",
                                          style: TextStyle(fontSize: 14, color: App.theme.grey800)),
                                      value: value,
                                    ))
                                .toList(),
                            isExpanded: true,
                            icon: SvgPicture.asset('assets/icons/icon_down_caret.svg', color: App.theme.turquoise),
                            hint: Row(
                              children: [
                                Text(
                                  periodHint,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: App.theme.grey600,
                                  ),
                                ),
                              ],
                            ),
                            onChanged: (int? value) {
                              periodHint = "${value!.toString()} ${value > 1 ? 'Months' : 'Month'}";
                              setState(() {
                                periodHint = "${value.toString()} ${value > 1 ? 'Months' : 'Month'}";
                                selectedPeriod = value;
                              });
                            },
                            // value: _dropdownValues.first,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  loading
                      ? PrimaryButtonLoading()
                      : PrimaryLargeButton(
                          title: 'Make Payment',
                          iconWidget: SizedBox(),
                          onPressed: () async {
                            if (selectedPeriod > 0) {
                              setState(() {
                                loading = true;
                              });

                              var result = await provider.paySubscription(
                                subscriptionPackage: widget.subscriptionPackage,
                                dependant: widget.dependant,
                                period: selectedPeriod,
                                method: 'card',
                                isRenewal: widget.isRenewal,
                              );

                              if (result != null) {
                                if (result.containsKey('redirectUrl') && result['redirectUrl'] != null) {
                                  paymentId = result['paymentId'];

                                  App.launchURL(result['redirectUrl']);

                                  timer = Timer.periodic(Duration(seconds: 10), (Timer t) async {
                                    print('Timer running....');
                                    if (statusThreshold > timerIteration && paymentId > 0) {
                                      var result = await provider.checkPaymentStatus(paymentId: paymentId, type: 'subscription');

                                      if (result.containsKey('status') && result['status'] != null && int.parse(result['status'].toString()) == 3) {
                                        setState(() {
                                          paymentSuccess = true;
                                        });
                                        timer!.cancel();
                                        t.cancel();
                                      }
                                    } else {
                                      print('Timer cancelling....');
                                      timer!.cancel();
                                      t.cancel();
                                      setState(() {
                                        loading = false;
                                        error = 'Payment timed out';
                                      });
                                    }

                                    timerIteration++;
                                  });
                                }
                              }

                              setState(() {
                                error = ApiResponse.message;
                              });
                            }
                          },
                        ),
                ],
              )),
          elevation: 0,
        ),
      ),
    );
  }
}
