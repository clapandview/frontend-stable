import 'package:clap_and_view/client/controllers/category_controller.dart';
import 'package:clap_and_view/client/controllers/stream_controller.dart';
import 'package:clap_and_view/client/controllers/user_controller.dart';
import 'package:clap_and_view/frontend/constants.dart';
import 'package:clap_and_view/frontend/logic/app_localizations.dart';
import 'package:clap_and_view/frontend/widgets/categories/category_list.dart';
import 'package:clap_and_view/frontend/widgets/stream/stream_card.dart';
import 'package:clap_and_view/frontend/common_ui_elements/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool hide = false;
  bool changeTextField = false;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          height: (hide) ? 0.0 : kToolbarHeight,
          padding: EdgeInsets.only(
            left: kMainSpacing,
            right: kMainSpacing,
          ),
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          child: Center(
            child: (changeTextField)
                ? const SizedBox()
                : CustomTextField(
                    controller: _controller,
                    keyboardType: TextInputType.text,
                    text: AppLocalizations.of(context)!.translate('search'),
                    cap: TextCapitalization.none,
                    maxLines: 1,
                    minLines: 1,
                    maxLength: 100,
                    borderRadius: 15.0,
                    colorTextMain: Colors.white,
                    colorTextHover: lightGreyColor,
                    colorMain: darkGreyColor,
                    onChanged: (text) async {
                      if (text.isNotEmpty) {
                        await Provider.of<BroadcastController>(context,
                                listen: false)
                            .loadFirstPageSearch(text);
                      } else {
                        if (Provider.of<CategoryController>(context,
                                    listen: false)
                                .currentCategory ==
                            "all") {
                          await Provider.of<BroadcastController>(context,
                                  listen: false)
                              .loadFirstPageSmart("", "");
                        } else if (Provider.of<CategoryController>(context,
                                    listen: false)
                                .currentCategory ==
                            "subscriptions") {
                          await Provider.of<BroadcastController>(context,
                                  listen: false)
                              .loadFirstPageFollowing(
                            List<String>.from(Provider.of<UserController>(
                                    context,
                                    listen: false)
                                .currentUser
                                .following),
                          );
                        } else {
                          await Provider.of<BroadcastController>(context,
                                  listen: false)
                              .loadFirstPageHash(
                                  Provider.of<CategoryController>(context,
                                          listen: false)
                                      .currentCategory);
                        }
                      }
                    },
                    list: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                    letterSpacing: 0.0,
                  ),
          ),
          onEnd: () => setState(() {
            if (!changeTextField && hide) {
              changeTextField = true;
            }
          }),
        ),
        const SizedBox(
          height: kToolbarHeight,
          child: CategoryList(),
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            child: Consumer<BroadcastController>(
              builder: (context, provider, child) {
                return SmartRefresher(
                  enablePullUp: true,
                  onRefresh: _onRefresh,
                  controller: _refreshController,
                  child: GridView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.only(
                      top: 5.r,
                      left: kMainSpacing,
                      right: kMainSpacing,
                    ),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent:
                          (MediaQuery.of(context).size.width - 60.r) / 2,
                      mainAxisSpacing: kMainSpacing,
                      crossAxisSpacing: kMainSpacing,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: provider.streams.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {},
                        child: StreamCard(
                          thumb: provider.streams[index].thumbnail,
                          title: provider.streams[index].title,
                          name: provider.streams[index].author_name,
                          viewsCount: provider.streams[index].count,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            onNotification: (scrollNotification) {
              if (_scrollController.position.userScrollDirection ==
                  ScrollDirection.reverse) {
                if (!hide) {
                  setState(() {
                    hide = !hide;
                  });
                }
              } else if (_scrollController.position.userScrollDirection ==
                  ScrollDirection.forward) {
                if (hide) {
                  setState(() {
                    hide = !hide;
                    changeTextField = false;
                  });
                }
              }
              return true;
            },
          ),
        ),
      ],
    );
  }

  _scrollListener() async {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      var res = 0;
      if (_controller.text.isNotEmpty) {
        res = await Provider.of<BroadcastController>(context, listen: false)
            .loadNextPageSearch(_controller.text);
      } else {
        if (Provider.of<CategoryController>(context, listen: false)
                .currentCategory ==
            "all") {
          await Provider.of<BroadcastController>(context, listen: false)
              .loadNextPageSmart("", "");
        } else if (Provider.of<CategoryController>(context, listen: false)
                .currentCategory ==
            "subscriptions") {
          await Provider.of<BroadcastController>(context, listen: false)
              .loadNextPageFollowing(
            List<String>.from(
                Provider.of<UserController>(context, listen: false)
                    .currentUser
                    .following),
          );
        } else {
          await Provider.of<BroadcastController>(context, listen: false)
              .loadNextPageHash(
                  Provider.of<CategoryController>(context, listen: false)
                      .currentCategory);
        }
      }

      if (res == 0) {
        _refreshController.loadNoData();
      }
    }
  }

  _onRefresh() async {
    if (_controller.text.isNotEmpty) {
      await Provider.of<BroadcastController>(context, listen: false)
          .loadFirstPageSearch(_controller.text);
    } else {
      if (Provider.of<CategoryController>(context, listen: false)
              .currentCategory ==
          "all") {
        await Provider.of<BroadcastController>(context, listen: false)
            .loadFirstPageSmart("", "");
      } else if (Provider.of<CategoryController>(context, listen: false)
              .currentCategory ==
          "subscriptions") {
        await Provider.of<BroadcastController>(context, listen: false)
            .loadFirstPageFollowing(
          List<String>.from(Provider.of<UserController>(context, listen: false)
              .currentUser
              .following),
        );
      } else {
        await Provider.of<BroadcastController>(context, listen: false)
            .loadFirstPageHash(
                Provider.of<CategoryController>(context, listen: false)
                    .currentCategory);
      }
    }
    _refreshController.refreshCompleted();
  }
}
