import 'package:auto_size_text/auto_size_text.dart';
import 'package:clap_and_view/client/controllers/user_controller.dart';
import 'package:clap_and_view/client/utils/config.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:clap_and_view/frontend/common_ui_elements/text_field.dart';
import 'package:clap_and_view/frontend/pages/home/profile.dart';
import 'package:clap_and_view/frontend/transitions/transition_slide.dart';
import 'package:clap_and_view/frontend/widgets/buttons/back_button.dart';
import 'package:clap_and_view/frontend/widgets/user/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late ScrollController _controllerScroll;

  @override
  void initState() {
    _controllerScroll = ScrollController();
    _controllerScroll.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: darkerGreyColor,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: kToolbarHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomBackButton(
                      color: Colors.white,
                    ),
                    AutoSizeText(
                      AppLocalizations.of(context)!
                          .translate('search_t'),
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
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
              Container(
                padding: EdgeInsets.only(
                  left: kMainSpacing,
                  right: kMainSpacing,
                ),
                height: kToolbarHeight,
                child: Center(
                  child: CustomTextField(
                    controller: _controller,
                    keyboardType: TextInputType.text,
                    text: AppLocalizations.of(context)!.translate('search'),
                    cap: TextCapitalization.none,
                    maxLines: 1,
                    minLines: 1,
                    maxLength: 100,
                    borderRadius: 15.r,
                    colorTextMain: Colors.white,
                    colorTextHover: lightGreyColor,
                    colorMain: darkGreyColor,
                    onChanged: (text) async {
                      if (text.isNotEmpty) {
                        await Provider.of<UserController>(context,
                                listen: false)
                            .loadFirstPageSearch(text);
                      } else {
                        await Provider.of<UserController>(context,
                                listen: false)
                            .loadFirstPage();
                      }
                    },
                    list: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              Expanded(
                child: Consumer<UserController>(
                  builder: (context, provider, child) {
                    return SmartRefresher(
                      enablePullUp: true,
                      onRefresh: _onRefresh,
                      controller: _refreshController,
                      child: ListView.builder(
                        controller: _controllerScroll,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                          left: kMainSpacing,
                          right: kMainSpacing,
                        ),
                        itemCount: provider.users.length,
                        itemBuilder: (context, index) {
                          return UserCard(
                            thumb:
                                "${baseUrl}user/DownloadProfilePic/${provider.users[index].profile_pic}",
                            name: provider.users[index].name,
                            bio: provider.users[index].username,
                            onTap: () => Navigator.of(context).push(
                              SlideRoute(
                                page: ProfilePage(
                                  userId: provider.users[index].id,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _scrollListener() async {
    if (_controllerScroll.offset >=
            _controllerScroll.position.maxScrollExtent &&
        !_controllerScroll.position.outOfRange) {
      var res = 0;
      if (_controller.text.isNotEmpty) {
        res = await Provider.of<UserController>(context, listen: false)
            .loadNextPageSearch(_controller.text);
      } else {
        Provider.of<UserController>(context, listen: false).loadNextPage();
      }

      if (res == 0) {
        _refreshController.loadNoData();
      }
    }
  }

  _onRefresh() async {
    if (_controller.text.isNotEmpty) {
      await Provider.of<UserController>(context, listen: false)
          .loadFirstPageSearch(_controller.text);
    } else {
      Provider.of<UserController>(context, listen: false).loadFirstPage();
    }
    _refreshController.refreshCompleted();
  }
}
