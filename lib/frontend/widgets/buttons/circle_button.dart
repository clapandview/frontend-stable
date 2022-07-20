import 'package:flutter/material.dart';

class CustomCircleButton extends StatelessWidget {
  const CustomCircleButton({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.color,
    required this.colorIcon,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final IconData icon;
  final Color color;
  final Color colorIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: kToolbarHeight / 1.2,
        width: kToolbarHeight / 1.2,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            color: colorIcon,
          ),
        ),
      ),
    );
  }
}
