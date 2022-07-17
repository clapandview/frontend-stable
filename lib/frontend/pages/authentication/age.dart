import 'package:auto_size_text/auto_size_text.dart';
import 'package:clap_and_view/frontend/common_ui_elements/box.dart';
import 'package:clap_and_view/frontend/common_ui_elements/header.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:clap_and_view/frontend/widgets/buttons/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_machine/time_machine.dart';

import 'dart:io' show Platform;

class AgePage extends StatefulWidget {
  const AgePage({Key? key}) : super(key: key);

  @override
  State<AgePage> createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  DateTime date = DateTime(
      DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Box(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              child: Column(
                children: [
                  const Header(
                    title: 'tell_me_more_about_yourself',
                    subtitle: 'how_old_are_you',
                    isSettings: false,
                  ),
                  GestureDetector(
                    onTap: () => (Platform.isIOS)
                        ? _showDialog(
                            CupertinoDatePicker(
                              initialDateTime: date,
                              mode: CupertinoDatePickerMode.date,
                              use24hFormat: true,
                              maximumDate: date,
                              onDateTimeChanged: (DateTime newDate) {
                                setState(() => date = newDate);
                              },
                            ),
                          )
                        : _selectDate(context),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: kToolbarHeight / 1.2,
                      padding: EdgeInsets.only(
                        left: 15.r,
                        right: 15.r,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: lighterGreyColor,
                          width: 2.r,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.r),
                        ),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            convertToAge().toString() +
                                AppLocalizations.of(context)!
                                    .translate('years_old'),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: kMainTxtSize,
                              fontFamily: "SFProDisplayMedium",
                            ),
                          ),
                          AutoSizeText(
                            '${date.month}-${date.day}-${date.year}',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: kMainTxtSize,
                              fontFamily: "SFProDisplayMedium",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: kMainSpacing,
                  ),
                  CustomButton(
                    onTap: setAge,
                    text: AppLocalizations.of(context)!.translate('continue'),
                    height: kToolbarHeight / 1.2,
                    width: MediaQuery.of(context).size.width,
                    borderRadius: 15.r,
                    loading: loading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setAge() async {}

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(
          DateTime.now().year - 150, DateTime.now().month, DateTime.now().day),
      lastDate: date,
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  int convertToAge() {
    LocalDate now = LocalDate.today();
    LocalDate bDate = LocalDate.dateTime(date);
    return now.periodSince(bDate).years;
  }
}
