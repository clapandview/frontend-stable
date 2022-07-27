import 'dart:io' show Platform;

bool isProd = true;
String baseUrl = (isProd)
    ? "http://167.172.160.251/api/"
    : (Platform.isIOS)
        ? "http://localhost:5000/api/"
        : "http://10.0.2.2:5000/api/";

String serverUrl = "ws://167.99.128.78:5080/WebRTCAppEE/websocket";
String deepLinkUrl = "https://clapandview.page.link";
