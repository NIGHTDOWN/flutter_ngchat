import 'dart:convert';
import 'package:flutter/services.dart';
import 'function.dart';

var language; //全局语言
String lang(index) {
  if (null == language) {
    return index;
  }
  if (null != language[index]) {
    return language[index];
  } else {
    return index;
  }
}

Future inilang() async {
  String jsonLang;
  try {
    jsonLang = await rootBundle.loadString('assets/lang/en.json'); //加载语言文件
  } catch (e) {
    jsonLang = null;
     d('语言包加载错误');
    return false;
   
  }

  language = json.decode(jsonLang);
}
