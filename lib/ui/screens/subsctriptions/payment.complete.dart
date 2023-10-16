import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/user/dependent.dart';
import 'package:mobile/models/user/subscriptionPackage.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/subsctriptions/subscription.pay.dart';

class PaymentComplete extends StatefulWidget {
  final Dependent dependent;
  const PaymentComplete({Key? key, required this.dependent}) : super(key: key);

  @override
  _PaymentCompleteState createState() => _PaymentCompleteState();
}

class _PaymentCompleteState extends State<PaymentComplete> {
  ApiProvider provider = new ApiProvider();
  List<SubscriptionPackage> packages = <SubscriptionPackage>[];
  late String error = '';
  late bool loading = false;
  late bool loadedPackages = false;
  late int selectedSubscriptionPackageId = 0;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  Future<void> _initPage() async {
    var remotePackages = await provider.getAvailablePackages();
    if (remotePackages != null) {
      setState(() {
        packages = remotePackages;
      });
    }
    setState(() {
      loadedPackages = true;
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
                              'Choose a Plan',
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
                      loadedPackages
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MediaQuery.removePadding(
                                  removeTop: true,
                                  removeBottom: true,
                                  context: context,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: packages.length,
                                    itemBuilder: (context, index) {
                                      SubscriptionPackage package = packages[index];
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedSubscriptionPackageId = package.id!;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: App.theme.white,
                                            border: Border.all(
                                                color: selectedSubscriptionPackageId == package.id! ? App.theme.turquoise! : App.theme.white!,
                                                style: BorderStyle.solid,
                                                width: 1.5),
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                selectedSubscriptionPackageId == package.id!
                                                    ? Icons.check_circle_outline_rounded
                                                    : Icons.circle_outlined,
                                                color: selectedSubscriptionPackageId == package.id! ? App.theme.turquoise : App.theme.lightGreyColor,
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          package.name,
                                                          style: TextStyle(
                                                            color: App.theme.grey,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          "\$${package.price.toStringAsFixed(2)}",
                                                          style: TextStyle(
                                                            color: App.theme.grey,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      package.description,
                                                      style: TextStyle(
                                                        color: App.theme.grey!.withOpacity(0.7),
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
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
            child: loading
                ? PrimaryButtonLoading()
                : selectedSubscriptionPackageId > 0
                    ? PrimaryLargeButton(
                        title: 'Continue to Payment',
                        iconWidget: SizedBox(),
                        onPressed: () async {
                          SubscriptionPackage package = packages.where((element) => element.id == selectedSubscriptionPackageId).first;
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return SubscriptionPay(
                                subscriptionPackage: package,
                                dependant: widget.dependent,
                                isRenewal: false,
                              );
                            }),
                          );
                        },
                      )
                    : SizedBox(height: 1),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
