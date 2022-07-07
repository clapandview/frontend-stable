import 'package:auto_size_text/auto_size_text.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.isSettings,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final bool isSettings;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (isSettings)
            ? const SizedBox(
                height: 20.0,
              )
            : SizedBox(
                height: kToolbarHeight * 2,
                width: MediaQuery.of(context).size.width,
              ),
        AutoSizeText(
          AppLocalizations.of(context)!.translate(title),
          maxLines: 2,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 36.0,
            fontFamily: "SFProDisplaySemibold",
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        AutoSizeText(
          AppLocalizations.of(context)!.translate(subtitle),
          maxLines: 2,
          style: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontSize: 18.0,
            fontFamily: "SFProDisplayMedium",
          ),
        ),
        const SizedBox(
          height: 40.0,
        ),
      ],
    );
  }
}
