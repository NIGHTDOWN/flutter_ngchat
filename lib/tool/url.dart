import 'package:flutter/material.dart';

/*
context 为上下文
classObject 为页面实列对象
 */
void gourl(context,Object classObject){
  
   Navigator.push(context, new MaterialPageRoute(builder: (context) => classObject));
}