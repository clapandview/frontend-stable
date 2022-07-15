import 'package:clap_and_view/client/models/stream.dart';
import 'package:clap_and_view/client/utils/custom_dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class BroadcastController extends ChangeNotifier {
  late StreamModel currentStream;
  List<StreamModel> streams = [];
  int page = 0;
  int limit = 10;

  Future createOne(StreamModel stream) async {
    final token = GetStorage().read('token');
    try {
      final data = (await CustomDio(token).send(
        reqMethod: "post",
        path: "stream/CreateOne",
        body: stream.toJson(stream),
      ))
          .data;

      final streamData = data;

      currentStream = StreamModel.fromJson(streamData);

      print(streamData);

      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future updateStream(StreamModel stream) async {
    final token = GetStorage().read('token');

    try {
      final streamsData = (await CustomDio(token).send(
        reqMethod: "post",
        path: "stream/Update",
        body: stream.toJson(stream),
      ))
          .data;

      if (kDebugMode) {
        print(streamsData);
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future updateStatus(StreamModel stream) async {
    final token = GetStorage().read('token');

    try {
      final streamsData = (await CustomDio(token).send(
        reqMethod: "post",
        path: "stream/UpdateStatus",
        body: stream.toJson(stream),
      ))
          .data;

      currentStream.status = stream.status;
      notifyListeners();

      if (kDebugMode) {
        print(streamsData);
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future getOneByUserId(String id) async {
    final token = GetStorage().read('token');
    try {
      final data = (await CustomDio(token).send(
        reqMethod: "get",
        path: "stream/GetOneByUserId/$id",
      ))
          .data;

      final streamData = data;

      currentStream = StreamModel.fromJson(streamData);

      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future loadFirstPageSmart(String phone, String country) async {
    try {
      final token = GetStorage().read('token');

      page = 0;

      streams.clear();

      final data = (await CustomDio(token).send(
        reqMethod: "post",
        path: "stream/GetSmartFeed",
        body: {
          'skip': '$page',
          'limit': '$limit',
          'phone': phone,
          'country': country,
        },
      ))
          .data;

      final streamsData = data as List;

      streams = streamsData.map((d) => StreamModel.fromJson(d)).toList();
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future loadNextPageSmart(String phone, String country) async {
    try {
      final token = GetStorage().read('token');

      ++page;

      final data = (await CustomDio(token).send(
        reqMethod: "post",
        path: "stream/GetSmartFeed",
        body: {
          'skip': '${page * limit}',
          'limit': '$limit',
          'phone': phone,
          'country': country,
        },
      ))
          .data;

      final streamsData = data as List;
      streams.addAll(streamsData.map((d) => StreamModel.fromJson(d)).toList());
      notifyListeners();
      if (streamsData.isEmpty) {
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

  Future loadFirstPageHash(String hashtagName) async {
    try {
      final token = GetStorage().read('token');

      page = 0;

      streams.clear();

      final data = (await CustomDio(token).send(
        reqMethod: "post",
        path: "stream/GetHashtagFeed",
        body: {
          'skip': '$page',
          'limit': '$limit',
          'hashtag_name': hashtagName,
        },
      ))
          .data;

      final streamsData = data as List;
      streams = streamsData.map((d) => StreamModel.fromJson(d)).toList();
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future loadNextPageHash(String hashtagName) async {
    try {
      final token = GetStorage().read('token');

      ++page;

      final data = (await CustomDio(token).send(
        reqMethod: "post",
        path: "stream/GetHashtagFeed",
        body: {
          'skip': '${page * limit}',
          'limit': '$limit',
          'hashtag_name': hashtagName,
        },
      ))
          .data;

      final streamsData = data as List;
      streams.addAll(streamsData.map((d) => StreamModel.fromJson(d)).toList());
      notifyListeners();
      if (streamsData.isEmpty) {
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

  Future loadFirstPageFollowing(List<String> userIdList) async {
    try {
      final token = GetStorage().read('token');

      page = 0;

      streams.clear();

      final data = (await CustomDio(token).send(
        reqMethod: "post",
        path: "stream/GetFollowingFeed",
        body: {
          'skip': '$page',
          'limit': '$limit',
          'following': userIdList,
        },
      ))
          .data;

      final streamsData = data as List;
      streams = streamsData.map((d) => StreamModel.fromJson(d)).toList();
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future loadNextPageFollowing(List<String> userIdList) async {
    try {
      final token = GetStorage().read('token');

      ++page;

      final data = (await CustomDio(token).send(
        reqMethod: "post",
        path: "stream/GetFollowingFeed",
        body: {
          'skip': '${page * limit}',
          'limit': '$limit',
          'following': userIdList,
        },
      ))
          .data;

      final streamsData = data as List;
      streams.addAll(streamsData.map((d) => StreamModel.fromJson(d)).toList());
      notifyListeners();
      if (streamsData.isEmpty) {
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

  Future loadFirstPageSearch(String request) async {
    try {
      final token = GetStorage().read('token');

      page = 0;

      streams.clear();

      final data = (await CustomDio(token).send(
        reqMethod: "post",
        path: "stream/Find/$request",
        body: {'skip': '$page', 'limit': '$limit'},
      ))
          .data;

      final streamsData = data as List;

      streams = streamsData.map((d) => StreamModel.fromJson(d)).toList();
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
        path: "stream/Find/$request",
        body: {'skip': '${page * limit}', 'limit': '$limit'},
      ))
          .data;

      final streamsData = data as List;
      streams.addAll(streamsData.map((d) => StreamModel.fromJson(d)).toList());
      notifyListeners();
      if (streamsData.isEmpty) {
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

  Future startUploadImg(XFile? image) async {
    final token = GetStorage().read('token');

    try {
      final streamsData = (await CustomDio(token).uploadFile(
        apiEndPoint: "stream/UploadThumbnail/${currentStream.id}",
        filePath: image!.path,
      ))
          .data;

      currentStream.thumbnail = streamsData['result'];
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  void updateTitle(String title) {
    currentStream.title = title;
    notifyListeners();
  }

  void updateDescription(String description) {
    currentStream.description = description;
    notifyListeners();
  }
}
