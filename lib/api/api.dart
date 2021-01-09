import 'dart:convert';

import 'package:dio/dio.dart';
import '../model/result.dart';

/// 用于未登录等权限不够,需要跳转授权页面
class APIManager {
  static APIManager _instance = APIManager._internal();

  Dio _dio;
  factory APIManager() => _instance;

  APIManager._internal() {
    if (null == _dio) {
      _dio = new Dio(new BaseOptions(baseUrl: "xxxxx"));
      _dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
        // 在请求被发送之前做一些事情
        // TODO 设置token
        return options; //continue
      }, onResponse: (Response response) async {
        if (response.statusCode == 200) {
          // 在返回响应数据之前做一些预处理
          Result result = Result.fromJson(response.data);
          if (result.success) {
            response.data = result.data;
            return response;
          } else {
            throw NotSuccessException.fromResult(result);
          }
        } else {
          throw NotSuccessException.fromResult(null);
        }
      }, onError: (DioError e) async {
        // 当请求失败时做一些预处理
        return e; //continue
      }));
    }
  }

  get(String path, {Map<String, dynamic> params, Options options}) async {
    Response response =
        await _dio.get(path, queryParameters: params, options: options);
    return response.data;
  }

  post(String path,
      {dynamic data, Map<String, dynamic> params, Options options}) async {
    Response response = await _dio.post(path,
        data: data, queryParameters: params, options: options);
    return response.data;
  }
}

class UnAuthorizedException implements Exception {
  const UnAuthorizedException();

  @override
  String toString() => 'UnAuthorizedException';
}

/// 接口的code没有返回为true的异常
class NotSuccessException implements Exception {
  String message;

  NotSuccessException.fromResult(Result result) {
    if (result == null) {
      message = "网络异常";
    } else {
      message = result.message;
    }
  }

  @override
  String toString() {
    return 'NotExpectedException{respData: $message}';
  }
}
