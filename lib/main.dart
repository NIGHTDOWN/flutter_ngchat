import 'package:flutter/material.dart';
import 'package:tarbar_with_pageview/page/index.dart';
import 'package:tarbar_with_pageview/tool/lang.dart';


void main()  {
  //入口点
runApp(
  new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        inilang();       
        return new MaterialApp(
            title: lang('Appname'),
            theme: new ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: new Index());
      }
    
      
}
