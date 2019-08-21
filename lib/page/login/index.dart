import 'package:flutter/material.dart';
import 'package:ng169/style/sign_in_page.dart';
import 'package:ng169/style/sign_up_page.dart';
import 'package:ng169/style/theme.dart' as indextheme;
import 'package:ng169/tool/brige.dart';
import 'package:ng169/tool/lang.dart';

class Index extends StatefulWidget {
  @override
  _Index createState() => new _Index();
}

class _Index extends State<Index> {
  int _currentPage = 0;

  PageController _pageController;
  PageView _pageView;
  List<Widget> page, centerbtn;
  bool isload = false;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
    loadbox();
  }

  loadding() {
    setState(() {
      isload = true;
    });
  }

  hideing() {
    setState(() {
      isload = false;
    });
  }

  void loadbox() {
    _pageView = new PageView(
      controller: _pageController,
      children: <Widget>[
        new SignInPage(),
        new SignUpPage(),
      ],
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    initpage();
    loadbox();
    Column columns = new Column(mainAxisSize: MainAxisSize.max, children: page);
    Map fun = new Map();
    fun['loadding'] = this.loadding;
    fun['hideing'] = this.hideing;
    // d(load);
    // d(this.load);
    // d(fun['load']);
    BoxDecoration bg = new BoxDecoration(
      gradient: indextheme.Theme.primaryGradient, //背景色
    ); //背景色
    return new Scaffold(
        /**
           * SafeArea，让内容显示在安全的可见区域
           * SafeArea，可以避免一些屏幕有刘海或者凹槽的问题
           */
        body: new SafeArea(
      child: new SingleChildScrollView(
          /**
                 * 用SingleChildScrollView+Column，避免弹出键盘的时候，出现overFlow现象
                 */
          child: new Container(
              /**这里要手动设置container的高度和宽度，不然显示不了
                     * 利用MediaQuery可以获取到跟屏幕信息有关的数据
                     */
              // height: MediaQuery.of(context).size.height,
              height: 750,
              width: MediaQuery.of(context).size.width,

              //设置渐变的背景
              decoration: bg,
              child: new NgBrige(
                  child: columns, data: {'isload': isload}, fun: fun))),
    ));
  }

  //载入页面元素
  void initpage() {
    // d(MediaQuery.of(context));
    BorderRadius _borderRadius = BorderRadius.all(Radius.circular(25)); //圆角弧度
    centerbtn = <Widget>[
      Expanded(
          child: new Container(
        decoration: _currentPage == 0
            ? BoxDecoration(
                borderRadius: _borderRadius,
                color: Colors.white,
              )
            : null,
        child: GestureDetector(
          //去掉按钮水波纹效果
          onTap: () {
            _pageController.animateToPage(0,
                duration: Duration(milliseconds: 500),
                curve: Curves.decelerate);
          },
          child: new FlatButton(
            disabledTextColor: Colors.black,
            child: new Text(
              lang("登入"),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: _currentPage == 1 ? FontWeight.bold : null),
            ),
            // shape: RoundedRectangleBorder(
            //   borderRadius: _borderRadius,
            // ),
            // splashColor: Colors.white,
            // highlightColor: Colors.white,
            onPressed: null,
          ),
        ),
      )),
      Expanded(
          child: new Container(
              decoration: _currentPage == 1
                  ? BoxDecoration(
                      borderRadius: _borderRadius,
                      color: Colors.white,
                    )
                  : null,
              child: GestureDetector(
                onTap: () {
                  _pageController.animateToPage(1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.decelerate);
                },
                child: new FlatButton(
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: _borderRadius,
                  // ),
                  disabledTextColor: Colors.black,
                  child: new Text(
                    lang("注册"),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: _currentPage == 0 ? FontWeight.bold : null),
                  ),
                  onPressed: null,
                ),
              ))),
    ];

    page = <Widget>[
      new SizedBox(
        height: 35, // new Padding(padding: EdgeInsets.only(top: 35)),上边距35
      ),
      //顶部图片
      new Image(
          width: 250,
          height: 191,
          image: new AssetImage("assets/login_logo.png")),
      new SizedBox(
        height: 20,
      ),
      //中间的Indicator指示器
      new Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          //中间按钮背景框
          borderRadius: _borderRadius,
          color: Color(0x552B2B2B),
        ),
        child: new Row(
          children: centerbtn,
        ),
      ),
//                      new SignInPage(),
//                      new SignUpPage(),
      new Expanded(child: _pageView, flex: 1),
      Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: isload ? 2 : 0,
          child: LinearProgressIndicator(
            backgroundColor: indextheme.Theme.loginGradientEnd,
            valueColor:
                AlwaysStoppedAnimation(indextheme.Theme.loginGradientStart),
            // valueColor: ColorTween(begin: Colors.blue, end: Colors.green).animate(_controller),
          ),
        ),
      ),
    ];
  }
}