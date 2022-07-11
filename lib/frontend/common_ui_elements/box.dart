import 'package:clap_and_view/frontend/constants.dart';
import 'package:flutter/material.dart';

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
      padding: EdgeInsets.all(kMainSpacing),
      child: child,
    );
  }
}
