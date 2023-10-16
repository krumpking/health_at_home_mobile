// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';

class SuppliesCard extends StatefulWidget {
  final String title;
  Function? onTap;
  SuppliesCard({required this.title, this.onTap});

  @override
  _SuppliesCardState createState() => _SuppliesCardState();
}

class _SuppliesCardState extends State<SuppliesCard> {
  var suppliesAmount = 0;
  var topThirdColor = App.theme.darkGrey;
  var centerThirdColor = App.theme.darkGrey;
  var bottomThirdColor = App.theme.darkGrey;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: GestureDetector(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: App.theme.green,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: (App.theme.darkGrey)!, style: BorderStyle.solid, width: 0),
              ),
              child: Column(
                children: [
                  Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: topThirdColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                    ),
                  ),
                  Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: centerThirdColor,
                    ),
                  ),
                  Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: bottomThirdColor,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: App.theme.white,
                      ),
                    ),
                    Text(
                      '$suppliesAmount',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: App.theme.white,
                      ),
                    ),
                  ],
                )),
          ],
        ),
        onTap: () {
          suppliesAmount++;
          print(suppliesAmount);
          if (suppliesAmount == 0) {
            setState(() {
              topThirdColor = App.theme.darkGrey;
              centerThirdColor = App.theme.darkGrey;
              bottomThirdColor = App.theme.darkGrey;
            });
          } else if (suppliesAmount == 1) {
            setState(() {
              topThirdColor = App.theme.darkGrey;
              centerThirdColor = App.theme.darkGrey;
              bottomThirdColor = App.theme.green;
            });
          } else if (suppliesAmount == 2) {
            setState(() {
              topThirdColor = App.theme.darkGrey;
              centerThirdColor = App.theme.orange;
              bottomThirdColor = App.theme.orange;
            });
          } else if (suppliesAmount == 3) {
            setState(() {
              topThirdColor = App.theme.red500;
              centerThirdColor = App.theme.red500;
              bottomThirdColor = App.theme.red500;
            });
          } else if (suppliesAmount == 4) {
            setState(() {
              suppliesAmount = 0;
              topThirdColor = App.theme.darkGrey;
              centerThirdColor = App.theme.darkGrey;
              bottomThirdColor = App.theme.darkGrey;
            });
          }

          if (widget.onTap != null) {
            widget.onTap!(suppliesAmount, widget.title);
          }
        },
      ),
    );
  }
}
