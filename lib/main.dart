import 'package:flutter/material.dart';
import 'package:ng169/page/login/index.dart';
import 'package:ng169/page/user/home.dart';
import 'package:ng169/tool/function.dart';
import 'package:ng169/tool/global.dart';
import 'package:ng169/tool/lang.dart';

import 'package:ng169/style/theme.dart' as indextheme;

void main() {
  //入口点
  i().then((data) {
    //加载缓存
    //加载sql

    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // inilang(); 语言加载有问题，先注释
    var cache = g('cache');
    var user = cache.get('user');
    // bool islogin;
    // d((user));
    // if (user) {
    //   islogin = true;
    // } else {
    //   islogin = false;
    // }
    // // BoxDecoration(
    // //   gradient: indextheme.Theme.primaryGradient, //背景色
    // // )
    // d(islogin);

    return new MaterialApp(
        title: lang('Appname'),
        theme: new ThemeData(
          // primarySwatch: indextheme.Theme.loginGradientStart,
          // primarySwatch: Colors.black,
          primaryColor: indextheme.Theme.loginGradientEnd,
        ),
        home: null != user ? new HomePage() : new Index());
  }
}
