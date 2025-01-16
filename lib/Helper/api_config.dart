import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';

import '../Models/Response_Model.dart';

const String baseUrl = "https://customer-api.appkraft.in";

Future<ResponseModel> apiCallBack({
  String method = 'POST',
  required String path,
  Map<String, dynamic> body = const {},
}) async {
  try {
    if (body.isEmpty) {
      method = "GET";
    }
    final dio = Dio();
    Response response;
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final jar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage("$appDocPath/.cookies/"),
    );
    dio.interceptors.add(CookieManager(jar));

    final formData = FormData.fromMap(body);

    if (method == 'POST') {
      response = await dio.post(
        baseUrl + path,
        data: formData,
      );
    } else {
      response = await dio.get(baseUrl + path);
    }
    log("$path - ${response.data["message"]}");
    return ResponseModel.fromMap(response.data);
  } catch (e) {
    rethrow;
  }
}

Future<ResponseModel> apiCallBackMedia({
  required String path,
  required Map<String, dynamic> body,
}) async {
  try {
    final dio = Dio();
    Response response;

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final jar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage("$appDocPath/.cookies/"),
    );
    dio.interceptors.add(CookieManager(jar));

    final formData = FormData.fromMap(body);

    response = await dio.post(
      baseUrl + path,
      data: formData,
    );
    log("$path - ${response.data["message"]}");
    return ResponseModel.fromMap(response.data);
  } catch (e) {
    rethrow;
  }
}
