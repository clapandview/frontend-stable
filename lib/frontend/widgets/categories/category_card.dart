import 'package:auto_size_text/auto_size_text.dart';
import 'package:clap_and_view/client/models/category.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.category,
    required this.isSelected,
  }) : super(key: key);

  final Hashtag category;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(30.0),
        ),
        color: (isSelected) ? darkGreyColor : Colors.transparent,
      ),
      child: Center(
        child: AutoSizeText(
          (category.name == "all" || category.name == "subscriptions")
              ? AppLocalizations.of(context)!.translate(category.name)
              : "${category.emoji}   ${category.name}",
          maxLines: 1,
          style: TextStyle(
            color: (isSelected) ? Colors.white : lightGreyColor,
            fontSize: 18.0,
            fontFamily:
                (isSelected) ? "SFProDisplaySemibold" : "SFProDisplayMedium",
          ),
        ),
      ),
    );
  }
}
