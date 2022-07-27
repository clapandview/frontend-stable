import 'package:clap_and_view/frontend/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.keyboardType,
    required this.text,
    required this.cap,
    required this.maxLines,
    required this.minLines,
    required this.maxLength,
    required this.borderRadius,
    required this.colorTextMain,
    required this.colorTextHover,
    required this.colorMain,
    required this.onChanged,
    required this.list,
    required this.letterSpacing,
    this.onSubmitted,
    this.cursorColor,

    // for android
    this.enableSuggestions,
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputType keyboardType;
  final String text;
  final TextCapitalization cap;
  final int maxLines;
  final int minLines;
  final int maxLength;
  final double borderRadius;
  final Color colorTextMain;
  final Color colorTextHover;
  final Color colorMain;
  final List<TextInputFormatter> list;
  final double letterSpacing;
  final Function(String) onChanged;
  final Function(String)? onSubmitted;
  final bool? enableSuggestions;
  final Color? cursorColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(
        fontSize: kMainTxtSize,
        letterSpacing: letterSpacing,
        fontFamily: "SFProDisplayMedium",
        color: colorTextMain,
      ),
      keyboardType: keyboardType,
      cursorColor: (cursorColor == null)
          ? (colorMain != darkGreyColor)
              ? accentColorTwo
              : Colors.white
          : cursorColor,
      textCapitalization: cap,
      maxLines: (maxLines == 0) ? null : maxLines,
      minLines: minLines,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      onChanged: onChanged,
      inputFormatters: list,
      onSubmitted: onSubmitted,
      enableSuggestions: enableSuggestions == null ? false : true,
      decoration: InputDecoration(
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: colorMain, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: colorMain, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: colorMain, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: colorMain, width: 2.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: colorMain, width: 2.0),
        ),
        filled: true,
        fillColor: colorMain,
        contentPadding: EdgeInsets.all(12.r),
        isCollapsed: true,
        hintText: text,
        hintStyle: TextStyle(
          fontSize: kMainTxtSize,
          letterSpacing: letterSpacing,
          fontFamily: "SFProDisplayMedium",
          color: colorTextHover,
        ),
      ),
    );
  }
}
