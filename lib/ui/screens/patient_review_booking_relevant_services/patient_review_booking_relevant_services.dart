import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/ui/screens/home.dart';

class PatientReviewBookingRelevantServices extends StatefulWidget {
  const PatientReviewBookingRelevantServices({Key? key}) : super(key: key);

  @override
  _PatientReviewBookingRelevantServicesState createState() => _PatientReviewBookingRelevantServicesState();
}

class _PatientReviewBookingRelevantServicesState extends State<PatientReviewBookingRelevantServices> {
  List<String> serviceTitle = ['COVID Test (H@H Travel Cert.)', 'COVID-19 Care'];

  List<String> servicePrice = [
    '\$65',
    '\$20',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: App.theme.turquoise50,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 64),
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
              SizedBox(height: 16),
              Text(
                'Add relevant secondary services',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: App.theme.grey900,
                ),
              ),
              SizedBox(height: 8),
              MediaQuery.removePadding(
                removeTop: true,
                removeBottom: true,
                context: context,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: serviceTitle.length,
                  itemBuilder: (context, index) {
                    return Container();
                    // return SecondaryServiceListCard(
                    //   callback: (){},
                    //     service: null);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
