import 'package:flutter/material.dart';
import 'package:ng169/page/login/index.dart';
import 'package:ng169/page/user/home.dart';
import 'package:ng169/tool/function.dart';
import 'package:ng169/tool/global.dart';
import 'package:ng169/tool/lang.dart';

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
    bool islogin;
    
    if (user != null) {
      islogin = true;
    } else {
      islogin = false;
    }
    return new MaterialApp(
        title: lang('Appname'),
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: islogin ? new HomePage() : new Index());
  }
}
