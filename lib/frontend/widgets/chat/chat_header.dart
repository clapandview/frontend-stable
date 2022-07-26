import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clap_and_view/client/models/user.dart';
import 'package:clap_and_view/client/utils/config.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ChatHeader extends StatelessWidget {
  final User user;

  const ChatHeader({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: kToolbarHeight,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 40),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(15.0),
          ),
          color: darkerGreyColor,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                color: Colors.transparent,
                width: kToolbarHeight / 1.5,
                height: kToolbarHeight / 1.5,
                child: const Center(
                  child: Icon(
                    ClapAndViewIcons.angle_left_no_space,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: AutoSizeText(
                user.name,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).textScaleFactor * 20.0,
                  color: lighterGreyColor,
                  fontFamily: "SFProDisplaySemibold",
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ClipOval(
              child: CachedNetworkImage(
                width: kToolbarHeight / 1.5,
                height: kToolbarHeight / 1.5,
                fit: BoxFit.cover,
                imageUrl:
                    baseUrl + "user/DownloadProfilePic/${user.profile_pic}",
                httpHeaders: {
                  'authorization': 'Bearer ${GetStorage().read('token')}'
                },
              ),
            )
          ],
        ),
      );
}
