import 'package:flutter/material.dart';

class CustomCircleButton extends StatelessWidget {
  const CustomCircleButton({
    Key? key,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: kToolbarHeight / 1.2,
        width: kToolbarHeight / 1.2,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.75),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
