import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';

class TimeSelectButton extends StatefulWidget {
  final String title;
  final Function onPressed;

  const TimeSelectButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _TimeSelectButtonState createState() => _TimeSelectButtonState();
}

class _TimeSelectButtonState extends State<TimeSelectButton> {
  bool _selected = false;
  late Timer timer;

  @override
  void initState() {
    setState(() {
      timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
        var selectedTime = App.progressBooking!.startTime;
        _selected = selectedTime == widget.title;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        child: ElevatedButton(
          child: Text(
            '${widget.title} ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _selected == true ? App.theme.grey800 : App.theme.grey800,
            ),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: _selected == true ? App.theme.btnDarkSecondary : App.theme.grey300,
            onPrimary: App.theme.white,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
          onPressed: () {
            setState(() {
              _selected = !_selected;
            });
            App.progressBooking!.startTime = widget.title;
            widget.onPressed(_selected);
          },
        ),
      ),
    );
  }
}
