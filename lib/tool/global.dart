import 'cache.dart';
import 'function.dart';
import 'lang.dart';

Map<String, dynamic> globalKeys;

i() async {
  globalKeys = {'cache': new NgCache()};
// globalKeys['cache']=new NgCache();
 await globalKeys['cache'].init();//加载缓存
 await inilang();//加载语言包
}

g(key) {
  return globalKeys[key];
}

s(key, val) {
  
  globalKeys.addAll({key:val});
  // globalKeys[key] = val;
}
