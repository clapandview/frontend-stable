import 'package:auto_size_text/auto_size_text.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:clap_and_view/frontend/pages/home/search.dart';
import 'package:clap_and_view/frontend/transitions/transition_slide.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoFeedPage extends StatefulWidget {
  const VideoFeedPage({Key? key}) : super(key: key);

  @override
  State<VideoFeedPage> createState() => _VideoFeedPageState();
}

class _VideoFeedPageState extends State<VideoFeedPage> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.r),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: kToolbarHeight,
            padding: const EdgeInsets.only(right: 5.0, left: 5.0),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: kToolbarHeight,
                  width: kToolbarHeight,
                ),
                AutoSizeText(
                  AppLocalizations.of(context)!.translate('home'),
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontFamily: "SFProDisplayBold",
                    shadows: const <Shadow>[
                      Shadow(
                        offset: Offset(0.0, 0.0),
                        blurRadius: 16.0,
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    SlideRoute(
                      page: const SearchPage(),
                    ),
                  ),
                  child: Container(
                    color: Colors.transparent,
                    height: kToolbarHeight,
                    width: kToolbarHeight,
                    child: Center(
                      child: DecoratedIcon(
                        size: 25.w,
                        ClapAndViewIcons.search,
                        color: Colors.white,
                        shadows: const <Shadow>[
                          Shadow(
                            offset: Offset(0.0, 0.0),
                            blurRadius: 16.0,
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
