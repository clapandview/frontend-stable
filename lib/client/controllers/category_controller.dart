import 'package:clap_and_view/client/models/category.dart';
import 'package:clap_and_view/client/utils/custom_dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

class CategoryController extends ChangeNotifier {
  List<Hashtag> categories = [
    Hashtag(
      id: "0",
      name: "all",
      emoji: "",
      count: 0,
    ),
    Hashtag(
      id: "1",
      name: "subscriptions",
      emoji: "",
      count: 0,
    ),
  ];

  String currentCategory = "all";

  Future change(String item) async {
    currentCategory = item;
    notifyListeners();
  }

  Future loadCategories() async {
    try {
      final token = GetStorage().read('token');

      final data = (await CustomDio(token).send(
        reqMethod: "get",
        path: "hashtag/GetAll",
      ))
          .data;

      final hashtagData = data as List;
      categories.addAll(hashtagData.map((d) => Hashtag.fromJson(d)).toList());
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }
}
