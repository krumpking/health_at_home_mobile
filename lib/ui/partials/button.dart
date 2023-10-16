import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';

class PrimaryLargeButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final Widget iconWidget;

  const PrimaryLargeButton({Key? key, required this.title, required this.onPressed, required this.iconWidget}) : super(key: key);

  @override
  _PrimaryLargeButtonState createState() => _PrimaryLargeButtonState();
}

class _PrimaryLargeButtonState extends State<PrimaryLargeButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: App.theme.white,
              ),
            ),
            widget.iconWidget,
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: App.theme.white,
        backgroundColor: App.theme.turquoise,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      onPressed: widget.onPressed,
    );
  }
}

class PrimaryLargeButtonDisabled extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const PrimaryLargeButtonDisabled({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _PrimaryLargeButtonDisabledState createState() => _PrimaryLargeButtonDisabledState();
}

class _PrimaryLargeButtonDisabledState extends State<PrimaryLargeButtonDisabled> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: App.theme.grey400,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: App.theme.grey200,
              onPrimary: App.theme.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            onPressed: widget.onPressed,
          ),
        ),
      ],
    );
  }
}

class PrimaryRegularButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const PrimaryRegularButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _PrimaryRegularButtonState createState() => _PrimaryRegularButtonState();
}

class _PrimaryRegularButtonState extends State<PrimaryRegularButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: App.theme.white,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: App.theme.turquoise,
              onPrimary: App.theme.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            onPressed: widget.onPressed,
          ),
        ),
      ],
    );
  }
}

class PrimarySmallLoadingButton extends StatefulWidget {
  const PrimarySmallLoadingButton({Key? key}) : super(key: key);

  @override
  _PrimarySmallLoadingButtonState createState() => _PrimarySmallLoadingButtonState();
}

class _PrimarySmallLoadingButtonState extends State<PrimarySmallLoadingButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13.0),
              child: SizedBox(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(App.theme.white!),
                  strokeWidth: 3,
                ),
                height: 14,
                width: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: App.theme.turquoise,
              onPrimary: App.theme.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            onPressed: null,
          ),
        ),
      ],
    );
  }
}

class PrimarySmallButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const PrimarySmallButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _PrimarySmallButtonState createState() => _PrimarySmallButtonState();
}

class _PrimarySmallButtonState extends State<PrimarySmallButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: App.theme.white,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: App.theme.turquoise,
              onPrimary: App.theme.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            onPressed: widget.onPressed,
          ),
        ),
      ],
    );
  }
}

class LanguagePillButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const LanguagePillButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _LanguagePillButtonState createState() => _LanguagePillButtonState();
}

class _LanguagePillButtonState extends State<LanguagePillButton> {
  bool _selected = false;
  late String title;

  @override
  void initState() {
    super.initState();
    setState(() {
      title = widget.title.trim();
    });
    if (App.currentUser.doctorProfile!.languages.indexOf(widget.title) >= 0) {
      setState(() {
        _selected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Container(
        height: 40,
        child: ElevatedButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${widget.title} ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _selected == true ? App.theme.white : App.theme.mutedLightColor,
                ),
              ),
              SvgPicture.asset(_selected == true ? 'assets/icons/icon_remove.svg' : 'assets/icons/icon_plus.svg',
                  color: _selected == true ? App.theme.white : App.theme.mutedLightColor, width: 18)
            ],
          ),
          style: ElevatedButton.styleFrom(
            primary: _selected == true ? App.theme.turquoise : App.theme.grey700,
            onPrimary: App.theme.white,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
          ),
          onPressed: () {
            setState(() {
              _selected = !_selected;
            });

            List<String> _languages =
                App.currentUser.doctorProfile!.languages.isNotEmpty ? App.currentUser.doctorProfile!.languages.split(', ') : <String>[];
            int index = _languages.indexOf(title);

            if (_selected == true) {
              if (index == -1) {
                _languages.add(title);
                App.currentUser.doctorProfile!.languages = _languages.join(', ');
              }
            } else {
              if (index != -1) {
                setState(() {
                  _languages.removeAt(index);
                });
                App.currentUser.doctorProfile!.languages = _languages.join(', ');
              }
            }
            widget.onPressed();
          },
        ),
      ),
    );
  }
}

class SpecialisationPillButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const SpecialisationPillButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _SpecialisationPillButtonState createState() => _SpecialisationPillButtonState();
}

class _SpecialisationPillButtonState extends State<SpecialisationPillButton> {
  bool _selected = false;
  late String title;

  @override
  void initState() {
    super.initState();
    setState(() {
      title = widget.title.trim();
    });
    if (App.currentUser.doctorProfile!.specialities.split(', ').indexOf(widget.title) >= 0) {
      setState(() {
        _selected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Container(
        height: 40,
        child: ElevatedButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${widget.title} ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _selected == true ? App.theme.white : App.theme.mutedLightColor,
                ),
              ),
              SvgPicture.asset(_selected == true ? 'assets/icons/icon_remove.svg' : 'assets/icons/icon_plus.svg',
                  color: _selected == true ? App.theme.white : App.theme.mutedLightColor, width: 18)
            ],
          ),
          style: ElevatedButton.styleFrom(
            primary: _selected == true ? App.theme.turquoise : App.theme.grey700,
            onPrimary: App.theme.white,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
          ),
          onPressed: () {
            setState(() {
              _selected = !_selected;
            });
            List<String> _specialisations =
                App.currentUser.doctorProfile!.specialities.isNotEmpty ? App.currentUser.doctorProfile!.specialities.split(', ') : <String>[];
            int index = _specialisations.indexOf(title);

            if (_selected == true) {
              if (index == -1) {
                _specialisations.add(title);
                App.currentUser.doctorProfile!.specialities = _specialisations.join(', ');
              }
            } else {
              if (index != -1) {
                setState(() {
                  _specialisations.removeAt(index);
                });
                App.currentUser.doctorProfile!.specialities = _specialisations.join(', ');
              }
            }
            widget.onPressed();
          },
        ),
      ),
    );
  }
}

class PrimaryPillButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const PrimaryPillButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _PrimaryPillButtonState createState() => _PrimaryPillButtonState();
}

class _PrimaryPillButtonState extends State<PrimaryPillButton> {
  bool _selected = false;

  @override
  void initState() {
    if (App.progressReport.checks.contains(widget.title)) {
      setState(() {
        _selected = true;
      });
    }
    if (App.progressReport.symptoms.contains(widget.title)) {
      setState(() {
        _selected = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Container(
        height: 40,
        child: ElevatedButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${widget.title} ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _selected == true ? App.theme.white : App.theme.mutedLightColor,
                ),
              ),
              SvgPicture.asset(_selected == true ? 'assets/icons/icon_remove.svg' : 'assets/icons/icon_plus.svg',
                  color: _selected == true ? App.theme.white : App.theme.mutedLightColor, width: 18)
            ],
          ),
          style: ElevatedButton.styleFrom(
            primary: _selected == true ? App.theme.turquoise : App.theme.grey700,
            onPrimary: App.theme.white,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
          ),
          onPressed: () {
            setState(() {
              _selected = !_selected;
            });
            widget.onPressed();
          },
        ),
      ),
    );
  }
}

class SecondaryPillButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const SecondaryPillButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _SecondaryPillButtonState createState() => _SecondaryPillButtonState();
}

class _SecondaryPillButtonState extends State<SecondaryPillButton> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Container(
        height: 36,
        child: ElevatedButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${widget.title} ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: _selected == true ? App.theme.white : App.theme.grey500,
                ),
              ),
              SvgPicture.asset(_selected == true ? 'assets/icons/icon_remove.svg' : 'assets/icons/icon_plus.svg',
                  color: _selected == true ? App.theme.white : App.theme.grey500, width: 18)
            ],
          ),
          style: ElevatedButton.styleFrom(
              primary: _selected == true ? App.theme.turquoise : App.theme.white,
              onPrimary: App.theme.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
              elevation: 0),
          onPressed: () {
            setState(() {
              _selected = !_selected;
            });
            widget.onPressed();
          },
        ),
      ),
    );
  }
}

class SecondarySelectButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const SecondarySelectButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _SecondarySelectButtonState createState() => _SecondarySelectButtonState();
}

class _SecondarySelectButtonState extends State<SecondarySelectButton> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Container(
        height: 36,
        child: ElevatedButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${widget.title} ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: _selected == true ? App.theme.white : App.theme.grey500,
                ),
              ),
              SvgPicture.asset(_selected == true ? 'assets/icons/icon_carret_up.svg' : 'assets/icons/icon_carret_down.svg',
                  color: _selected == true ? App.theme.white : App.theme.grey500, width: 18)
            ],
          ),
          style: ElevatedButton.styleFrom(
              primary: _selected == true ? App.theme.turquoise : App.theme.white,
              onPrimary: App.theme.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
              elevation: 0),
          onPressed: () {
            // setState(() {
            //   _selected = !_selected;
            // });
            widget.onPressed();
          },
        ),
      ),
    );
  }
}

class PrimaryExtraSmallIconButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const PrimaryExtraSmallIconButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _PrimaryExtraSmallIconButtonState createState() => _PrimaryExtraSmallIconButtonState();
}

class _PrimaryExtraSmallIconButtonState extends State<PrimaryExtraSmallIconButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: App.theme.white,
              ),
            ),
            SizedBox(width: 8),
            SvgPicture.asset(
              'assets/icons/icon_edit.svg',
              width: 16,
            ),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: App.theme.turquoise,
        onPrimary: App.theme.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      onPressed: widget.onPressed,
    );
  }
}

class PrimaryExtraSmallButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const PrimaryExtraSmallButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _PrimaryExtraSmallButtonState createState() => _PrimaryExtraSmallButtonState();
}

class _PrimaryExtraSmallButtonState extends State<PrimaryExtraSmallButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          widget.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: App.theme.white,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: App.theme.white,
        backgroundColor: App.theme.turquoise,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      onPressed: widget.onPressed,
    );
  }
}

class SuccessExtraSmallButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const SuccessExtraSmallButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _SuccessExtraSmallButtonState createState() => _SuccessExtraSmallButtonState();
}

class _SuccessExtraSmallButtonState extends State<SuccessExtraSmallButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          widget.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: App.theme.white,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: App.theme.white,
        backgroundColor: App.theme.green,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      onPressed: widget.onPressed,
    );
  }
}

class SecondaryButtonLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: SizedBox(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(App.theme.white!),
                    strokeWidth: 3,
                  ),
                  height: 27,
                  width: 27,
                )),
            style: ElevatedButton.styleFrom(
              primary: App.theme.red500,
              onPrimary: App.theme.errorRedColor,
              elevation: 0,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class PrimaryButtonLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: SizedBox(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(App.theme.white!),
                    strokeWidth: 3,
                  ),
                  height: 27,
                  width: 27,
                )),
            style: ElevatedButton.styleFrom(
              primary: App.theme.turquoise,
              onPrimary: App.theme.white,
              elevation: 0,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class SecondaryStandardButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const SecondaryStandardButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _SecondaryStandardButtonState createState() => _SecondaryStandardButtonState();
}

class _SecondaryStandardButtonState extends State<SecondaryStandardButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: App.theme.darkBackground,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: App.theme.btnDarkSecondary,
              onPrimary: App.theme.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
            onPressed: widget.onPressed,
          ),
        ),
      ],
    );
  }
}

class TertiaryStandardButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const TertiaryStandardButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _TertiaryStandardButtonState createState() => _TertiaryStandardButtonState();
}

class _TertiaryStandardButtonState extends State<TertiaryStandardButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: SvgPicture.asset(
              'assets/icons/icon_location.svg',
              color: App.theme.turquoise,
              width: 20,
              height: 20,
            ),
            style: ElevatedButton.styleFrom(
                primary: App.theme.darkBackground,
                onPrimary: App.theme.darkBackground,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                side: BorderSide(color: Color(0xFF137EA0), width: 2)),
            onPressed: widget.onPressed,
            label: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: App.theme.turquoise,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class TertiarySmallButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const TertiarySmallButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _TertiarySmallButtonState createState() => _TertiarySmallButtonState();
}

class _TertiarySmallButtonState extends State<TertiarySmallButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        side: BorderSide(width: 2, color: (App.theme.turquoise)!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: App.theme.turquoise,
          ),
        ),
      ),
    );
  }
}

class SecondaryLargeButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const SecondaryLargeButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _SecondaryLargeButtonState createState() => _SecondaryLargeButtonState();
}

class _SecondaryLargeButtonState extends State<SecondaryLargeButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: App.theme.darkBackground,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              foregroundColor: App.theme.white,
              backgroundColor: App.theme.btnDarkSecondary,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
            onPressed: widget.onPressed,
          ),
        ),
      ],
    );
  }
}

class DisabledLargeButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const DisabledLargeButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _DisabledLargeButtonState createState() => _DisabledLargeButtonState();
}

class _DisabledLargeButtonState extends State<DisabledLargeButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: App.theme.lightText,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: App.theme.disabledButton,
              onPrimary: App.theme.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
            onPressed: widget.onPressed,
          ),
        ),
      ],
    );
  }
}

class PrimaryOutlineStandardButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const PrimaryOutlineStandardButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _PrimaryOutlineStandardButtonState createState() => _PrimaryOutlineStandardButtonState();
}

class _PrimaryOutlineStandardButtonState extends State<PrimaryOutlineStandardButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              side: BorderSide(width: 2, color: (App.theme.turquoise)!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: App.theme.turquoise,
                ),
              ),
            ),
            onPressed: widget.onPressed,
          ),
        ),
      ],
    );
  }
}

class PrimaryOutlineLargeButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const PrimaryOutlineLargeButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _PrimaryOutlineLargeButtonState createState() => _PrimaryOutlineLargeButtonState();
}

class _PrimaryOutlineLargeButtonState extends State<PrimaryOutlineLargeButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: OutlinedButton(
          onPressed: widget.onPressed,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            side: BorderSide(width: 1, color: (App.theme.turquoise)!),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: App.theme.turquoise,
              ),
            ),
          ),
        )),
      ],
    );
  }
}

class DangerRegularButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const DangerRegularButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _DangerRegularButtonState createState() => _DangerRegularButtonState();
}

class _DangerRegularButtonState extends State<DangerRegularButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: App.theme.white,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: App.theme.red500,
              onPrimary: App.theme.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            onPressed: widget.onPressed,
          ),
        ),
      ],
    );
  }
}

class DangerRegularLoadingButton extends StatefulWidget {
  const DangerRegularLoadingButton({Key? key}) : super(key: key);

  @override
  _DangerRegularLoadingButtonState createState() => _DangerRegularLoadingButtonState();
}

class _DangerRegularLoadingButtonState extends State<DangerRegularLoadingButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: null,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(App.theme.white!),
                  strokeWidth: 3,
                ),
                height: 27,
                width: 27,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: App.theme.red500,
              onPrimary: App.theme.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
        ),
      ],
    );
  }
}

class SuccessRegularButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const SuccessRegularButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _SuccessRegularButtonState createState() => _SuccessRegularButtonState();
}

class _SuccessRegularButtonState extends State<SuccessRegularButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: App.theme.white,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: App.theme.green500,
              onPrimary: App.theme.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            onPressed: widget.onPressed,
          ),
        ),
      ],
    );
  }
}

class SuccessLargeButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const SuccessLargeButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _SuccessLargeButtonState createState() => _SuccessLargeButtonState();
}

class _SuccessLargeButtonState extends State<SuccessLargeButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: App.theme.white,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: App.theme.green500,
              onPrimary: App.theme.white,
              elevation: 0,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            onPressed: widget.onPressed,
          ),
        ),
      ],
    );
  }
}

class TertiaryEditSmallButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const TertiaryEditSmallButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _TertiaryEditSmallButtonState createState() => _TertiaryEditSmallButtonState();
}

class _TertiaryEditSmallButtonState extends State<TertiaryEditSmallButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: widget.onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        side: BorderSide(width: 1, color: (App.theme.turquoise)!),
      ),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SvgPicture.asset('assets/icons/icon_edit.svg', width: 16, color: App.theme.turquoise),
              SizedBox(width: 8),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: App.theme.turquoise,
                ),
              ),
            ],
          )),
    );
  }
}

class DangerLargeButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const DangerLargeButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  _DangerLargeButtonState createState() => _DangerLargeButtonState();
}

class _DangerLargeButtonState extends State<DangerLargeButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: App.theme.white,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: App.theme.red500,
              onPrimary: App.theme.errorRedColor,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            onPressed: widget.onPressed,
          ),
        ),
      ],
    );
  }
}
