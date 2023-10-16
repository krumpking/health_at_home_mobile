import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';
import 'package:mobile/models/booking_notification.dart';
import 'package:mobile/providers/utilities.dart';

class DoctorNotificationCard extends StatefulWidget {
  final BookingNotification notification;

  DoctorNotificationCard({required this.notification});

  @override
  _DoctorNotificationCardState createState() => _DoctorNotificationCardState();
}

class _DoctorNotificationCardState extends State<DoctorNotificationCard> {
  late BookingNotification _notification;
  late Color _badgeColor = App.theme.purple!;
  late String _badgeText;
  late String _actionText = '';
  late String _actionImage = '';
  late String _action = '';

  @override
  void initState() {
    super.initState();

    setState(() {
      _notification = widget.notification;
      _badgeText = _notification.booking.primaryService.name;

      if (_notification.title.toLowerCase().contains('report reminder')) {
        _badgeColor = App.theme.green!;
      } else if (_notification.title.toLowerCase().contains('appointment request')) {
        _badgeColor = App.theme.turquoise!;
        _actionText = 'review & confirm';
        _actionImage = 'icon_like.svg';
        _action = 'review';
        if (!_notification.isEmergency) {
          _badgeText = _notification.booking.primaryService.name.length > 10
              ? _notification.booking.primaryService.name.substring(0, 10) + ' (YOU)'
              : _notification.booking.primaryService.name + ' (YOU';
          _badgeColor = App.theme.orange!;
        } else {
          _badgeText = _notification.booking.primaryService.name.length > 10
              ? _notification.booking.primaryService.name.substring(0, 10) + ' (anyone Asap)'
              : _notification.booking.primaryService.name + ' (anyone Asap)';
        }
      } else if (!_notification.title.toLowerCase().contains('status change')) {
        _actionText = 'Confirm';
        _actionImage = 'icon_check.svg';
      } else if (_notification.title.toLowerCase().contains('status change')) {
        if (_notification.booking.status.toLowerCase() == 'cancelled') {
          _badgeColor = Colors.red;
        } else {
          _badgeColor = App.theme.purple!;
        }
        _badgeText = _notification.booking.status.toUpperCase();
      }

      if (_notification.title.toLowerCase().contains('appointment request') && _notification.booking.status.toLowerCase() != 'pending') {
        _actionImage = '';
        _actionText = 'View Appointment';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, top: 8, right: 16),
      padding: !_notification.opened
          ? EdgeInsets.all(16)
          : EdgeInsets.only(
              bottom: 16,
            ),
      decoration: BoxDecoration(
        color: !_notification.opened ? App.theme.grey700 : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _notification.title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: App.theme.white,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: _badgeColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    _badgeText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: App.theme.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/icons/icon_clock.svg'),
                  SizedBox(width: 8),
                  Text(
                    Utilities.getTimeLapseBooking(_notification.booking),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: App.theme.mutedLightColor,
                    ),
                  ),
                ],
              ),
              Text(
                Utilities.displayTimeAgoFromTimestamp(_notification.createdAt),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: App.theme.mutedLightColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/icons/icon_location.svg', color: App.theme.mutedLightColor, width: 14),
                  SizedBox(width: 8),
                  Text(
                    _notification.booking.address.length > 18
                        ? _notification.booking.address.substring(0, 18) + '...'
                        : _notification.booking.address,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: App.theme.mutedLightColor,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (_actionText.isNotEmpty)
                    Row(
                      children: [
                        Text(
                          _actionText.toUpperCase(),
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: App.theme.white, decoration: TextDecoration.underline),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                  if (_actionImage.isNotEmpty) SvgPicture.asset('assets/icons/$_actionImage', color: App.theme.white, width: 14),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
