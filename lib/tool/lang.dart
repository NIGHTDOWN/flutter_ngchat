import 'dart:convert';
import 'package:flutter/services.dart';
import 'function.dart';

var language; //全局语言
String lang(index) {
 
  if (language!=null) {
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
    d('语言包加载错误');
  }
 
  language = json.decode(jsonLang);

}
