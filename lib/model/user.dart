import 'package:ng169/tool/cache.dart';
import 'package:ng169/tool/function.dart';

class User {
  NgCache cache;
  String index = 'user';
  init() async {
    NgCache cache = new NgCache();
    cache.init();
    d('inituser');
  }

  get() {
    this.cache.get(index);
  }
  set(user) {
    // d(this.cache);
    //  this.cache.set(index,user,'-1');
  }
}
