import 'dart:io';

import 'package:ant_media_flutter/ant_media_flutter.dart';
import 'package:clap_and_view/client/controllers/category_controller.dart';
import 'package:clap_and_view/client/controllers/stream_controller.dart';
import 'package:clap_and_view/client/controllers/user_controller.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/masks/gradient_mask.dart';
import 'package:clap_and_view/frontend/pages/authentication/auth.dart';
import 'package:clap_and_view/frontend/pages/home/feed.dart';
import 'package:clap_and_view/frontend/pages/home/publish_stream.dart';
import 'package:clap_and_view/frontend/pages/home/search.dart';
import 'package:clap_and_view/frontend/pages/home/settings.dart';
import 'package:clap_and_view/frontend/transitions/transition_slide.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.isLoggedIn}) : super(key: key);

  final bool isLoggedIn;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  List<IconData> icons = [
    ClapAndViewIcons.estate,
    ClapAndViewIcons.search,
    ClapAndViewIcons.plus_circle,
    ClapAndViewIcons.user,
  ];

  late List<Widget> pages = [
    const FeedPage(),
    const SearchPage(),
    const PublishStreamPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    AntMediaFlutter.requestPermissions();
    if (Platform.isAndroid) {
      AntMediaFlutter.startForegroundService();
    }
    Provider.of<UserController>(context, listen: false).loadFirstPage();
    Provider.of<BroadcastController>(context, listen: false)
        .loadFirstPageSmart("", "");
    Provider.of<CategoryController>(context, listen: false).loadCategories();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarIconBrightness: (selectedIndex == pages.length - 1)
              ? Brightness.dark
              : Brightness.light,
          statusBarBrightness: (selectedIndex == pages.length - 1)
              ? Brightness.light
              : Brightness.dark,
          statusBarColor: (selectedIndex == pages.length - 1)
              ? Colors.white
              : darkerGreyColor,
        ),
        child: Scaffold(
          backgroundColor: (selectedIndex == pages.length - 1)
              ? Colors.white
              : darkerGreyColor,
          body: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: pages,
                      ),
                    ),
                    Container(
                      height: kBottomNavigationBarHeight,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                        left: 15.r,
                        right: 15.r,
                      ),
                      color: (selectedIndex == pages.length - 1)
                          ? Colors.white
                          : darkerGreyColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List<Widget>.generate(
                          pages.length,
                          (int index) {
                            return GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                if (widget.isLoggedIn ||
                                    index == 0 ||
                                    index == 1) {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                  _pageController.jumpToPage(index);
                                } else if (index == 2 || index == 3) {
                                  Navigator.of(context).push(
                                    SlideRoute(
                                      page: const AuthPage(),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                color: Colors.transparent,
                                height: kBottomNavigationBarHeight,
                                width:
                                    (MediaQuery.of(context).size.width - 30.r) /
                                        pages.length,
                                child: (selectedIndex == pages.length - 1)
                                    ? (selectedIndex == index)
                                        ? RadiantGradientMask(
                                            child: Icon(
                                              icons[index],
                                              color: Colors.white,
                                            ),
                                          )
                                        : Icon(
                                            icons[index],
                                            color:
                                                Colors.black.withOpacity(0.3),
                                          )
                                    : Icon(
                                        icons[index],
                                        color: (selectedIndex == index)
                                            ? Colors.white
                                            : lightGreyColor,
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).padding.bottom,
                  color: (selectedIndex == pages.length - 1)
                      ? Colors.white
                      : darkerGreyColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
