import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/app.dart';

class AppointmentReportComplete extends StatelessWidget {
  const AppointmentReportComplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Text('8AM',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: App.theme.white,
                      )),
                ),
              ),
              Expanded(flex: 4, child: Container(color: Colors.grey, height: 1)),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(),
              ),
              Expanded(
                  flex: 4,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(12),
                    padding: EdgeInsets.only(left: 0.5, top: 0.5, right: 8.5, bottom: 0.5),
                    color: (App.theme.darkBackground)!,
                    dashPattern: [4, 4],
                    strokeWidth: 1,
                    child: Container(
                      height: 68,
                      decoration: BoxDecoration(
                        color: App.theme.green,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Roger Mutizwa ',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: App.theme.white,
                                    )),
                                Text('GP',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: App.theme.white,
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset('assets/icons/icon_location.svg', width: 16, color: App.theme.white),
                                    SizedBox(width: 4),
                                    Text('Borrowdale',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: App.theme.white,
                                        )),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('REPORT COMPLETE',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: App.theme.white,
                                          decoration: TextDecoration.underline,
                                        )),
                                    SizedBox(width: 4),
                                    SvgPicture.asset('assets/icons/icon_check.svg', width: 16),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class AppointmentFillReport extends StatelessWidget {
  const AppointmentFillReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Text('8AM',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: App.theme.white,
                      )),
                ),
              ),
              Expanded(flex: 4, child: Container(color: Colors.grey, height: 1)),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(),
              ),
              Expanded(
                  flex: 4,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(12),
                    padding: EdgeInsets.only(left: 0.5, top: 0.5, right: 8.5, bottom: 0.5),
                    color: (App.theme.darkBackground)!,
                    dashPattern: [4, 4],
                    strokeWidth: 1,
                    child: Container(
                      height: 68,
                      decoration: BoxDecoration(
                        color: App.theme.purple,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Roger Mutizwa ',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: App.theme.white,
                                    )),
                                Text('GP',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: App.theme.white,
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset('assets/icons/icon_location.svg', width: 16, color: App.theme.white),
                                    SizedBox(width: 4),
                                    Text('Borrowdale',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: App.theme.white,
                                        )),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('FILL REPORT',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: App.theme.white,
                                          decoration: TextDecoration.underline,
                                        )),
                                    SizedBox(width: 4),
                                    SvgPicture.asset('assets/icons/icon_edit.svg', width: 16),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class AppointmentViewFile extends StatelessWidget {
  const AppointmentViewFile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Text('8AM',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: App.theme.white,
                      )),
                ),
              ),
              Expanded(flex: 4, child: Container(color: Colors.grey, height: 1)),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(),
              ),
              Expanded(
                  flex: 4,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(12),
                    padding: EdgeInsets.only(left: 0.5, top: 0.5, right: 8.5, bottom: 0.5),
                    color: (App.theme.darkBackground)!,
                    dashPattern: [4, 4],
                    strokeWidth: 1,
                    child: Container(
                      height: 68,
                      decoration: BoxDecoration(
                        color: App.theme.turquoise,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Roger Mutizwa ',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: App.theme.white,
                                    )),
                                Text('GP',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: App.theme.white,
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset('assets/icons/icon_location.svg', width: 16, color: App.theme.white),
                                    SizedBox(width: 4),
                                    Text('Borrowdale',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: App.theme.white,
                                        )),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('VIEW FILE',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: App.theme.white,
                                          decoration: TextDecoration.underline,
                                        )),
                                    SizedBox(width: 4),
                                    SvgPicture.asset('assets/icons/icon_file.svg', width: 16),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class AppointmentReviewClaim extends StatelessWidget {
  const AppointmentReviewClaim({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Text('8AM',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: App.theme.white,
                      )),
                ),
              ),
              Expanded(flex: 4, child: Container(color: Colors.grey, height: 1)),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(),
              ),
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.only(left: 0.5, top: 0.5, right: 8.5, bottom: 0.5),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(12),
                      padding: EdgeInsets.all(0.5),
                      color: Colors.red,
                      dashPattern: [4, 4],
                      strokeWidth: 1,
                      child: Container(
                        height: 68,
                        decoration: BoxDecoration(
                          color: App.theme.darkBackground,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Roger Mutizwa ',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: App.theme.white,
                                      )),
                                  Text('GP',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: App.theme.white,
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset('assets/icons/icon_location.svg', width: 16, color: App.theme.white),
                                      SizedBox(width: 4),
                                      Text('Borrowdale',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: App.theme.white,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('REVIEW & CLAIM',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: App.theme.white,
                                            decoration: TextDecoration.underline,
                                          )),
                                      SizedBox(width: 4),
                                      SvgPicture.asset('assets/icons/icon_like.svg', width: 16),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class AppointmentReviewConfirm extends StatelessWidget {
  const AppointmentReviewConfirm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Text('8AM',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: App.theme.white,
                      )),
                ),
              ),
              Expanded(flex: 4, child: Container(color: Colors.grey, height: 1)),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(),
              ),
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.only(left: 0.5, top: 0.5, right: 8.5, bottom: 0.5),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(12),
                      padding: EdgeInsets.all(0.5),
                      color: (App.theme.orange)!,
                      dashPattern: [4, 4],
                      strokeWidth: 1,
                      child: Container(
                        height: 68,
                        decoration: BoxDecoration(
                          color: App.theme.darkBackground,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Roger Mutizwa ',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: App.theme.white,
                                      )),
                                  Text('GP',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: App.theme.white,
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset('assets/icons/icon_location.svg', width: 16, color: App.theme.white),
                                      SizedBox(width: 4),
                                      Text('Borrowdale',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: App.theme.white,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('REVIEW & CONFIRM',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: App.theme.white,
                                            decoration: TextDecoration.underline,
                                          )),
                                      SizedBox(width: 4),
                                      SvgPicture.asset('assets/icons/icon_like.svg', width: 16),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class AppointmentNoAppointment extends StatelessWidget {
  const AppointmentNoAppointment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Text('8AM',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: App.theme.white,
                      )),
                ),
              ),
              Expanded(flex: 4, child: Container(color: Colors.grey, height: 1)),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(),
              ),
              Expanded(
                  flex: 4,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(12),
                    padding: EdgeInsets.only(left: 0.5, top: 0.5, right: 8.5, bottom: 0.5),
                    color: (App.theme.darkBackground)!,
                    dashPattern: [4, 4],
                    strokeWidth: 1,
                    child: Container(
                      height: 68,
                      decoration: BoxDecoration(
                        color: App.theme.darkBackground,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: SizedBox(),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class AppointmentNotAvailable extends StatelessWidget {
  const AppointmentNotAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Text('8AM',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: App.theme.white,
                      )),
                ),
              ),
              Expanded(flex: 4, child: Container(color: Colors.grey, height: 1)),
            ],
          ),
          SvgPicture.asset(
            'assets/icons/background_orange.svg',
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class AppointmentWeekSmall extends StatelessWidget {
  late final Color statusColor;
  late final Color borderColor;
  late final String name;

  AppointmentWeekSmall({required this.borderColor, required this.statusColor, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(12),
                    padding: EdgeInsets.only(left: 0.5, top: 0.5, right: 8.5, bottom: 0.5),
                    color: borderColor,
                    dashPattern: [4, 4],
                    strokeWidth: 1,
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(name,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: App.theme.white,
                                )),
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
