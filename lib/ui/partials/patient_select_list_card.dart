import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/service.dart';

class PatientSelectListCard extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  PatientSelectListCard({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(vertical: 4),
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
            title: Text(
              '$title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: App.theme.grey800,
              ),
            ),
            trailing: SvgPicture.asset(
              'assets/icons/icon_right_arrow.svg',
              color: App.theme.turquoise,
              width: 24,
            )),
      ),
      onTap: onPressed,
    );
  }
}

class PrimaryServiceListCard extends StatelessWidget {
  final String title;
  final String price;
  final VoidCallback onPressed;

  PrimaryServiceListCard({required this.title, required this.price, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: App.theme.white!,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '$title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: App.theme.grey800,
                    ),
                    maxLines: 3,
                  ),
                ),
                Text(
                  '$price',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: App.theme.grey400,
                  ),
                ),
              ],
            ),
            trailing: SvgPicture.asset(
              'assets/icons/icon_right_arrow.svg',
              color: App.theme.turquoise,
              width: 24,
            )),
      ),
      onTap: onPressed,
    );
  }
}

class SecondaryServiceListCard extends StatefulWidget {
  final Service service;
  final Function callback;

  SecondaryServiceListCard({
    required this.service,
    required this.callback,
  });

  @override
  State<SecondaryServiceListCard> createState() => _SecondaryServiceListCardState();
}

class _SecondaryServiceListCardState extends State<SecondaryServiceListCard> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        setState(() {
          checked = !checked;
        }),
        if (checked)
          {App.progressBooking!.totalPrice += widget.service.price, App.progressBooking!.secondaryServices.add(widget.service)}
        else
          {App.progressBooking!.totalPrice -= widget.service.price, App.progressBooking!.secondaryServices.remove(widget.service)},
        widget.callback()
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: App.theme.white!,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: App.theme.turquoise,
              ),
              child: Checkbox(
                checkColor: App.theme.white,
                focusColor: App.theme.white,
                activeColor: App.theme.turquoise,
                value: checked,
                onChanged: (newValue) {
                  setState(() {
                    checked = newValue!;
                  });
                  if (newValue!) {
                    App.progressBooking!.totalPrice += widget.service.price;
                    App.progressBooking!.secondaryServices.add(widget.service);
                  } else {
                    App.progressBooking!.totalPrice -= widget.service.price;
                    App.progressBooking!.secondaryServices.remove(widget.service);
                  }
                  widget.callback();
                },
              ),
            ),
            Expanded(
              child: Text(
                widget.service.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: App.theme.grey800,
                ),
                maxLines: 3,
                textAlign: TextAlign.start,
              ),
            ),
            Text(
              '\$${widget.service.price}',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: App.theme.grey400,
              ),
              textAlign: TextAlign.end,
            ),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
