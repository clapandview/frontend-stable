import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Box extends StatelessWidget {
  const Box({
    Key? key,
    required this.child,
    required this.height,
  }) : super(key: key);

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.all(20.r),
      child: child,
    );
  }
}
