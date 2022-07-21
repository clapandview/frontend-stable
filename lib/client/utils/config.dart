import 'dart:io' show Platform;

String baseUrl = (Platform.isIOS)
    ? "http://localhost:5000/api/"
    : "http://10.0.2.2:5000/api/";
String serverUrl = "ws://138.197.180.60:5080/WebRTCAppEE/websocket";
String deepLinkUrl = "https://clapandview.page.link";
