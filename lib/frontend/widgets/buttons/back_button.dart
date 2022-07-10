import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io' show Platform;

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton(
      {Key? key,
      required this.onTap,
      required this.text,
      required this.loading,
      required this.icon,
      required this.fontSize,
      required this.color})
      : super(key: key);

  final GestureTapCallback onTap;
  final String text;
  final bool loading;
  final IconData icon;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 28.r,
            ),
            (loading)
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
                    style: TextStyle(
                        fontSize: fontSize,
                        color: color,
                        fontFamily: "SFProDisplaySemibold"),
                  )
          ],
        ),
      ),
    );
  }
}
