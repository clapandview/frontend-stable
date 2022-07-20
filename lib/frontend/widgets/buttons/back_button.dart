import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: Colors.transparent,
        height: kToolbarHeight,
        width: kToolbarHeight,
        child: Icon(
          ClapAndViewIcons.angle_left_no_space,
          color: color,
        ),
      ),
    );
  }
}
