import 'package:auto_size_text/auto_size_text.dart';
import 'package:clap_and_view/client/models/user.dart';
import 'package:clap_and_view/frontend/clap_and_view_icons_icons.dart';
import 'package:clap_and_view/frontend/common_ui_elements/box.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  User? user = null;

  @override
  void initState() {
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
                    ? Container(
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
                                    onTap: () => Navigator.of(context).pop(),
                                    child: Container(
                                      color: Colors.transparent,
                                      height: kToolbarHeight,
                                      width: kToolbarHeight,
                                      child: Icon(
                                        ClapAndViewIcons.angle_left_no_space,
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
                                width: kToolbarHeight * 3,
                                height: kToolbarHeight * 3,
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
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Container(
                                    height: 32.w,
                                    width: 80.w,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: lighterGreyColor,
                                        borderRadius:
                                            BorderRadius.circular(12.r)),
                                    child: AutoSizeText(
                                      AppLocalizations.of(context)!
                                          .translate('follow'),
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: accentColorTwo,
                                        fontSize: 25.sp,
                                        fontFamily: "SFProDisplayMedium",
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
                                      color: accentColorTwo,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.w),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 25.w,
                                  height: 25.w,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(255, 0, 0, 1),
                                      borderRadius:
                                          BorderRadius.circular(10000.r)),
                                ),
                                SizedBox(width: 10.w),
                                AutoSizeText(
                                  AppLocalizations.of(context)!
                                      .translate('live_now'),
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: const Color.fromRGBO(255, 0, 0, 1),
                                    fontSize: kMainTxtSize,
                                    fontFamily: "SFProDisplayMedium",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.w),
                          ],
                        ))
                    : CircularProgressIndicator())),
      ),
    );
  }

  void loadUser() async {
    var cur_user = await Provider.of<UserController>(context, listen: false)
        .getOne(widget.user_id);
    setState(() {
      user = cur_user;
    });
  }

  _onRefresh() async {
    loadUser();
    _refreshController.refreshCompleted();
  }
}
