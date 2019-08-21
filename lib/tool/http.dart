import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:ng169/conf/conf.dart';

import 'function.dart';
import 'lang.dart';

Future<String> http(String url,
    [Map<String, String> datas, Map<String, String> header]) async {
  Dio dio = Dio();
  //设置代理

  dio.options.baseUrl = apiurl;
  //设置连接超时时间
  dio.options.connectTimeout = 10000;
  //设置数据接收超时时间
  dio.options.receiveTimeout = 10000;
  // dio.options.headers[HttpHeaders.authorizationHeader] = '1233';
  // dio.options.headers['Content-Type'] = 'application/x-www-form-urlencoded';
  dio.options.contentType =
      ContentType.parse("application/x-www-form-urlencoded");
  if (header != null) {
    dio.options.headers = header;
  }

  dio.interceptor.request.onSend = (Options options) {
    // 在请求被发送之前做一些事情

    return options; //continue
    // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
    // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
    //
    // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
    // 这样请求将被中止并触发异常，上层catchError会被调用。
  };
  dio.interceptor.response.onSuccess = (Response response) {
    // 在返回响应数据之前做一些预处理

    return response; // continue
  };
  dio.interceptor.response.onError = (DioError e) {
    // 当请求失败时做一些预处理
    return DioError; //continue
  };

  try {
    //以表单的形式设置请求参数
    // Map<String, String> queryParameters = {'format': '2', 'key': '939e592487c33b12c509f757500888b5', 'lon': '116.39277', 'lat': '39.933748'};
    Response response = await dio.post(url, data: datas);
    if (response.statusCode == 200) {
      var responseData = response.data.toString();
      return responseData;
    }
  } on DioError catch (e) {
    d("请求失败: $e");
  }

  return '';
}

dynamic gedata(BuildContext content, String responseData) {
  var js;
  try {
    js = jsonDecode(responseData);
  } catch (e) {
    show(content, lang('请求错误：1'));
    return false;
  }
  if (js['code'] == 1) {
    //请求成功
    return js['result'];
  } else if (js['code'] < 0) {
    //这里清空缓存，重新进入登入页面
    show(content, js['msg']);
    return false;
  } else {
    show(content, js['msg']);
    return false;
  }
}
