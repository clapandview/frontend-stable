import 'package:clap_and_view/client/utils/config.dart';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:dio/dio.dart';

class CustomDio {
  late Dio dio;

  CustomDio(token) {
    dio = Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.followRedirects = false;
    dio.options.validateStatus = (_) => true;
    if (token != null) {
      dio.options.headers = {
        'authorization': 'Bearer $token',
      };
    }
    dio.options.sendTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    dio.options.connectTimeout = 10000;
  }

  Future<Response> send(
      {required String reqMethod,
      required String path,
      Function(int count, int total)? onSendProgress,
      Function(int count, int total)? onReceiveProgress,
      CancelToken? cancelToken,
      Map<String, dynamic>? body,
      Map<String, dynamic>? query}) async {
    late Response res;

    try {
      switch (reqMethod.toUpperCase()) {
        case 'GET':
          res = await dio.get(
            path,
            cancelToken: cancelToken,
            queryParameters: query,
          );
          break;
        case 'POST':
          res = await dio.post(
            path,
            data: body,
            onReceiveProgress: onReceiveProgress,
            onSendProgress: onSendProgress,
            cancelToken: cancelToken,
            queryParameters: query,
          );
          break;
        case 'PUT':
          res = await dio.put(
            path,
            data: body,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            cancelToken: cancelToken,
            queryParameters: query,
          );
          break;
        case 'PATCH':
          res = await dio.patch(
            path,
            data: body,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            cancelToken: cancelToken,
            queryParameters: query,
          );
          break;
        case 'DELETE':
          res = await dio.delete(
            path,
            data: body,
            cancelToken: cancelToken,
            queryParameters: query,
          );
          break;
        default:
          throw UnimplementedError();
      }
      throwIfNoSuccess(res);
      return res;
    } on DioError catch (err) {
      if (err.type == DioErrorType.other ||
          err.type == DioErrorType.connectTimeout ||
          err.type == DioErrorType.receiveTimeout) {
        rethrow;
      } else {
        throw (res.data.toString());
      }
    } catch (err) {
      rethrow;
    } finally {
      dio.close();
    }
  }

  Future<Response> uploadFile(
      {required String apiEndPoint,
      required String filePath,
      void Function(int received, int total)? sendProgress,
      List<Map<String, String>>? body,
      CancelToken? cancelToken}) async {
    final File file = File(filePath);
    final String fileName = basename(file.path);
    final FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    if (body != null) {
      final x = body.map((e) => MapEntry(e.keys.first, e.values.first));
      data.fields.addAll(x);
    }
    late Response response;

    response = await dio.post(apiEndPoint,
        data: data, onSendProgress: sendProgress, cancelToken: cancelToken);

    throwIfNoSuccess(response);
    return response;
  }

  void throwIfNoSuccess(Response response) {
    if (response.statusCode! > 300) {
      final errorMsg = response.data.toString();
      throw (errorMsg);
    }
  }
}
