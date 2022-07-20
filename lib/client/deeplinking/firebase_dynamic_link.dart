import 'package:clap_and_view/client/utils/config.dart';
import 'package:clap_and_view/frontend/pages/home/home.dart';
import 'package:clap_and_view/frontend/transitions/transition_fade.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

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

  /*
  static Future<void> initDynamicLink(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink.link;
      if (deepLink != null) {
        var isId = deepLink.pathSegments.contains("id");
        if (isId) {
          String id = deepLink.queryParameters["id"]!;
          return Navigator.of(context).push(
            FadeRoute(
              page: const NamePage(),
            ),
          );
        }
      }
    });
  } */

  static Future<FadeRoute?> initTgAuth(
      BuildContext context, String tgCode) async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) async {
      final Uri deepLink = dynamicLink.link;
      String firstPathSegment = deepLink.pathSegments[0];
      if (firstPathSegment == "tg-auth") {
        var parameters = deepLink.queryParameters;
        if (parameters["code"] == tgCode) {
          /*Navigator.of(context).pushReplacement(
            FadeRoute(
              page: const HomePage(),
            ),
          );*/
        }
      }
    });
    return null;
  }

  static tgAuthentification(Uri deepLink) {}
}
