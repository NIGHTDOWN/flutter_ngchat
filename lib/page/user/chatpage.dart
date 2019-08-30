import 'package:flutter/material.dart';
import 'package:ng169/tool/function.dart';
import 'package:ng169/tool/global.dart';
import 'package:ng169/tool/http.dart';

class ChatPage extends StatefulWidget {
  var chatid;

  ChatPage({Key key, this.chatid}) : super(key: key) {
    //super.key=key;
    // Parent();
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return _ChatPageState(chatid: chatid);
  }
}

class _ChatPageState extends State<ChatPage> {
  String nikeName = '';
  String inputValue = '';
  var db, cache, uid;
  var chatid;
  var headimg;
  var newid;
  //var start;
  TextEditingController textEditingController = new TextEditingController();
  List<ChatItem> items = new List();
  List msglist;
  _ChatPageState({Key key, this.chatid}) {
    db = g('db');
    cache = g('cache');
    uid = g('cache').get('user')['uid'];
    var where = {'uid': uid.toString(), 'chatid': chatid.toString()};
    db.where(where);
       //db.getone('msglist', gets);
    loadmsg();
    db.getone('chatlist').then((data) {
      this.nikeName = null != data['name'] ? data['name'] : data['username'];
      this.nikeName = this.nikeName.trim();
      this.headimg = data['headimg'];
      this.setState(() {});
    });
    //d(uid);
  }
  //加载消息
  loadmsg() {
    //网络加载
    var post = {'chatid': this.chatid};
    http('chat/lastmsgid', post, gethead()).then((data) async {
      //d(data);
      var gets = gedata(context, data);

      if (null != gets['msgid']) {
        var datadb = await db.getone('msglist', gets);
        if (null == datadb) {
          //取偏移量
          db.order('msgid desc');
          var start = await db.getone('msglist', {'chatid':this.chatid});
          var startid = null != start ? start['msgid'] : 0;
          var post = {'chatid': this.chatid, 'offset': startid};
          var pulllist = await http('chat/gethistory', post, gethead());
          var pulllist2 = gedata(context, pulllist);
          for (var item in pulllist2) {
            if (null == await db.getone('msglist', item)) {
              db.insert('msglist', item);
            }
            //插入本地数据
          }
        }
      }
    });
    //数据库加载
    db.order('msgid desc');
    db.limit('99'); //显示99条
    msglist = await db.getall('msglist', {'chatid': this.chatid});
    //msglist = msglist.reversed;
    d(msglist);
    this.setState(() {});
    //d(msglist);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        appBar: AppBar(
            title: new Text(
          '$nikeName',
          style: TextStyle(color: Colors.white),
        )),
        body: Container(
          child: Column(
            children: <Widget>[
              new Expanded(
                  child: new ListView.builder(
                itemBuilder: (context, i) {
                  return ChatListView(items[i]);
                },
                itemCount: items.length,
              )),
              new Container(
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                        child: new TextField(
                      decoration: new InputDecoration(
                        hintText: '请输入内容',
                      ),
                      onChanged: _onInputTextChange,
                      controller: textEditingController,
                    )),
                    new GestureDetector(
                      child: new Text('发送'),
                      onTap: _sendMsg,
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  _onInputTextChange(String value) {
    inputValue = value;
  }

  void _sendMsg() {
    print('发送消息');
    ChatItem chatItem = new ChatItem();
    chatItem.msg = inputValue;
    chatItem.type = 0;
    ChatItem chatItem2 = new ChatItem();
    chatItem2.msg = getoutValue(inputValue);
    chatItem2.type = 1;
    setState(() {
      this.items.add(chatItem);
      this.items.add(chatItem2);
    });
    textEditingController.clear();
  }

  ///
  /// Ai核心代码,价值无限
  ///
  ///
  getoutValue(String inputValue) {
    String value = inputValue;
    value = value.replaceAll('我', '你');
    value = value.replaceAll('吗', '');
    value = value.replaceAll('?', '!');
    value = value.replaceAll('？', '!');
    return value;
  }
}

class ChatItem {
  var msg;
  int type;

  String getMsg() {
    return msg;
  }
}

class ChatListView extends StatefulWidget {
  ChatItem item;

  ChatListView(this.item);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChatListViewState(item);
  }
}

class _ChatListViewState extends State<ChatListView> {
  ChatItem item;
  var defaultAvatar = 'images/ww_default_avatar.png';

  _ChatListViewState(this.item);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getItem();
  }

  Widget getItem() {
    if (item.type == 0) {
      return new Container(
          height: 30,
          child: new Row(
            children: <Widget>[
              new Expanded(
                  child: new Text(
                item.msg,
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.black),
              )),
              new Image.asset(defaultAvatar, width: 44.0, height: 44.0),
            ],
          ));
    } else {
      return new Container(
        height: 30,
        child: new Row(
          children: <Widget>[
            new Image.asset(defaultAvatar, width: 44.0, height: 44.0),
            new Expanded(
                child: new Text(
              item.msg,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.red),
            ))
          ],
        ),
      );
    }
  }
}
