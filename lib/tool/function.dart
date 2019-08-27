//控制台输出函数
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ng169/tool/toast.dart';
//import 'package:permission_handler/permission_handler.dart';

import 'global.dart';

void d(data) {
  Iterable<String> lines =
      StackTrace.current.toString().trimRight().split('\n');
  var line = lines.elementAt(1);
  print('输出内容：');
  print(data);
  print('行号' + line);
}

//弹出消息提示
void show(BuildContext context, msg, [ToastPostion positions]) {
  if (positions != null) {
    Toast.toast(context, msg: msg, position: positions);
  } else {
    Toast.toast(context, msg: msg, position: ToastPostion.bottom);
  }
}

gethead() {
  var cache = g('cache');
  var user = cache.get('user');
  if (null != user) {
    
    return {'uid': user['uid'].toString(), 'token': user['token'].toString()};
  } else {
    return null;
  }
}

Future requestPermission() async {
//     // 申请权限
  // Map<PermissionGroup, PermissionStatus> permissions =
  //     await PermissionHandler().requestPermissions([PermissionGroup.storage]);

  // // 申请结果
  // PermissionStatus permission =
  //     await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

  // if (permission == PermissionStatus.granted) {
  //   print("权限申请通过");
  // } else {
  //   print("权限申请通过");
  // }
}
