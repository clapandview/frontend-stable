import 'package:clap_and_view/client/controllers/user_controller.dart';
import 'package:clap_and_view/client/models/user.dart';
import 'package:clap_and_view/client/utils/config.dart';
import 'package:clap_and_view/frontend/pages/home/home.dart';
import 'package:clap_and_view/frontend/transitions/transition_fade.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseDynamicListService {
  static Future<String> createDynamicLink(bool isShort, String data) async {
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
        deepLinkUrl,
      ),
      uriPrefix: deepLinkUrl,
      androidParameters: AndroidParameters(
        fallbackUrl: Uri.parse(
            "https://otvet.imgsmail.ru/download/181477461_3f07790140570dba1db8d6cc2a59140f_800.jpg"),
        packageName: "com.kobylyanskiy.clap_and_view",
        minimumVersion: 30,
      ),
      iosParameters: IOSParameters(
        fallbackUrl: Uri.parse(
            "https://otvet.imgsmail.ru/download/181477461_3f07790140570dba1db8d6cc2a59140f_800.jpg"),
        bundleId: "com.example.app.ios",
        appStoreId: "123456789",
        minimumVersion: "1.0.1",
      ),
    );

    Uri url;
    if (isShort) {
      final dynamicLink =
          await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
      url = dynamicLink.shortUrl;
    } else {
      url = await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    }
    String linkMessage = url.toString();
    return linkMessage;
  }

  static Future<FadeRoute?> initTgAuth(
      BuildContext context, String tgCode) async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) async {
      final Uri deepLink = dynamicLink.link;
      tgAuthentification(context, deepLink, tgCode);
    });
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (data != null) {
      final Uri deepLink = data.link;
      tgAuthentification(context, deepLink, tgCode);
    }
    return null;
  }

  static tgAuthentification(
      BuildContext context, Uri deepLink, String tgCode) async {
    String firstPathSegment = deepLink.pathSegments[0];
    if (firstPathSegment == "tg-auth") {
      var parameters = deepLink.queryParameters;
      if (parameters["code"] == tgCode) {
        if (kDebugMode) {
          print(parameters);
        }
        await Provider.of<UserController>(context, listen: false).auth(
          User(
            id: "",
            phone: parameters["phone"]!,
            name: parameters["name"]!,
            username: parameters["telegram_username"]!,
            age: 18,
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
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          FadeRoute(
            page: const HomePage(
              isLoggedIn: true,
            ),
          ),
        );
      }
    }
  }
}
