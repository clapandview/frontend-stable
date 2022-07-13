import 'package:auto_size_text/auto_size_text.dart';
import 'package:clap_and_view/client/models/user.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
              SizedBox(
                height: kToolbarHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        color: Colors.transparent,
                        height: kToolbarHeight,
                        width: kToolbarHeight,
                        child: const Icon(
                          ClapAndViewIcons.angle_left_no_space,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    AutoSizeText(
                      "@${widget.user.username}",
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: kMainTxtSize,
                        fontFamily: "SFProDisplaySemibold",
                      ),
                    ),
                    const SizedBox(
                      height: kToolbarHeight,
                      width: kToolbarHeight,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
