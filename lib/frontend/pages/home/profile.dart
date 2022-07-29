import 'package:auto_size_text/auto_size_text.dart';
import 'package:clap_and_view/client/controllers/stream_controller.dart';
import 'package:clap_and_view/client/controllers/user_controller.dart';
import 'package:clap_and_view/client/models/stream.dart';
import 'package:clap_and_view/client/models/user.dart';
import 'package:clap_and_view/client/utils/config.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:clap_and_view/frontend/masks/gradient_mask.dart';
import 'package:clap_and_view/frontend/masks/gradient_text_mask.dart';
import 'package:clap_and_view/frontend/widgets/buttons/back_button.dart';
import 'package:clap_and_view/frontend/widgets/buttons/button.dart';
import 'package:clap_and_view/frontend/widgets/stream/stream_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'dart:io' show Platform;

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  User? user;
  StreamModel? stream;
  bool isFollowing = false;

  @override
  void initState() {
    checkIfFollowing();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        statusBarColor: darkGreyColor,
      ),
      child: Scaffold(
        backgroundColor: darkerGreyColor,
        body: SafeArea(
          child: SmartRefresher(
            enablePullUp: true,
            onRefresh: _onRefresh,
            controller: _refreshController,
            child: (user != null)
                ? Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: darkGreyColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(35.r),
                              bottomRight: Radius.circular(35.r),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: kToolbarHeight,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomBackButton(
                                      color: lighterGreyColor,
                                    ),
                                    AutoSizeText(
                                      user!.name,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: lighterGreyColor,
                                        fontSize: 22.sp,
                                        fontFamily: "SFProDisplaySemibold",
                                      ),
                                    ),
                                    const SizedBox(
                                      height: kToolbarHeight,
                                      width: kToolbarHeight,
                                    ),
                                  ],
                                ),
                              ),
                              ClipOval(
                                child: CachedNetworkImage(
                                  width: kToolbarHeight * 2.0,
                                  height: kToolbarHeight * 2.0,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${baseUrl}user/DownloadProfilePic/${user!.profile_pic}",
                                  httpHeaders: {
                                    'authorization':
                                        'Bearer ${GetStorage().read('token')}'
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10.w,
                              ),
                              AutoSizeText(
                                "@${user!.username}",
                                maxLines: 1,
                                style: TextStyle(
                                  color: lighterGreyColor,
                                  fontSize: kMainTxtSize,
                                  fontFamily: "SFProDisplayMedium",
                                ),
                              ),
                              (user!.description == "")
                                  ? const SizedBox()
                                  : SizedBox(
                                      height: 15.w,
                                    ),
                              Container(
                                width: 0.75.sw,
                                alignment: Alignment.center,
                                child: Text(
                                  user!.description,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: lighterGreyColor,
                                    fontSize: kMainTxtSize,
                                    fontFamily: "SFProDisplayMedium",
                                  ),
                                ),
                              ),
                              (user!.description == "")
                                  ? const SizedBox()
                                  : SizedBox(
                                      height: 15.w,
                                    ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  (isFollowing)
                                      ? GestureDetector(
                                          onTap: () => unfollow(),
                                          child: Container(
                                            height: kToolbarHeight / 1.5,
                                            width: 130.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(12.r),
                                              ),
                                              color: lighterGreyColor,
                                            ),
                                            child: Center(
                                              child: GradientText(
                                                AppLocalizations.of(context)!
                                                    .translate('unfollow'),
                                                gradient:
                                                    LinearGradient(colors: [
                                                  accentColor,
                                                  accentColorTwo,
                                                ]),
                                                style: TextStyle(
                                                  color: accentColor,
                                                  fontSize: kMainTxtSize,
                                                  fontFamily:
                                                      "SFProDisplaySemibold",
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : CustomButton(
                                          onTap: () => follow(),
                                          text: AppLocalizations.of(context)!
                                              .translate('follow'),
                                          height: kToolbarHeight / 1.5,
                                          width: 130.w,
                                          borderRadius: 12.r,
                                          color1: (isLoggedIn)
                                              ? accentColor
                                              : Colors.grey,
                                          color2: (isLoggedIn)
                                              ? accentColorTwo
                                              : Colors.grey,
                                          loading: false,
                                        ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: Container(
                                      height: kToolbarHeight / 1.5,
                                      width: kToolbarHeight / 1.5,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: lighterGreyColor,
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: const RadiantGradientMask(
                                        child: Icon(
                                          ClapAndViewIcons.message_45,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: kMainSpacing,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        "${user!.following_count}",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: lighterGreyColor,
                                          fontSize: 22.sp,
                                          fontFamily: "SFProDisplayBold",
                                        ),
                                      ),
                                      AutoSizeText(
                                        AppLocalizations.of(context)!
                                            .translate('following'),
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: lightGreyColor,
                                          fontSize: kMainTxtSize,
                                          fontFamily: "SFProDisplayMedium",
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 1.w,
                                    height: 25.w,
                                    decoration:
                                        BoxDecoration(color: lightGreyColor),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        "${user!.followers_count}",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: lighterGreyColor,
                                          fontSize: 22.sp,
                                          fontFamily: "SFProDisplayBold",
                                        ),
                                      ),
                                      AutoSizeText(
                                        AppLocalizations.of(context)!
                                            .translate('followers'),
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: lightGreyColor,
                                          fontSize: kMainTxtSize,
                                          fontFamily: "SFProDisplayMedium",
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 1.w,
                                    height: 25.w,
                                    decoration:
                                        BoxDecoration(color: lightGreyColor),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        "${user!.balance}",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: lighterGreyColor,
                                          fontSize: 22.sp,
                                          fontFamily: "SFProDisplayBold",
                                        ),
                                      ),
                                      AutoSizeText(
                                        AppLocalizations.of(context)!
                                            .translate('bobliers'),
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: lightGreyColor,
                                          fontSize: kMainTxtSize,
                                          fontFamily: "SFProDisplayMedium",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: kMainSpacing,
                              ),
                              (stream != null && stream!.status == 2)
                                  ? Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 18.w,
                                              height: 18.w,
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    255, 0, 0, 1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10000.r,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.r,
                                            ),
                                            AutoSizeText(
                                              AppLocalizations.of(context)!
                                                  .translate('live_now'),
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: const Color.fromRGBO(
                                                    255, 0, 0, 1),
                                                fontSize: kMainTxtSize,
                                                fontFamily:
                                                    "SFProDisplayMedium",
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: kMainSpacing,
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          )),
                      SizedBox(
                        height: kMainSpacing,
                      ),
                      (stream != null && stream!.status == 2)
                          ? SizedBox(
                              width: (1.sw - 60.w) / 2,
                              height: ((1.sw - 60.w) / 2) / 0.75,
                              child: StreamCard(
                                streamModel: stream!,
                              ),
                            )
                          : Container(),
                    ],
                  )
                : Center(
                    child: (Platform.isIOS)
                        ? const CupertinoActivityIndicator(
                            color: Colors.white,
                          )
                        : const SizedBox(
                            height: kToolbarHeight / 2.0,
                            width: kToolbarHeight / 2.0,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          ),
                  ),
          ),
        ),
      ),
    );
  }

  void follow() {
    if (isLoggedIn) {
      Provider.of<UserController>(context, listen: false).follow(
          Provider.of<UserController>(context, listen: false).currentUser.id,
          widget.userId);
      Provider.of<UserController>(context, listen: false)
          .currentUser
          .following
          .add(widget.userId);
      user!.followers_count += 1;
      setState(() {
        isFollowing = true;
        user = user;
      });
    }
  }

  void unfollow() {
    if (isLoggedIn) {
      Provider.of<UserController>(context, listen: false).unfollow(
          Provider.of<UserController>(context, listen: false).currentUser.id,
          widget.userId);
      Provider.of<UserController>(context, listen: false)
          .currentUser
          .following
          .remove(widget.userId);
      user!.followers_count -= 1;
      setState(() {
        isFollowing = false;
        user = user;
      });
    }
  }

  void loadData() async {
    var curUser = await Provider.of<UserController>(context, listen: false)
        .getOne(widget.userId);
    var curStream =
        // ignore: use_build_context_synchronously
        await Provider.of<BroadcastController>(context, listen: false)
            .getOneByUserId(widget.userId);
    setState(() {
      user = curUser;
      stream = curStream;
    });
  }

  void checkIfFollowing() {
    if (isLoggedIn) {
      Provider.of<UserController>(context, listen: false)
          .currentUser
          .following
          .forEach((currentUserId) {
        if (currentUserId == widget.userId) {
          isFollowing = true;
        }
      });
    }
  }

  _onRefresh() async {
    loadData();
    _refreshController.refreshCompleted();
  }
}
