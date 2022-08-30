import 'dart:io';
import 'dart:math';

import 'package:ant_media_flutter/ant_media_flutter.dart';
import 'package:clap_and_view/client/controllers/category_controller.dart';
import 'package:clap_and_view/client/controllers/stream_controller.dart';
import 'package:clap_and_view/client/controllers/user_controller.dart';
import 'package:clap_and_view/client/deeplinking/firebase_dynamic_link.dart';
import 'package:clap_and_view/client/models/user.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/masks/gradient_mask.dart';
import 'package:clap_and_view/frontend/pages/authentication/auth.dart';
import 'package:clap_and_view/frontend/pages/home/feed.dart';
import 'package:clap_and_view/frontend/pages/home/publish_stream.dart';
import 'package:clap_and_view/frontend/pages/home/settings.dart';
import 'package:clap_and_view/frontend/pages/home/video_feed.dart';
import 'package:clap_and_view/frontend/transitions/transition_slide.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  List<IconData> icons = [
    ClapAndViewIcons.estate,
    ClapAndViewIcons.compass,
    ClapAndViewIcons.plus_circle,
    ClapAndViewIcons.user,
  ];

  late List<Widget> pages = [
    const VideoFeedPage(),
    const FeedPage(),
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

    if (GetStorage().read("tgCode") == null) {
      GetStorage().write("tgCode", getRandomString(30));
    }

    var phone = GetStorage().read('phone');

    getLinks();

    if (phone != null) {
      Provider.of<UserController>(context, listen: false).auth(
        User(
          id: "",
          phone: phone,
          name: "",
          username: "",
          age: 0,
          following: [],
          following_count: 0,
          followers_count: 0,
          description: "",
          link: "",
          fav_hashtags: [],
          profile_pic: "basic",
          gender: "",
          gender_preference: [],
          datetime_registration: DateTime.now().toString(),
          balance: 0,
          email: "",
        ),
      );

      GetStorage().write('isLoggedIn', true);
    }
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
              : (selectedIndex == 0)
                  ? Colors.black
                  : darkerGreyColor,
        ),
        child: Scaffold(
          backgroundColor: (selectedIndex == pages.length - 1)
              ? Colors.white
              : (selectedIndex == 0)
                  ? Colors.black
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
                    Stack(
                      children: [
                        Container(
                          height: kBottomNavigationBarHeight,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                            left: 15.r,
                            right: 15.r,
                          ),
                          color: (selectedIndex == pages.length - 1)
                              ? Colors.white
                              : (selectedIndex == 0)
                                  ? Colors.black
                                  : darkerGreyColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List<Widget>.generate(
                              pages.length,
                              (int index) {
                                return GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    if (GetStorage().read('isLoggedIn') ||
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
                                    width: (MediaQuery.of(context).size.width -
                                            30.r) /
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
                                                color: Colors.black
                                                    .withOpacity(0.3),
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
                        (isStreaming)
                            ? Container(
                                height: kBottomNavigationBarHeight,
                                width: MediaQuery.of(context).size.width,
                                color: darkerGreyColor.withOpacity(0.75),
                              )
                            : Container(),
                      ],
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
                      : (selectedIndex == 0)
                          ? Colors.black
                          : darkerGreyColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getLinks() async {
    var tgCode = GetStorage().read("tgCode");
    await FirebaseDynamicListService.initDeepLink(context, tgCode);
  }

  String getRandomString(int length) {
    const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    final Random r = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => ch.codeUnitAt(
          r.nextInt(ch.length),
        ),
      ),
    );
  }
}
