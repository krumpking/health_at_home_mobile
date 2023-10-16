import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/user/dependent.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/ui/partials/button.dart';
import 'package:mobile/ui/partials/status_navigator_widget.dart';
import 'package:mobile/ui/screens/subsctriptions/subscription.apply.dart';
import 'package:mobile/ui/screens/subsctriptions/subscription.details.dart';

class MyMedicalPlans extends StatefulWidget {
  const MyMedicalPlans({Key? key}) : super(key: key);

  @override
  _MyMedicalPlansState createState() => _MyMedicalPlansState();
}

class _MyMedicalPlansState extends State<MyMedicalPlans> {
  ApiProvider _provider = new ApiProvider();
  List<Dependent> _dependents = <Dependent>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  Future<void> _initPage() async {
    setState(() {
      _loading = true;
    });
    var dependants = await _provider.getDependents();
    if (dependants != null) {
      setState(() {
        _dependents = dependants;
      });
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LightStatusNavigationBarWidget(
      child: Scaffold(
        backgroundColor: App.theme.turquoise50,
        body: SafeArea(
          child: Column(
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
                          Text(
                            'Medical Plans',
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
              Expanded(
                child: Container(
                  child: _loading
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
                            child: SizedBox(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(App.theme.green!.withOpacity(0.5)),
                              ),
                              height: MediaQuery.of(context).size.height * 0.03,
                              width: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ),
                        )
                      : _dependents.length < 1
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Text(
                                "You have not set up any dependents.",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            )
                          : MediaQuery.removePadding(
                              removeTop: true,
                              removeBottom: true,
                              context: context,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _dependents.length,
                                itemBuilder: (context, index) {
                                  Dependent dependent = _dependents[index];
                                  return Container(
                                    margin: EdgeInsets.only(top: 16),
                                    padding: EdgeInsets.symmetric(horizontal: 12),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                      decoration: BoxDecoration(
                                        color: App.theme.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${dependent.firstName} ${dependent.lastName}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: App.theme.darkerText,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                "${dependent.isSelf ? 'Me' : dependent.relationship}".toUpperCase(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: App.theme.darkerText!.withOpacity(0.4),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${!dependent.hasSubscription() ? 'No Plan' : (dependent.isSubscriptionValid() ? 'Active' : 'Payment Due')}",
                                                style: TextStyle(
                                                  color: dependent.isSubscriptionValid() ? App.theme.green : App.theme.red,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              dependent.hasSubscription()
                                                  ? SuccessExtraSmallButton(
                                                      title: "Manage",
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) {
                                                            return SubscriptionDetails(
                                                              dependent: dependent,
                                                              subscriptionId: dependent.subscription!.id,
                                                            );
                                                          }),
                                                        );
                                                      },
                                                    )
                                                  : PrimaryExtraSmallButton(
                                                      title: "Subscribe",
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) {
                                                            return SubscriptionApplication(dependent: dependent);
                                                          }),
                                                        );
                                                      },
                                                    ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
