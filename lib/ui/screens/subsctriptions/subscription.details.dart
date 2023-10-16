import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/user/dependent.dart';
import 'package:mobile/models/user/subscription.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/api_response.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/subsctriptions/subscription.pay.dart';

class SubscriptionDetails extends StatefulWidget {
  final int subscriptionId;
  final Dependent dependent;
  const SubscriptionDetails({Key? key, required this.subscriptionId, required this.dependent}) : super(key: key);

  @override
  _SubscriptionDetailsState createState() => _SubscriptionDetailsState();
}

class _SubscriptionDetailsState extends State<SubscriptionDetails> {
  ApiProvider provider = new ApiProvider();
  late Subscription subscription;
  late String error = '';
  late bool loading = false;
  late bool unsubLoading = false;
  late bool loadedDetails = false;
  late int selectedSubscriptionPackageId = 0;
  final format = DateFormat.yMMMd();

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  Future<void> _initPage() async {
    var sub = await provider.getSubscription(id: widget.subscriptionId);
    if (sub != null) {
      setState(() {
        subscription = sub;
      });
    }
    setState(() {
      loadedDetails = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.turquoise50,
        body: SafeArea(
          child: Container(
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
                              'Subscription',
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
                    children: [
                      if (error.isNotEmpty)
                        Column(
                          children: [
                            Text(
                              error,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                                color: App.theme.red,
                              ),
                            ),
                          ],
                        ),
                      loadedDetails
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: App.theme.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Dependent",
                                        style: TextStyle(
                                          color: App.theme.darkerText,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${widget.dependent.firstName} ${widget.dependent.lastName}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "${widget.dependent.isSelf ? '(ME)' : widget.dependent.relationship}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: App.theme.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Plan",
                                        style: TextStyle(
                                          color: App.theme.darkerText,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${subscription.package.name}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "\$${subscription.package.price.toStringAsFixed(2)}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Remaining Visits",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "${subscription.remainingVisits}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Payment Due",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            format.format(subscription.expiresOn),
                                            style: TextStyle(
                                              color: widget.dependent.isSubscriptionValid() ? App.theme.green : App.theme.red,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: SizedBox(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(App.theme.turquoise!),
                                  strokeWidth: 3,
                                ),
                                height: 24,
                                width: 24,
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
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            child: loadedDetails
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      subscription.paymentDue
                          ? PrimaryLargeButton(
                              title: "Make Payment",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SubscriptionPay(
                                        subscriptionPackage: subscription.package,
                                        dependant: widget.dependent,
                                        isRenewal: true,
                                      );
                                    },
                                  ),
                                );
                              },
                              iconWidget: SizedBox(),
                            )
                          : SizedBox(height: 1),
                      SizedBox(height: 8),
                      SecondaryLargeButton(
                        title: "Un-Subscribe",
                        onPressed: () async {
                          _warnDialog();
                        },
                      ),
                    ],
                  )
                : SizedBox(height: 1),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Future<void> _warnDialog() async {
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
                SvgPicture.asset(
                  'assets/icons/icon_warning.svg',
                  height: 40,
                ),
                SizedBox(height: 24),
                Text(
                  'Are you sure?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: App.theme.red),
                ),
                SizedBox(height: 16),
                Text(
                  'This subscription and all data associated with it will be removed permanently',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: App.theme.darkText),
                ),
                SizedBox(height: 16),
                unsubLoading
                    ? DangerRegularLoadingButton()
                    : DangerRegularButton(
                        title: 'Yes, Un-Subscribe',
                        onPressed: () async {
                          setState(() {
                            unsubLoading = true;
                          });

                          var result = await provider.unSubscription(subscriptionId: subscription.id, dependantId: widget.dependent.id!);

                          if (result != null) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }

                          setState(() {
                            error = ApiResponse.message;
                            unsubLoading = false;
                          });
                        },
                      ),
                SizedBox(height: 20),
                InkWell(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: App.theme.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
