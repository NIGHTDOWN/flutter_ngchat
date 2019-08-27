import 'package:flutter/material.dart';
import 'package:ng169/tool/function.dart';
import 'package:ng169/tool/global.dart';
import 'package:ng169/tool/http.dart';
import 'package:ng169/tool/url.dart';
import 'package:ng169/tool/commom.dart';
import 'chatpage.dart';
import 'package:common_utils/common_utils.dart';

class Chatlist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ChatlistState();
  }
}

class _ChatlistState extends State<Chatlist> {
  var name = '';
  var desc = '';
  int listnum = 0; //会话数量
  var listchat; //会话数量
  var db;
  var uid;
  _ChatlistState() {
    
    db = g('db');
    uid = g('cache').get('user')['uid'];
    this.loadhttp().then((data) {
      this.loaddb().then((data) {
        
        this.setState(() {}); //重新渲染
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    //d(2);
    // TODO: implement build
    dynamic widget = new ListView.builder(
      itemBuilder: (context, i) {
        return getItem(i);
      },
      itemCount: this.listnum,
    );
    //加载完成在显示
    return widget;
  }

  //本地加载优先
  loaddb() async {
    db.where({'uid': uid.toString(),'lock':'0'});
    db.limit('100'); //最大200条记录
    var data = await db.getall('chatlist');
    this.listchat = data;
    this.listnum = data.length;
    

    return data;
  }

  //线上加载
  loadhttp() async {
    return await http('chat/getlist', null, gethead()).then((data) async {
      List js = gedata(context, data);
      // this.listchat = js;
      // this.listnum = js.length;
      //入库

      for (var item in js) {
        var where = {
          'chatid': item['chatid'].toString(),
          'uid': uid.toString()
        };
        var gets = await db.getone('chatlist', where);

        if (null != gets) {
          db.updata(
              'chatlist',
              {
                // 'uid': uid,
                // 'uid2': item['uid'],
                'username': item['username'],
                // 'chatid': item['chatid'],
                'headimg': item['headimg'],
                'msg': item['msg'],
                'msgtime': item['msgtime'],
                'num': item['num']
              },
              where);
        } else {
          db.insert('chatlist', {
            'uid': uid,
            'uid2': item['uid'],
            'username': item['username'],
            'chatid': item['chatid'],
            'headimg': item['headimg'],
            'msg': item['msg'],
            'msgtime': item['msgtime'],
            'num': item['num']
          });
        }
      }

      // setState(() {}); //更新组件
    });
  }

  ///
  /// 这是一个获取每个条目的方法
  ///
  Widget getItem(int position) {
    if (listnum <= 0) {
      return null;
    }
    name = null == this.listchat[position]['name']
        ? this.listchat[position]['username']
        : this.listchat[position]['name'];
    //这里长度限制1000
    desc = this.listchat[position]['msg'].toString();
    desc = desc.trim();
    if (desc.length > 15) {
      desc = desc.substring(0, 10) + '...';
    }

    var nums = this.listchat[position]['num'].toString();
    var chatid = this.listchat[position]['chatid'].toString();
    var uid = this.listchat[position]['uid'].toString();
    var headimg = this.listchat[position]['headimg'];
    var time = this.listchat[position]['msgtime'].toString();

    return ChatListItem(position, name, desc, nums, chatid, uid, headimg, time);
  }
}

class ChatListItem extends StatefulWidget {
  int position;
  String name;
  String desc;
  String nums;
  String chatid;
  String uid;
  String headimg;
  String time;

  ChatListItem(this.position, this.name, this.desc, this.nums, this.chatid,
      this.uid, this.headimg, this.time);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChatListItemState(
        position, name, desc, nums, chatid, uid, headimg, time);
  }
}

class _ChatListItemState extends State<ChatListItem> {
  int position;
  String name;
  String desc;
  String nums;
  String chatid;
  String uid;
  String headimg;
  String time;
  var defaultAvatar = 'assets/images/ww_default_avatar.png';

  _ChatListItemState(this.position, this.name, this.desc, this.nums,
      this.chatid, this.uid, this.headimg, this.time);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Image head =
        Image.network(headimg, width: 44.0, height: 44.0, fit: BoxFit.fill);

    if (null == head) {
      head = new Image.asset(defaultAvatar, width: 44.0, height: 44.0);
    }
    setLocaleInfo('one', ZHTimelineInfo());
    setLocaleInfo('two', ENTimelineInfo());
    //new OutlineButton();GestureDetector
    return new OutlineButton(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new Container(
        child: new Column(
          children: <Widget>[
            new Container(
              height: 60.0,
              margin: new EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
              child: new Row(
                children: <Widget>[
                  head,
                  // new Image.asset(defaultAvatar, width: 44.0, height: 44.0),
                  new Expanded(
                      child: new Container(
                          height: 40.0,
                          alignment: Alignment.centerLeft,
                          margin: new EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                '$name',
                                style: TextStyle(fontSize: 15.0),
                              ),
                              new Text(
                                '$desc',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: const Color(0xffaaaaaa)),
                              ),
                            ],
                          ))),
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                    child: new Text(
                      // TimelineUtil.format(1566785551),

                      TimelineUtil.format(int.parse(this.time + '000'),
                          locale: ('one')),
                      style: TextStyle(
                        fontSize: 10.0,
                        color: const Color(0xffaaaaaa),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // new Container(
            //   margin: new EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
            //   height: 0.5,
            //   color: const Color(0xffebebeb),
            // ),
          ],
        ),
      ),
      onPressed: _toChatPage,
    );
  }

  /// 跳转聊天界面
  _toChatPage() {
    if (null != this.chatid) {
      gourl(context, new ChatPage(chatid: this.chatid));
    }
  }
}


