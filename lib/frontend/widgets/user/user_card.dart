import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class UserCard extends StatefulWidget {
  const UserCard({
    Key? key,
    required this.thumb,
    required this.name,
    required this.bio,
    required this.onTap,
  }) : super(key: key);

  final String thumb;
  final String name;
  final String bio;
  final VoidCallback onTap;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                width: kToolbarHeight,
                height: kToolbarHeight,
                fit: BoxFit.cover,
                imageUrl: widget.thumb,
                httpHeaders: {
                  'authorization': 'Bearer ${GetStorage().read('token')}'
                },
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    widget.name,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontFamily: "SFProDisplaySemibold",
                    ),
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  AutoSizeText(
                    widget.bio,
                    maxLines: 1,
                    style: TextStyle(
                      color: lightGreyColor,
                      fontSize: 16.0,
                      fontFamily: "SFProDisplayMedium",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
