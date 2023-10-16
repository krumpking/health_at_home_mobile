import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';

class MyMenuItem extends StatefulWidget {
  final String menuTitle;
  final String menuSubtitle;
  final VoidCallback onPressed;
  final Color? color;
  final bool enabled;

  const MyMenuItem({Key? key, required this.menuTitle, required this.menuSubtitle, required this.onPressed, this.color, required this.enabled})
      : super(key: key);

  @override
  _MyMenuItemState createState() => _MyMenuItemState();
}

class _MyMenuItemState extends State<MyMenuItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 3),
          RichText(
            text: TextSpan(
              text: '${widget.menuTitle} ',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: 0.18,
                color: widget.color != null
                    ? widget.color
                    : widget.enabled == true
                        ? App.theme.turquoise
                        : App.theme.turquoise!.withOpacity(0.4),
              ),
              children: <TextSpan>[
                TextSpan(
                    text: '${widget.menuSubtitle}',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: App.theme.mutedLightColor,
                    )),
              ],
            ),
          ),
          SizedBox(height: 8),
          Divider(color: App.theme.lightGreyColor)
        ],
      ),
      onTap: widget.enabled == true ? widget.onPressed : () {},
    );
  }
}
