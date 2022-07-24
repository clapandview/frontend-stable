import 'package:clap_and_view/client/models/session.dart';
import 'package:clap_and_view/client/utils/custom_dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

class SessionController extends ChangeNotifier {
  Future createOne(Session session) async {
    final token = GetStorage().read('token');
    try {
      final data = (await CustomDio(token).send(
        reqMethod: "post",
        path: "session/CreateOne",
        body: session.toJson(session),
      ))
          .data;

      if (kDebugMode) {
        print(data);
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future calculateAverageTimeWatched(String id) async {
    final token = GetStorage().read('token');
    try {
      final data = (await CustomDio(token).send(
        reqMethod: "get",
        path: "session/CalculateAverageTimeWatched/$id",
      ))
          .data;

      return data;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }
}
