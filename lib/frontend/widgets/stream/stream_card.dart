import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clap_and_view/client/controllers/session_controller.dart';
import 'package:clap_and_view/client/controllers/user_controller.dart';
import 'package:clap_and_view/client/models/meta.dart';
import 'package:clap_and_view/client/models/session.dart';
import 'package:clap_and_view/client/models/stream.dart';
import 'package:clap_and_view/client/utils/config.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/pages/home/before_warch_stream_page.dart';
import 'package:clap_and_view/frontend/pages/home/watch_stream.dart';
import 'package:clap_and_view/frontend/transitions/transition_slide.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class StreamCard extends StatefulWidget {
  const StreamCard({
    Key? key,
    required this.streamModel,
  }) : super(key: key);

  final StreamModel streamModel;

  @override
  State<StreamCard> createState() => _StreamCardState();
}

class _StreamCardState extends State<StreamCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        Meta meta = Meta(
            status: 0,
            user_id: Provider.of<UserController>(context, listen: false)
                .currentUser
                .id,
            stream_id: widget.streamModel.id);
        Session session =
            Session(id: '', ts: DateTime.now(), metadata: meta, revenue: 0.0);
        Provider.of<SessionController>(context, listen: false)
            .createOne(session);
        Navigator.of(context).push(
          SlideRoute(
            page: BeforeWatchStreamPage(
              idCurrentStream: widget.streamModel.id,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: Stack(
          children: [
            CachedNetworkImage(
              height: MediaQuery.of(context).size.height,
              imageUrl:
                  "${baseUrl}stream/DownloadThumbnail/${widget.streamModel.thumbnail}",
              fit: BoxFit.cover,
              httpHeaders: {
                'authorization': 'Bearer ${GetStorage().read('token')}'
              },
            ),
            Container(
              padding: EdgeInsets.all(10.r),
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
                  DecoratedIcon(
                    ClapAndViewIcons.users_alt,
                    size: 22.r,
                    color: Colors.white,
                    shadows: const <Shadow>[
                      Shadow(
                        offset: Offset(0.0, 0.0),
                        blurRadius: 16.0,
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 5.r,
                  ),
                  AutoSizeText(
                    widget.streamModel.count.toString(),
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
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
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                padding: EdgeInsets.only(
                  left: 10.r,
                  right: 10.r,
                  bottom: kMainSpacing,
                  top: 10.r,
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
                      widget.streamModel.title,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: kMainTxtSize,
                        fontFamily: "SFProDisplaySemibold",
                        shadows: const <Shadow>[
                          Shadow(
                            offset: Offset(0.0, 0.0),
                            blurRadius: 16.0,
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.r,
                    ),
                    AutoSizeText(
                      widget.streamModel.author_username,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 16.sp,
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
