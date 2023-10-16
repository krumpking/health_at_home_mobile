// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';

class DropDown extends StatefulWidget {
  int selectedIndex = 0;
  List<String> list;
  Function? onSelect;

  DropDown({required this.list, required this.selectedIndex, this.onSelect});

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  late String hint = 'Select';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12.0),
        decoration: BoxDecoration(
          color: App.theme.darkGrey,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: (App.theme.darkGrey)!, style: BorderStyle.solid, width: 0.1),
        ),
        child: DropdownButton(
          isDense: true,
          dropdownColor: App.theme.darkGrey,
          underline: SizedBox(),
          items: widget.list
              .map((value) => DropdownMenuItem(
                    child: Text(value, style: TextStyle(fontSize: 14, color: App.theme.white)),
                    value: value,
                  ))
              .toList(),
          icon: SvgPicture.asset('assets/icons/icon_down_caret.svg'),
          hint: Text(hint, style: TextStyle(fontSize: 16, color: App.theme.white)),
          onChanged: (String? value) {
            hint = value!;
            if (widget.onSelect != null) {
              widget.onSelect!(value);
            }
            setState(() {});
          },
          isExpanded: false,
          value: (widget.selectedIndex > 0) ? widget.list[widget.selectedIndex] : null,
        ),
      ),
    );
  }
}

class DropDownLargeLight extends StatefulWidget {
  final List<String> list;

  DropDownLargeLight({required this.list});

  @override
  _DropDownLargeLightState createState() => _DropDownLargeLightState();
}

class _DropDownLargeLightState extends State<DropDownLargeLight> {
  late String hint = 'Select';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: App.theme.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: (App.theme.white)!, style: BorderStyle.solid, width: 0.1),
      ),
      child: DropdownButton(
        isDense: false,
        dropdownColor: App.theme.white,
        underline: SizedBox(),
        items: widget.list
            .map((value) => DropdownMenuItem(
                  child: Text(value, style: TextStyle(fontSize: 14, color: App.theme.grey800)),
                  value: value,
                ))
            .toList(),
        isExpanded: true,
        icon: SvgPicture.asset('assets/icons/icon_down_caret.svg', color: App.theme.turquoise),
        hint: Row(
          children: [
            Text(hint, style: TextStyle(fontSize: 16, color: App.theme.grey600)),
          ],
        ),
        onChanged: (String? value) {
          hint = value!;
          setState(() {});
        },
        // value: _dropdownValues.first,
      ),
    );
  }
}

class DropDownLarge extends StatefulWidget {
  final List<String> list;
  late final String hint;
  late void action;

  DropDownLarge({required this.list, required this.hint, required this.action});
  @override
  _DropDownLargeState createState() => _DropDownLargeState();
}

class _DropDownLargeState extends State<DropDownLarge> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12.0),
        decoration: BoxDecoration(
          color: App.theme.darkGrey,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: (App.theme.darkGrey)!, style: BorderStyle.solid, width: 0.1),
        ),
        child: DropdownButton(
          isDense: true,
          dropdownColor: App.theme.darkGrey,
          underline: SizedBox(),
          items: widget.list
              .map((value) => DropdownMenuItem(
                    child: Text(value, style: TextStyle(fontSize: 16, color: App.theme.white, fontWeight: FontWeight.bold)),
                    value: value,
                  ))
              .toList(),
          icon: SvgPicture.asset('assets/icons/icon_down_caret.svg'),
          hint: Text(widget.hint, style: TextStyle(fontSize: 18, color: App.theme.white, fontWeight: FontWeight.bold)),
          onChanged: (String? value) {
            widget.hint = value!;
          },
          isExpanded: false,
          // value: _dropdownValues.first,
        ),
      ),
    );
  }
}
