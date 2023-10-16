import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking/booking.dart';
import 'package:mobile/ui/partials/supplies_card.dart';

class DoctorReportingFlowScreenE extends StatefulWidget {
  final Booking booking;
  const DoctorReportingFlowScreenE({Key? key, required this.booking}) : super(key: key);

  @override
  _DoctorReportingFlowScreenEState createState() => _DoctorReportingFlowScreenEState();
}

class _DoctorReportingFlowScreenEState extends State<DoctorReportingFlowScreenE> {
  List<String> suppliesList = [
    '2 O Nylon,\n90mm',
    '2 O Nylon,\n90mm',
    '2 O Vycril\nCutting',
    '3-Ply Face\nMask',
    'Adalimubab,\n40mg',
    'Adco-dol,\n20S',
    'Benzathine\nPenicillin',
    'Betadine\nsolution, 100ml',
    'Cannula,\nBlue, 22g',
    'Cannula,\nGreen, 18g',
    'Cannula,\nYellow, 24g',
    'Catheter',
    'Ceftriaxone, 1g',
    'Clean, 40mg',
    'Clonazepam,\n0.25mg',
    'Cloxacillin,\n1g',
    'Codeline\nPhosphate',
    'Cotton Wool,\n125g',
    'COVID Swab',
    'Crepe bandage,\n150mm',
    'Crepe bandage,\n100mm',
    'Crepe bandage,\n75mm',
    'Crepe bandage,\n50mm',
    'Dexamethasone\nInjection, 8mg',
    'Dextrose,\n1l 5%',
    'Diclofenac,\n75mg',
    'Disposable\nGown',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Which supplies did you use?',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: App.theme.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Tap to add and remove supplies',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: App.theme.mutedLightColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Common Supplies',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: App.theme.white,
                ),
              ),
              SizedBox(height: 8),
              MediaQuery.removePadding(
                removeTop: true,
                removeBottom: true,
                context: context,
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    mainAxisExtent: 60,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: List.generate(suppliesList.length, (index) {
                    return SuppliesCard(
                      title: suppliesList[index],
                      onTap: (int amount, String title) {
                        List<String> supplies = <String>[];
                        if (App.progressReport.supplies.isNotEmpty) {
                          supplies = App.progressReport.supplies.split(',, ');
                        }
                        title = title.replaceAll('\n', ' ');
                        supplies.remove(title + ' => ' + (amount - 1).toString());
                        String supply = title + ' => ' + amount.toString();
                        if (amount > 0) {
                          supplies.add(supply);
                        } else {
                          supplies.remove(title + ' => ' + 3.toString());
                        }
                        App.progressReport.supplies = supplies.join(',, ');
                      },
                    );
                  }),
                ),
              ),
              SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Is something missing? ',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: App.theme.mutedLightColor,
                      ),
                    ),
                    TextSpan(
                      text: 'Contact Us ',
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: App.theme.turquoise, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          await App.launchURL(
                              "https://docs.google.com/forms/d/e/1FAIpQLScL5tEgEYNYYNhomKVuApW4yR6VwCg7UsQ2FAuSVsUasqevBg/viewform?usp=sf_link");
                        },
                    ),
                    TextSpan(
                      text: 'to request additions to the list.',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: App.theme.mutedLightColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
