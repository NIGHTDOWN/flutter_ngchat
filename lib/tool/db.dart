import 'package:ng169/conf/conf.dart';
import 'package:sqflite/sqflite.dart';

import 'function.dart';

//创建数据库
//添加
//更新
//删除
// open,
// 	creat,
// 	select,
// 	limit,
// 	where,
// 	order,
// 	field,
// 	del,
// 	update,
// 	insert,
class Db {
  Database db;

  String _field = '*', _order = '', _limit = '', _sql = '', _where = '';
  open(String dbname) async {
    // var databasesPath = await getDatabasesPath();
    var databasesPath = '/mnt/sdcard';
    String path = (databasesPath + '/' + dbname);
    d(path);
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      this.db = db;
      // await db.execute(
      //     'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
      for (var sql in datatable) {
        creat(sql);
      }
    });
  }

  creat(sql) async {
    await this.db.execute(sql);
  }

  field(String field) {
    if (null != field) {
    } else {
      field = '*';
    }
    _field = field;
  }

  where(Map<String, dynamic> where) {
    var key = '';
    for (var var1 in where.keys) {
      key += ' and `' + var1 + '`=\'' + where[var1].toString() + '\'';
    }
    var k = key.substring(4);
    if (null != k) {
      _where = ' WHERE ' + k;
    }
    return _where;
  }

  wherestring(String where) {
    _where = where;
    return _where;
  }

  order($order) {
    if (null!=$order) {
      $order = " ORDER BY " + $order;
    }
    _order = $order;
  }

  limit(String $limit) {
    if (null != $limit) {
      $limit = " limit " + $limit;
    }
    _limit = $limit;
  }

  del(table, where) async {
    this.where(where);

    var _sql = ' DELETE FROM ' + table + _where;

    int count = await db.rawDelete(_sql);
    return count;
  }

  updata(table, updata, where) async {
    var key = '';
    var tmp = '';
    for (var var1 in updata.keys) {
      tmp = ',`' + var1 + '`=\'' + updata[var1] + '\'';
      key += tmp;
    }
    var up = key.substring(1);
    var _sql = ' UPDATE ' + table + ' SET ' + up + this.where(where);

    int count = await db.rawUpdate(_sql);
    return count;
  }

  Future insert(String table, Map<String, dynamic> insert) async {
    var key = '';
    var val = '';
    for (var var1 in insert.keys) {
      key += ',\'' + var1 + '\'';
      val += ',\'' + insert[var1].toString() + '\'';
    }

    key = key.substring(1);
    val = val.substring(1);

    var sql = 'INSERT INTO ' + table + ' (' + key + ') VALUES (' + val + ')';

    return await db.transaction((txn) async {
      int id = await txn.rawInsert(sql);

      return id;
    });

    // var id = await db.insert(table, data);
  }

  Future close() async {
    await db.close();
  }

  Future getone(table, [where]) async {
    limit('1');
    if (null != where) {
      this.where(where);
    }
    var _sql = 'SELECT ' +
        _field +
        ' FROM ' +
        table +
        ' ' +
        _where +
        " " +
        _order +
        " " +
        _limit;
    _where = '';
    _order = '';
    _limit = '';
    this.field(null);
    var data = await db.rawQuery(_sql);
    _sql = '';
    if (data.length <= 0) {
      return null;
    } else {
      return data[0];
    }
  }

  Future getall(table, [where]) async {
    if (null != where) {
      this.where(where);
    }
    var _sql = 'SELECT ' +
        _field +
        ' FROM ' +
        table +
        ' ' +
        _where +
        " " +
        _order +
        " " +
        _limit;
    _where = '';
    _order = '';
    _limit = '';
    this.field(null);
    return await db.rawQuery(_sql);
  }

  Future getcount(table) async {
    this.field('count(*)');

    var _sql = 'SELECT ' +
        _field +
        ' FROM ' +
        table +
        ' ' +
        _where +
        " " +
        _order +
        " " +
        _limit;
    _where = '';
    _order = '';
    _limit = '';
    this.field(null);
    int count = Sqflite.firstIntValue(await db.rawQuery(_sql));
    _sql = '';
    return count;
  }
}
