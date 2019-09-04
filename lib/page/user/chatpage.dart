import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ng169/conf/conf.dart';
import 'package:ng169/style/bubble_widget.dart';
import 'package:ng169/tool/commom.dart';
import 'package:ng169/tool/function.dart';
import 'package:ng169/tool/global.dart';
import 'package:ng169/tool/http.dart';
import 'package:ng169/tool/tcp.dart';

//1：文本，2：图片，3：动图，4：语音，5：视频，6：表情，7：链接，8礼物',实时语音，实时视频
enum MsgType {
  text1,
  text,
  img,
  gif,
  voice,
  vod,
  emoji,
  href,
  gift,
  realvoice,
  realvideo
}

class ChatPage extends StatefulWidget {
  final chatid;

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
  var db, cache, uid, fuid;
  var chatid;
  var headimg;
  var newid;
  Widget fhead, mhead;
  //var start;
  TextEditingController textEditingController = new TextEditingController();
  List items = new List(); //新消息
  List msglist = new List(); //初次消息
  List loads = new List(); //下拉加载的消息
  ScrollController _scrollController = new ScrollController();
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
      this.fuid =
          data['uid'].toString() == uid.toString() ? data['uid2'] : data['uid'];

      loadhead();
      if (!mounted) {
        return false;
      }
      this.setState(() {});
    });

    //d(uid);
  }
  //加载消息
  loadmsg() async {
    //网络加载
    var post = {'chatid': this.chatid};
    await http('chat/lastmsgid', post, gethead()).then((data) async {
      //d(data);
      var gets = gedata(context, data);

      if (null != gets['msgid']) {
        var datadb = await db.getone('msglist', gets);

        if (null == datadb) {
          //取偏移量
          db.order('msgid desc');
          var start = await db.getone('msglist', {'chatid': this.chatid});
          var startid = null != start ? start['msgid'] : 0;
          var post = {'chatid': this.chatid, 'start': startid};
          var pulllist = await http('chat/gethistory', post, gethead());

          var pulllist2 = gedata(context, pulllist);
          if (null == pulllist2) return null;
          for (var item in pulllist2) {
            if (null == await db.getone('msglist', item)) {
              db.insert('msglist', item);
            }
            //插入本地数据
          }
          //取出列表聊天

        }
      }
    });
    //数据库加载
    db.order('msgid desc');
    db.limit('30'); //显示99条
    var tmp = await db.getall('msglist', {'chatid': this.chatid});
    msglist.addAll(tmp);
    if (!mounted) {
      return;
    }
    this.setState(() {});
  }

  head(uid) async {
    var index = 'user' + uid.toString();
    var getcache = cache.get(index);

    if (isnull(getcache, 'headimg')) {
      return Image.network(getcache['headimg'],
          width: 44.0, height: 44.0, fit: BoxFit.fill);
    } else {
      var data = await http('user/getother', {'uid': uid}, gethead());
      var headdrc = gedata(context, data);
      if (null != headdrc['headimg']) {
        cache.set(index, headdrc, (3600 * 12).toString());
        return Image.network(headdrc['headimg'],
            width: 44.0, height: 44.0, fit: BoxFit.fill);
      } else {
        return Image.asset(defaultAvatar,
            width: 44.0, height: 44.0, fit: BoxFit.fill);
      }
    }
  }

  //加载头像
  loadhead() async {
    mhead = await head(this.uid);
    fhead = await head(this.fuid);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var loadnewwg = new ListView.builder(
      // reverse: true,
      controller: _scrollController,
      itemBuilder: (context, i3) {
        return ChatListView(msglist[i3], i3, fhead, mhead);
      },
      itemCount: msglist.length,
    );

    var www = Expanded(
      flex: 1,
      child: EasyRefresh.custom(
        scrollController: _scrollController,
        reverse: true,
        footer: CustomFooter(
            enableInfiniteLoad: true,
            extent: 40.0,
            triggerDistance: 50.0,
            footerBuilder: (context,
                loadState,
                pulledExtent,
                loadTriggerPullDistance,
                loadIndicatorExtent,
                axisDirection,
                float,
                completeDuration,
                enableInfiniteLoad,
                success,
                noMore) {
              return Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      width: 30.0,
                      height: 30.0,
                      child: SpinKitCircle(
                        color: Colors.green,
                        size: 30.0,
                      ),
                    ),
                  ),
                ],
              );
            }),
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ChatListView(msglist[index], index, fhead, mhead);
              },
              childCount: msglist.length,
            ),
          ),
        ],
        onLoad: () async {
          await Future.delayed(Duration(seconds: 2), () {
            //这里是下拉加载执行动作
            // setState(() {
            //   msglist.addAll([
            //     MessageEntity(true, "It's good!"),
            //     MessageEntity(false, 'EasyRefresh'),
            //   ]);
            // });
          });
        },
      ),
    );

    return Scaffold(
        appBar: AppBar(
            title: new Text(
          '$nikeName',
          style: TextStyle(color: Colors.white),
        )),
        body: Container(
          child: Column(
            children: <Widget>[
              Divider(
                height: 0.5,
              ),
              www,
              //new Expanded(child: loadnewwg),
              // body,
              // new Container(child:body,height: 300,),
              //loadoldwg, loadinwg, loadnewwg,
              new Container(
                child: new Row(
                    // children: <Widget>[
                    //   new Expanded(
                    //       child: new TextField(
                    //     decoration: new InputDecoration(
                    //       hintText: '请输入内容',
                    //     ),
                    //     onChanged: _onInputTextChange,
                    //     controller: textEditingController,
                    //   )),
                    //   new GestureDetector(
                    //     child: new Text('发送'),
                    //     onTap: _sendMsg,
                    //   )
                    // ],
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                            top: 5.0,
                            bottom: 5.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(
                              4.0,
                            )),
                          ),
                          child: TextField(
                            //controller: textEditingController,
                            controller: textEditingController,
                            onChanged: _onInputTextChange,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                top: 2.0,
                                bottom: 2.0,
                              ),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (value) {
                              //d(value);
                              if (textEditingController.text.isNotEmpty) {
                                _sendMsg();
                                //textEditingController.text = '';
                              }
                            },
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (textEditingController.text.isNotEmpty) {
                            _sendMsg();
                          }
                        },
                        child: Container(
                          height: 30.0,
                          width: 60.0,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                            left: 15.0,
                          ),
                          decoration: BoxDecoration(
                            color: textEditingController.text.isEmpty
                                ? Colors.grey
                                : Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(
                              4.0,
                            )),
                          ),
                          child: Text(
                            'send',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ]),
              )
            ],
          ),
        ));
  }

  _onInputTextChange(String value) {
    inputValue = value;
  }

  makedata(MsgType type, [String msg]) {
    var $time = new DateTime.now().millisecondsSinceEpoch.toString();

    $time = $time.substring(0, 10);

    var $msg = {
      'comeid': this.uid,
      'content': msg,
      'msgid': "",
      'murl': null,
      'sendtime': $time,
      'type': type.index,
      'url': '',
      'chatid': this.chatid,
      'size': '',
      'length': '',
      'resid': '',
    };
    return $msg;
  }

  void _sendMsg() {
    // print('发送消息');
    // ChatItem chatItem = new ChatItem();
    // chatItem.msg = inputValue;
    // chatItem.type = 0;
    // ChatItem chatItem2 = new ChatItem();
    // chatItem2.msg = getoutValue(inputValue);
    // chatItem2.type = 1;
    var send = makedata(MsgType.text, inputValue);

    setState(() {
      this.msglist.insert(0, send);
    });
    //d(msglist);

    var sends = {
      'action': 'login',
      'tid': '3',
      'data': jsonEncode({'uid': this.uid})
    };
    MessageUtils.send(jsonEncode(sends) + "\n");
    //g('tcp').send(jsonEncode(sends));

    textEditingController.clear();
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
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
  final dynamic item;
  final dynamic fhead;
  final dynamic mhead;
  final int i;

  ChatListView(this.item, this.i, this.fhead, this.mhead);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return _ChatListViewState(item, i, fhead, mhead);
  }
}

class _ChatListViewState extends State<ChatListView> {
  dynamic item;

  dynamic fhead;
  dynamic mhead;
  int i;
  var uid;
  var defaultAvatar = '/assets/images/ww_default_avatar.png';

  _ChatListViewState(this.item, this.i, this.fhead, this.mhead) {
    this.uid = g('cache').get('user')['uid'];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if (this.i % 5 == 0) {
      return getItem(true);
    } else {
      return getItem(false);
    }
  }

  Widget makeother(Map data) {
    var w = Container(
        alignment: Alignment.centerLeft,
        child: BubbleWidget(
            Colors.green.withOpacity(0.7), BubbleArrowDirection.left,
            width: 150.0,
            height: 60.0,
            child: Text(data['content'],
                style: TextStyle(color: Colors.white, fontSize: 16.0))));
    return new Container(
      margin: EdgeInsets.all(4.0),
      alignment: Alignment.centerLeft,
      //height: 30,
      child: new Row(
        children: <Widget>[mhead, new Expanded(child: w)],
      ),
    );
  }

  Widget getmsg(Map data) {
    return BubbleWidget(
        Colors.green.withOpacity(0.7), BubbleArrowDirection.left,
        child: Text(data['content'],
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white, fontSize: 16.0)));
  }

  Widget makeme(Map data) {
    var w = Container(
        alignment: Alignment.centerRight,
        child: BubbleWidget(
            Colors.blue[200].withOpacity(0.7), BubbleArrowDirection.right,
            width: 150.0,
            height: 60.0,
            child: Text(data['content'],
                style: TextStyle(color: Colors.white, fontSize: 16.0))));

    return new Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.all(4.0),
      // height: 30,
      child: new Row(
        children: <Widget>[
          new Expanded(child: w),
          fhead,
        ],
      ),
    );
  }

  Widget getItem(bool showtime) {
    var ob;
    var xxx;
    if (item['comeid'].toString() == uid.toString()) {
      ob = makeme(item);
    } else {
      ob = makeother(item);
    }
    if (showtime) {
      var time = new Center(
        child: new Text(
          gettime2(item['sendtime'].toString()),
          style: TextStyle(color: Colors.grey, fontSize: 13.0),
        ),
      );
      xxx = new Column(
        children: <Widget>[time, ob],
      );
    } else {
      xxx = new Column(
        children: <Widget>[ob],
      );
    }

    return new Padding(
      padding: EdgeInsets.all(14.0),
      child: xxx,
    );
  }
}
