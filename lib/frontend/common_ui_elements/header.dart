import 'package:auto_size_text/auto_size_text.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.isSettings,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final bool isSettings;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (isSettings)
            ? SizedBox(
                height: kMainSpacing,
              )
            : SizedBox(
                height: kToolbarHeight * 2,
                width: MediaQuery.of(context).size.width,
              ),
        AutoSizeText(
          AppLocalizations.of(context)!.translate(title),
          maxLines: 2,
          style: TextStyle(
            color: Colors.black,
            fontSize: 36.sp,
            fontFamily: "SFProDisplaySemibold",
          ),
        ),
        SizedBox(
          height: kMainSpacing,
        ),
        AutoSizeText(
          AppLocalizations.of(context)!.translate(subtitle),
          maxLines: 2,
          style: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontSize: kMainTxtSize,
            fontFamily: "SFProDisplayMedium",
          ),
        ),
        SizedBox(
          height: 40.r,
        ),
      ],
    );
  }
}
