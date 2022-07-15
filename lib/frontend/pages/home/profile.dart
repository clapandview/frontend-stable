import 'package:auto_size_text/auto_size_text.dart';
import 'package:clap_and_view/client/models/stream.dart';
import 'package:clap_and_view/client/models/user.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/common_ui_elements/box.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/pages/home/watch_stream.dart';
import 'package:clap_and_view/frontend/transitions/transition_slide.dart';
import 'package:clap_and_view/frontend/widgets/stream/stream_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../client/controllers/stream_controller.dart';
import '../../../client/controllers/user_controller.dart';
import '../../../client/utils/config.dart';
import '../../logic/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.user_id,
  }) : super(key: key);

  final String user_id;

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
        statusBarIconBrightness: Brightness.dark,
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
                    ? Column(children: [
                        Container(
                            decoration: BoxDecoration(
                                color: darkGreyColor,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(35.r),
                                    bottomRight: Radius.circular(35.r))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: kToolbarHeight,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            Navigator.of(context).pop(),
                                        child: Container(
                                          color: Colors.transparent,
                                          height: kToolbarHeight,
                                          width: kToolbarHeight,
                                          child: Icon(
                                            ClapAndViewIcons
                                                .angle_left_no_space,
                                            color: lighterGreyColor,
                                          ),
                                        ),
                                      ),
                                      AutoSizeText(
                                        user!.name,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: lighterGreyColor,
                                          fontSize: 25.sp,
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
                                    width: kToolbarHeight * 2.5,
                                    height: kToolbarHeight * 2.5,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${baseUrl}user/DownloadProfilePic/${user!.profile_pic}",
                                    httpHeaders: {
                                      'authorization':
                                          'Bearer ${GetStorage().read('token')}'
                                    },
                                  ),
                                ),
                                SizedBox(height: 10.w),
                                AutoSizeText(
                                  "@${user!.username}",
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: lighterGreyColor,
                                    fontSize: kMainTxtSize,
                                    fontFamily: "SFProDisplayMedium",
                                  ),
                                ),
                                SizedBox(height: 10.w),
                                Container(
                                  width: 0.75.sw,
                                  alignment: Alignment.center,
                                  child: Text(
                                    user!.description,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: lighterGreyColor,
                                      fontSize: kMainTxtSize,
                                      fontFamily: "SFProDisplayMedium",
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.w),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    (isFollowing)
                                        ? GestureDetector(
                                            onTap: () => unfollow(),
                                            child: Container(
                                              height: 32.w,
                                              width: 110.w,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: accentColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.r)),
                                              child: AutoSizeText(
                                                AppLocalizations.of(context)!
                                                    .translate('following'),
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: lighterGreyColor,
                                                  fontSize: 25.sp,
                                                  fontFamily:
                                                      "SFProDisplayMedium",
                                                ),
                                              ),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () => follow(),
                                            child: Container(
                                              height: 32.w,
                                              width: 80.w,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: lighterGreyColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.r)),
                                              child: AutoSizeText(
                                                AppLocalizations.of(context)!
                                                    .translate('follow'),
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: accentColor,
                                                  fontSize: 25.sp,
                                                  fontFamily:
                                                      "SFProDisplayMedium",
                                                ),
                                              ),
                                            ),
                                          ),
                                    SizedBox(width: 5.w),
                                    GestureDetector(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: Container(
                                        height: 32.w,
                                        width: 32.w,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: lighterGreyColor,
                                            borderRadius:
                                                BorderRadius.circular(12.r)),
                                        child: Icon(
                                          ClapAndViewIcons.message_45,
                                          color: accentColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.w),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AutoSizeText(
                                          "${user!.following_count}",
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: lighterGreyColor,
                                            fontSize: 25.sp,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AutoSizeText(
                                          "${user!.followers_count}",
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: lighterGreyColor,
                                            fontSize: 25.sp,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AutoSizeText(
                                          "${user!.balance}",
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: lighterGreyColor,
                                            fontSize: 25.sp,
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
                                SizedBox(height: 10.w),
                                (stream != null && stream!.status == 2)
                                    ? Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 25.w,
                                                height: 25.w,
                                                decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        255, 0, 0, 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10000.r)),
                                              ),
                                              SizedBox(width: 10.w),
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
                                          SizedBox(height: 10.w),
                                        ],
                                      )
                                    : Container(),
                              ],
                            )),
                        SizedBox(height: kMainSpacing),
                        (stream != null && stream!.status == 2)
                            ? Container(
                                width: (1.sw - 60.w) / 2,
                                height: ((1.sw - 60.w) / 2) / 0.75,
                                child: GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                          SlideRoute(
                                            page: WatchStreamPage(
                                              id: stream!.id,
                                              isPublisher: false,
                                            ),
                                          ),
                                        ),
                                    child: StreamCard(
                                      thumb: stream!.thumbnail,
                                      title: stream!.title,
                                      name: stream!.author_name,
                                      viewsCount: stream!.count,
                                    )))
                            : Container(),
                      ])
                    : CircularProgressIndicator())),
      ),
    );
  }

  void follow() {
    Provider.of<UserController>(context, listen: false).follow(
        Provider.of<UserController>(context, listen: false).currentUser.id,
        widget.user_id);
    user!.followers_count += 1;
    setState(() {
      isFollowing = true;
      user = user;
    });
  }

  void unfollow() {
    Provider.of<UserController>(context, listen: false).unfollow(
        Provider.of<UserController>(context, listen: false).currentUser.id,
        widget.user_id);
    user!.followers_count -= 1;
    setState(() {
      isFollowing = false;
      user = user;
    });
  }

  void loadData() async {
    var cur_user = await Provider.of<UserController>(context, listen: false)
        .getOne(widget.user_id);
    var cur_stream =
        await Provider.of<BroadcastController>(context, listen: false)
            .getOneByUserId(widget.user_id);
    setState(() {
      user = cur_user;
      stream = cur_stream;
    });
  }

  void checkIfFollowing() {
    Provider.of<UserController>(context, listen: false)
        .currentUser
        .following
        .forEach((currentUserId) {
      if (currentUserId == widget.user_id) {
        isFollowing = true;
      }
    });
  }

  _onRefresh() async {
    loadData();
    _refreshController.refreshCompleted();
  }
}