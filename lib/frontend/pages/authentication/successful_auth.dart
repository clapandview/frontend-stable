import 'package:auto_size_text/auto_size_text.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:clap_and_view/frontend/pages/home/home.dart';
import 'package:clap_and_view/frontend/transitions/transition_fade.dart';
import 'package:clap_and_view/frontend/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(
                  "${AppLocalizations.of(context)!.translate('successful_registration')}, ${widget.name} 🎉",
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: darkerGreyColor,
                    fontSize: kMainTxtSize * 1.5,
                    fontFamily: "SFProDisplayBold",
                  ),
                ),
                SizedBox(
                  height: 40.r,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    "assets/gifs/successful-auth-cat.gif",
                    width: 0.6.sw,
                  ),
                ),
                SizedBox(
                  height: 40.r,
                ),
                CustomButton(
                  onTap: () => Navigator.of(context).pushReplacement(
                    FadeRoute(
                      page: const HomePage(),
                    ),
                  ),
                  text: AppLocalizations.of(context)!
                      .translate('finish_registration'),
                  height: kToolbarHeight / 1.3,
                  width: MediaQuery.of(context).size.width,
                  borderRadius: 15.r,
                  color1: accentColor,
                  color2: accentColorTwo,
                  loading: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
