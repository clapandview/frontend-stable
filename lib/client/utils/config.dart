import 'dart:io' show Platform;

String baseUrl = (Platform.isIOS)
    ? "http://localhost:5000/api/"
    : "http://10.0.2.2:5000/api/";

String serverUrl = "wss://domain:port/WebRTCAppEE/websocket";
