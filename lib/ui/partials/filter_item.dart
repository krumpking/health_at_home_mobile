import 'package:flutter/material.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/service.dart';

class FilterCheckBoxItem extends StatefulWidget {
  final Service service;
  final bool isChecked;
  final StateSetter parentState;
  final StateSetter modalState;
  final Function tapped;

  const FilterCheckBoxItem(
      {Key? key, required this.service, required this.isChecked, required this.parentState, required this.modalState, required this.tapped})
      : super(key: key);

  @override
  _FilterCheckBoxItemState createState() => _FilterCheckBoxItemState();
}

class _FilterCheckBoxItemState extends State<FilterCheckBoxItem> {
  bool checked = false;

  @override
  void initState() {
    setState(() {
      checked = App.doctorSearch.serviceIds.indexOf(widget.service.id) >= 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: App.theme.grey600,
              ),
              child: Checkbox(
                checkColor: App.theme.white,
                focusColor: App.theme.white,
                activeColor: App.theme.grey600,
                value: checked,
                onChanged: (newValue) {
                  setState(() {
                    checked = newValue!;
                    if (checked == true && App.doctorSearch.serviceIds.indexOf(widget.service.id) == -1) {
                      App.doctorSearch.serviceIds.add(widget.service.id);
                    } else if (checked == false && App.doctorSearch.serviceIds.indexOf(widget.service.id) >= 0) {
                      App.doctorSearch.serviceIds.removeAt(App.doctorSearch.serviceIds.indexOf(widget.service.id));
                    }
                    widget.tapped();
                  });
                },
              ),
            ),
            Text(
              '${widget.service.name} ',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: App.theme.grey900,
              ),
            ),
          ],
        ),
        Divider(color: App.theme.grey300)
      ],
    );
  }
}

class FilterRadioItem extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const FilterRadioItem({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _FilterRadioItemState createState() => _FilterRadioItemState();
}

class _FilterRadioItemState extends State<FilterRadioItem> {
  bool checked = false;

  int _groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Radio(
                value: 1,
                groupValue: _groupValue,
                onChanged: handleRadio,
                hoverColor: Colors.yellow,
                activeColor: App.theme.turquoise,
                focusColor: Colors.green,
              ),
              Text(
                '${widget.title} ',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: App.theme.grey900,
                ),
              ),
            ],
          ),
          Divider(color: App.theme.grey300)
        ],
      ),
      onTap: widget.onPressed,
    );
  }

  void handleRadio(int? value) {
    setState(() {
      _groupValue = value!;
    });
  }
}
