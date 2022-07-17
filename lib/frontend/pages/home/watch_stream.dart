import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/widgets/buttons/circle_button.dart';
import 'package:flutter/material.dart';

class WatchStreamPage extends StatefulWidget {
  const WatchStreamPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  State<WatchStreamPage> createState() => _WatchStreamPageState();
}

class _WatchStreamPageState extends State<WatchStreamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkerGreyColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Stream Here
            Positioned(
              top: kMainSpacing,
              right: kMainSpacing,
              child: CustomCircleButton(
                onTap: () => Navigator.of(context).pop(),
                icon: ClapAndViewIcons.multiply,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
