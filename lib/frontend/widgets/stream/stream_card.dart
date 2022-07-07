import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clap_and_view/client/utils/config.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class StreamCard extends StatefulWidget {
  const StreamCard({
    Key? key,
    required this.thumb,
    required this.title,
    required this.name,
    required this.viewsCount,
  }) : super(key: key);

  final String thumb;
  final String title;
  final String name;
  final int viewsCount;

  @override
  State<StreamCard> createState() => _StreamCardState();
}

class _StreamCardState extends State<StreamCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Stack(
        children: [
          CachedNetworkImage(
            height: MediaQuery.of(context).size.height,
            imageUrl: "${baseUrl}stream/DownloadThumbnail/${widget.thumb}",
            fit: BoxFit.cover,
            httpHeaders: {
              'authorization': 'Bearer ${GetStorage().read('token')}'
            },
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.25),
                  Colors.black.withOpacity(0.0),
                ],
              ),
            ),
            child: Row(
              children: [
                const DecoratedIcon(
                  ClapAndViewIcons.users_alt,
                  size: 22.0,
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 16.0,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 5.0,
                ),
                AutoSizeText(
                  widget.viewsCount.toString(),
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: "SFProDisplayMedium",
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0.0, 0.0),
                        blurRadius: 16.0,
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                bottom: 20.0,
                top: 10.0,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.25),
                    Colors.black.withOpacity(0.0),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    widget.title,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontFamily: "SFProDisplaySemibold",
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(0.0, 0.0),
                          blurRadius: 16.0,
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  AutoSizeText(
                    widget.name,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 16.0,
                      fontFamily: "SFProDisplayMedium",
                      shadows: const <Shadow>[
                        Shadow(
                          offset: Offset(0.0, 0.0),
                          blurRadius: 16.0,
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
