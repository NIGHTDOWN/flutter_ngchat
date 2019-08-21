import 'package:flutter/material.dart';
import 'package:tarbar_with_pageview/TabBarBottomPageWidget.dart';
import 'package:tarbar_with_pageview/TabBarPageWidget.dart';
import 'package:tarbar_with_pageview/tool/url.dart';

class Index extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Title"),
      ),
      body: new Column(
        children: <Widget>[
          new FlatButton(
              color: Colors.blue,
              onPressed: () {
                gourl(context, new TabBarPageWidget());
              },
              child: new Text("Top Tab")),
          new FlatButton(
              color: Colors.red,
              onPressed: () {
                // Navigator.push(context, new MaterialPageRoute(builder: (context) => new TabBarBottomPageWidget()));
                gourl(context, new TabBarBottomPageWidget());
              },
              child: new Text("Bottom Tab")),
        ],
      ),
    );
  }
}
