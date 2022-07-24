import 'dart:io' show Platform;

String baseUrl = (Platform.isIOS)
    ? "http://localhost:5000/api/"
    : "http://10.0.2.2:5000/api/";

String serverUrl = "ws://167.99.128.78:5080/WebRTCAppEE/websocket";
String deepLinkUrl = "https://clapandview.page.link";
