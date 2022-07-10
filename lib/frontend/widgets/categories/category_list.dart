import 'package:clap_and_view/client/controllers/category_controller.dart';
import 'package:clap_and_view/client/controllers/stream_controller.dart';
import 'package:clap_and_view/client/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'category_card.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, provider, child) {
        final selected = provider.currentCategory;

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            left: 20.r,
            right: 20.r,
            top: 10.r,
            bottom: 10.r,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: Provider.of<CategoryController>(context, listen: false)
              .categories
              .length,
          separatorBuilder: (BuildContext context, int index) => SizedBox(
            width: 5.r,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                Provider.of<CategoryController>(context, listen: false).change(
                    Provider.of<CategoryController>(context, listen: false)
                        .categories[index]
                        .name);
                if (Provider.of<CategoryController>(context, listen: false)
                        .currentCategory ==
                    "all") {
                  await Provider.of<BroadcastController>(context, listen: false)
                      .loadFirstPageSmart("", "");
                } else if (Provider.of<CategoryController>(context,
                            listen: false)
                        .currentCategory ==
                    "subscriptions") {
                  await Provider.of<BroadcastController>(context, listen: false)
                      .loadFirstPageFollowing(
                    List<String>.from(
                        Provider.of<UserController>(context, listen: false)
                            .currentUser
                            .following),
                  );
                } else {
                  await Provider.of<BroadcastController>(context, listen: false)
                      .loadFirstPageHash(Provider.of<CategoryController>(
                              context,
                              listen: false)
                          .currentCategory);
                }
              },
              child: CategoryCard(
                category:
                    Provider.of<CategoryController>(context, listen: false)
                        .categories[index],
                isSelected:
                    (Provider.of<CategoryController>(context, listen: false)
                                .categories[index]
                                .name ==
                            selected)
                        ? true
                        : false,
              ),
            );
          },
        );
      },
    );
  }
}
