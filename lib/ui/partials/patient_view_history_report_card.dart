import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';

class PatientViewHistoryListCard extends StatelessWidget {
  final String doctorName;
  final String services;
  final String patient;
  final String total;
  final String bookingDate;
  final VoidCallback onPressed;

  PatientViewHistoryListCard(
      {required this.doctorName,
      required this.services,
      required this.patient,
      required this.total,
      required this.onPressed,
      required this.bookingDate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: App.theme.white!,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bookingDate,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: App.theme.grey900,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '$doctorName',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: App.theme.grey800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Services: $services',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: App.theme.grey600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Patient: $patient',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: App.theme.grey600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Total: $total',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: App.theme.grey600,
                ),
              ),
              SizedBox(height: 8),
              OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  side: BorderSide(width: 2, color: (App.theme.turquoise)!),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'View Doctor`s Report',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: App.theme.turquoise,
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
