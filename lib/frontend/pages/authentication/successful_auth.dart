import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:clap_and_view/client/deeplinking/firebase_dynamic_link.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/common_ui_elements/header.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:clap_and_view/frontend/pages/home/home.dart';
import 'package:clap_and_view/frontend/transitions/transition_fade.dart';
import 'package:clap_and_view/frontend/widgets/buttons/button.dart';
import 'package:clap_and_view/frontend/widgets/buttons/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class SuccessfulAuthPage extends StatefulWidget {
  const SuccessfulAuthPage({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  State<SuccessfulAuthPage> createState() => _SuccessfulAuthPageState();
}

class _SuccessfulAuthPageState extends State<SuccessfulAuthPage> {
  @override
  void initState() {
    super.initState();
  }

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
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(30.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/gifs/successful-auth-cat.gif",
                    width: 0.6.sw,
                  ),
                  SizedBox(
                    height: 20.w,
                  ),
                  AutoSizeText(
                    "${AppLocalizations.of(context)!.translate('successful_registration')}, ${widget.name} 🎉",
                    maxLines: 2,
                    style: TextStyle(
                      color: darkerGreyColor,
                      fontSize: kMainTxtSize * 2,
                      fontFamily: "SFProDisplayBold",
                    ),
                  ),
                  SizedBox(
                    height: 20.w,
                  ),
                  CustomButton(
                    onTap: () => Navigator.of(context).pushReplacement(
                      FadeRoute(
                        page: const HomePage(),
                      ),
                    ),
                    text: AppLocalizations.of(context)!
                        .translate('finish_registration'),
                    height: kToolbarHeight / 1.2,
                    width: MediaQuery.of(context).size.width,
                    borderRadius: 15.r,
                    color1: accentColor,
                    color2: accentColorTwo,
                    loading: false,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
