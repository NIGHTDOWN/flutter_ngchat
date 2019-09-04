import 'package:ng169/tool/tcp.dart';

import 'cache.dart';
import 'db.dart';
import 'function.dart';
import 'lang.dart';

Map<String, dynamic> globalKeys;

i() async {
  globalKeys = {'cache': new NgCache(),'db':new Db(),'tcp':new Tcp()};
// globalKeys['cache']=new NgCache();
// Future.wait(await globalKeys['cache'].init(),);
 await globalKeys['cache'].init();//加载缓存
 await globalKeys['db'].open('test6.db');
//  await globalKeys['tcp'].open('ws://192.168.6.6:8888');
 MessageUtils.open('ws://192.168.6.6:8888');
//  await globalKeys['tcp'].listen();
//   globalKeys['tcp'].recv((data){
//     d(data);
//   });
 await inilang();//加载语言包
 //数据库的还没加载
}

g(key) {
  return globalKeys[key];
}

s(key, val) {
  
  globalKeys.addAll({key:val});
  // globalKeys[key] = val;
}
