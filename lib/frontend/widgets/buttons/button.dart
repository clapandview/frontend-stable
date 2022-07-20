import 'package:auto_size_text/auto_size_text.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io' show Platform;

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.height,
    required this.width,
    required this.borderRadius,
    required this.color1,
    required this.color2,
    required this.loading,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final String text;
  final double height;
  final double width;
  final double borderRadius;
  final Color color1;
  final Color color2;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          color: accentColor,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color1,
              color2,
            ],
          ),
        ),
        child: Center(
          child: (loading)
              ? (Platform.isIOS)
                  ? const CupertinoActivityIndicator(
                      color: Colors.white,
                    )
                  : const SizedBox(
                      height: kToolbarHeight / 2.0,
                      width: kToolbarHeight / 2.0,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.0,
                      ),
                    )
              : AutoSizeText(
                  text,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: kMainTxtSize,
                    fontFamily: "SFProDisplaySemibold",
                  ),
                ),
        ),
      ),
    );
  }
}
