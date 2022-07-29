import 'dart:math';

import 'package:clap_and_view/client/deeplinking/firebase_dynamic_link.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/common_ui_elements/header.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:clap_and_view/frontend/widgets/buttons/button.dart';
import 'package:clap_and_view/frontend/widgets/buttons/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late String tgCode;

  @override
  void initState() {
    tgCode = getRandomString(30);
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(kMainSpacing),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: kToolbarHeight / 1.2,
                      width: kToolbarHeight / 1.2,
                    ),
                    CustomCircleButton(
                      onTap: () => Navigator.of(context).pop(),
                      icon: ClapAndViewIcons.multiply,
                      color: lighterGreyColor,
                      colorIcon: Colors.black,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding:
                      EdgeInsets.only(left: kMainSpacing, right: kMainSpacing),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const Header(
                      title: 'hi_lets_get_to_know_each_other',
                      subtitle: 'register_to_access_more_functions',
                      isSettings: false,
                    ),
                    SizedBox(
                      height: kMainSpacing,
                    ),
                    CustomButton(
                      onTap: authTelegram,
                      text: AppLocalizations.of(context)!
                          .translate('auth_with_tg'),
                      height: kToolbarHeight / 1.2,
                      width: MediaQuery.of(context).size.width,
                      borderRadius: 15.r,
                      color1: telegramColor,
                      color2: telegramColorTwo,
                      loading: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  authTelegram() {
    final Uri url =
        Uri.parse('https://t.me/clapandview_dev_bot/?start=$tgCode');
    launchUrl(url, mode: LaunchMode.externalApplication);
  }

  getLinks() async {
    await FirebaseDynamicListService.initTgAuth(context, tgCode);
  }

  String getRandomString(int length) {
    const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    final Random r = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => ch.codeUnitAt(
          r.nextInt(ch.length),
        ),
      ),
    );
  }
}
