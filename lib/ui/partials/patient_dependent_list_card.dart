import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/ui/partials/button.dart';

class PatientDependentListCard extends StatelessWidget {
  final String name;
  final String age;
  final String sex;
  final String relationship;
  final VoidCallback onPressed;

  PatientDependentListCard({required this.name, required this.age, required this.sex, required this.relationship, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: App.theme.white!,
          boxShadow: [
            BoxShadow(
              color: App.theme.turquoise!.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(2, 2), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: App.theme.grey800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Age: $age',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: App.theme.grey600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sex: $sex',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: App.theme.grey600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Relationship: $relationship',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: App.theme.grey600,
                  ),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/icon_right_arrow.svg',
                  color: App.theme.turquoise,
                  width: 24,
                ),
              ],
            )),
      ),
      onTap: onPressed,
    );
  }
}

class PatientDependentEditListCard extends StatelessWidget {
  final String name;
  final String age;
  final String sex;
  final String relationship;
  final VoidCallback onPressed;

  PatientDependentEditListCard({required this.name, required this.age, required this.sex, required this.relationship, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: App.theme.white!,
        boxShadow: [
          BoxShadow(
            color: App.theme.turquoise!.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(2, 2), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: App.theme.grey800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Age: $age',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: App.theme.grey600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sex: $sex',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: App.theme.grey600,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Relationship: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: App.theme.grey600,
                      ),
                    ),
                    Text(
                      relationship,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: App.theme.grey800,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Spacer(),
                TertiaryEditSmallButton(
                  title: 'Edit',
                  onPressed: onPressed,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
