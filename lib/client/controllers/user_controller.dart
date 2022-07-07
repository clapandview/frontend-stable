import 'package:clap_and_view/client/models/user.dart';
import 'package:clap_and_view/client/utils/custom_dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends ChangeNotifier {
  late User currentUser;
  List<User> users = [];
  int page = 0;
  int limit = 10;
  // ignore: non_constant_identifier_names
  List<User> following_users = [];
  // ignore: non_constant_identifier_names
  Map<String, User> map_users = {};

  Future auth(User user) async {
    try {
      final data = (await CustomDio(null).send(
        reqMethod: "post",
        path: "user/auth",
        body: user.toJson(user),
      ))
          .data;

      final userData = data['myuser'];

      currentUser = User.fromJson(userData);

      notifyListeners();

      GetStorage().write('token', data['token']);
      GetStorage().write('phone', user.phone);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future startUploadImg(XFile? image) async {
    final token = GetStorage().read('token');

    try {
      final usersData = (await CustomDio(token).uploadFile(
        apiEndPoint: "user/UploadProfilePic/${currentUser.id}",
        filePath: image!.path,
      ))
          .data;

      currentUser.profile_pic = usersData['result'];
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future getOne(String id) async {
    final token = GetStorage().read('token');

    try {
      final usersData = (await CustomDio(token).send(
        reqMethod: "get",
        path: "user/getone/$id",
      ))
          .data;

      return User.fromJson(usersData);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future updateUser(User user) async {
    final token = GetStorage().read('token');

    try {
      final usersData = (await CustomDio(token).send(
        reqMethod: "post",
        path: "user/UpdateUser/${user.id}",
        body: user.toJson(user),
      ))
          .data;

      if (kDebugMode) {
        print(usersData);
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future loadFirstPageSearch(String request) async {
    try {
      final token = GetStorage().read('token');

      page = 0;

      users.clear();

      final data = (await CustomDio(token).send(
        reqMethod: "post",
        path: "user/find/$request",
        body: {'skip': '$page', 'limit': '$limit'},
      ))
          .data;

      final usersData = data as List;
      users = usersData.map((d) => User.fromJson(d)).toList();
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future loadNextPageSearch(String request) async {
    try {
      final token = GetStorage().read('token');

      ++page;

      final data = (await CustomDio(token).send(
        reqMethod: "post",
        path: "user/find/$request",
        body: {'skip': '${page * limit}', 'limit': '$limit'},
      ))
          .data;

      final usersData = data as List;
      users.addAll(usersData.map((d) => User.fromJson(d)).toList());
      notifyListeners();
      if (usersData.isEmpty) {
        return 0;
      } else {
        return 1;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future loadFirstPage() async {
    try {
      final token = GetStorage().read('token');

      page = 0;

      users.clear();

      final data = (await CustomDio(token).send(
        reqMethod: "post",
        path: "user/findall",
        body: {'skip': '$page', 'limit': '$limit'},
      ))
          .data;

      final usersData = data as List;
      users = usersData.map((d) => User.fromJson(d)).toList();
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future loadNextPage() async {
    try {
      final token = GetStorage().read('token');

      ++page;

      final data = (await CustomDio(token).send(
        reqMethod: "post",
        path: "user/findall",
        body: {'skip': '${page * limit}', 'limit': '$limit'},
      ))
          .data;

      final usersData = data as List;
      users.addAll(usersData.map((d) => User.fromJson(d)).toList());
      notifyListeners();
      if (usersData.isEmpty) {
        return 0;
      } else {
        return 1;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future getFollowing(String id) async {
    try {
      final token = GetStorage().read('token');

      page = 0;

      following_users.clear();

      final data = (await CustomDio(token).send(
        reqMethod: "post",
        path: "user/GetFollowing/$id",
        body: {'skip': '0', 'limit': '100'},
      ))
          .data;

      final usersData = data as List;
      following_users = usersData.map((d) => User.fromJson(d)).toList();
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future getMany(List<dynamic> ids) async {
    try {
      final token = GetStorage().read('token');

      final data = (await CustomDio(token).send(
        reqMethod: "post",
        path: "user/GetMany",
        body: {"ids": ids},
      ))
          .data;

      // ignore: non_constant_identifier_names
      var current_users = [];
      final usersData = data as List;
      //  ОПТИМИЗИРОВАТЬ ПОТОМ
      current_users = usersData.map((d) => User.fromJson(d)).toList();
      // ignore: avoid_function_literals_in_foreach_calls
      current_users.forEach((user){
        map_users[user.id] = user;
      });
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }


  void updateName(String name) {
    currentUser.name = name;
  }

  void updateNickname(String nickname) {
    currentUser.username = nickname;
  }

  void updateBio(String bio) {
    currentUser.description = bio;
  }

  void updateLink(String link) {
    currentUser.link = link;
  }
}
