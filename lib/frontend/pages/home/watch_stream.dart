import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:clap_and_view/frontend/widgets/buttons/button.dart';
import 'package:clap_and_view/frontend/widgets/buttons/circle_button.dart';
import 'package:flutter/material.dart';

class WatchStreamPage extends StatefulWidget {
  const WatchStreamPage({
    Key? key,
    required this.id,
    required this.isPublisher,
  }) : super(key: key);

  final String id;
  final bool isPublisher;

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
            Positioned(
              bottom: kMainSpacing,
              left: kMainSpacing,
              right: kMainSpacing,
              child: CustomButton(
                onTap: () {},
                text:
                    AppLocalizations.of(context)!.translate('finish_broadcast'),
                height: kToolbarHeight / 1.2,
                width: MediaQuery.of(context).size.width,
                borderRadius: 15.0,
                loading: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
