import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ng169/page/user/home.dart';
import 'package:ng169/style/theme.dart' as theme;
import 'package:ng169/tool/brige.dart';
import 'package:ng169/tool/cache.dart';
import 'package:ng169/tool/function.dart';
import 'package:ng169/tool/global.dart';
import 'package:ng169/tool/http.dart';
import 'package:ng169/tool/lang.dart';
import 'package:ng169/tool/url.dart';


///注册界面
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => new _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  /// 利用FocusNode和FocusScopeNode来控制焦点
  /// 可以通过FocusNode.of(context)来获取widget树中默认的FocusScopeNode
  FocusNode emailFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();
  FocusScopeNode focusScopeNode = new FocusScopeNode();
  TextEditingController username = new TextEditingController();
  TextEditingController pwd = new TextEditingController();
  bool cansubmit = true;
  GlobalKey<FormState> _signInFormKey = new GlobalKey();
  Map<String, String> fromdata;
  bool isShowPassWord = false;
  NgBrige ngbrige;
  BuildContext context;
  NgCache cache;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    ngbrige = NgBrige.of(context);
    cache = g('cache');
    var positioned = new Positioned(
      child: buildSignInButton(),
      top: 170,
    );
    //忘记密码下面的or线条
    Padding padding = Padding(
      padding: EdgeInsets.only(top: 10),
      child: new Row(
//                          mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: 1,
            width: 100,
            decoration: BoxDecoration(
                gradient: new LinearGradient(colors: [
              Colors.white10,
              Colors.white,
            ])),
          ),
          new Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: new Text(
              "Or",
              style: new TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          new Container(
            height: 1,
            width: 100,
            decoration: BoxDecoration(
                gradient: new LinearGradient(colors: [
              Colors.white,
              Colors.white10,
            ])),
          ),
        ],
      ),
    );
    return new Container(
      padding: EdgeInsets.only(top: 23),
      child: new Stack(
        alignment: Alignment.center,
        //        /**
        //         * 注意这里要设置溢出如何处理，设置为visible的话，可以看到孩子，
        //         * 设置为clip的话，若溢出会进行裁剪
        //         */
        // fit:StackFit.expand,
        //  overflow: Overflow.clip,
        children: <Widget>[
          new Column(
            children: <Widget>[
              //创建表单
              buildSignInTextForm(),
              Expanded(
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: new Text(
                        "Forgot Password?",
                        style: new TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    padding,
                    /**
               * 显示第三方登录的按钮
               */
                    new SizedBox(
                      height: 10,
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: new IconButton(
                              icon: Icon(
                                FontAwesomeIcons.facebookF,
                                color: Color(0xFF0084ff),
                              ),
                              onPressed: null),
                        ),
                        new SizedBox(
                          width: 40,
                        ),
                        new Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: new IconButton(
                              icon: Icon(
                                FontAwesomeIcons.google,
                                color: Color(0xFF0084ff),
                              ),
                              onPressed: null),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          positioned
        ],
      ),
    );
  }

  /// 点击控制密码是否显示
  Future showPassWord() async => setState(() {
        isShowPassWord = !isShowPassWord;
      });

  ///创建登录界面的TextForm

  Widget buildSignInTextForm() {
    var textFormField = new TextFormField(
      //关联焦点
      // autovalidate:true,
      focusNode: emailFocusNode,
      controller: username,
      onEditingComplete: () {
        if (focusScopeNode == null) {
          focusScopeNode = FocusScope.of(context);
        }
        focusScopeNode.requestFocus(passwordFocusNode);
      },

      decoration: new InputDecoration(
          icon: new Icon(
            Icons.email,
            color: Colors.black,
          ),
          hintText: lang('账号'),
          border: InputBorder.none),
      style: new TextStyle(fontSize: 16, color: Colors.black),
      //验证
      validator: (String value) {
        if (value.isEmpty) {
          cansubmit = cansubmit && false;
          return lang('账号不能为空');
        }
        return '';
      },
      onSaved: (value) {},
    );
    var textStyle = new TextStyle(fontSize: 16, color: Colors.black);
    var textFormField2 = new TextFormField(
      focusNode: passwordFocusNode,
      // autovalidate:true,
      controller: pwd,
      decoration: new InputDecoration(
          icon: new Icon(
            Icons.lock,
            color: Colors.black,
          ),
          hintText: lang('密码'),
          border: InputBorder.none,
          suffixIcon: new IconButton(
              icon: new Icon(
                !isShowPassWord
                    ? Icons.remove_red_eye
                    : Icons.visibility_off, //没找到闭眼图标；随便了一个
                color: Colors.black,
              ),
              onPressed: showPassWord)),
      //输入密码，需要用*****显示
      obscureText: !isShowPassWord,
      style: textStyle,
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 3) {
          cansubmit = cansubmit && false;
          return "Password'length must longer than 3!";
        }
        return null;
      },
      onSaved: (value) {
        // fromdata.username=value;
        // fromdata.putIfAbsent('username', value);
      },
    );
    return new Container(
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white),
      width: 300,
      height: 190,
      /**
           * Flutter提供了一个Form widget，它可以对输入框进行分组，
           * 然后进行一些统一操作，如输入内容校验、输入框重置以及输入内容保存。
           */
      child: new Form(
        key: _signInFormKey,
        //开启自动检验输入内容，最好还是自己手动检验，不然每次修改子孩子的TextFormField的时候，其他TextFormField也会被检验，感觉不是很好
        // autovalidate: true,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              //用户名
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20, bottom: 20),
                child: textFormField,
              ),
            ),
            new Container(
              height: 1,
              width: 250,
              color: Colors.grey[400],
            ),
            Flexible(
              //密码
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: textFormField2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 创建登录界面的按钮
  Widget buildSignInButton() {
    return new GestureDetector(
      child: new Container(
        padding: EdgeInsets.only(left: 42, right: 42, top: 10, bottom: 10),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          gradient: theme.Theme.primaryGradient,
        ),
        child: new Text(
          lang('登入'),
          style: new TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      onTap: () async {
        /**利用key来获取widget的状态FormState
              可以用过FormState对Form的子孙FromField进行统一的操作
           */
        cansubmit = true;
        _signInFormKey.currentState.validate();

        if (cansubmit) {
          //如果输入都检验通过，则进行登录操作

          Function load = ngbrige.fun['loadding'];
          Function hide = ngbrige.fun['hideing'];
          load();

          // ngbrige.fun['loading']();
          // Scaffold.of(context)
          //     .showSnackBar(new SnackBar(content: new Text("执行登录操作")));
          //调用所有自孩子的save回调，保存表单内容

          // _signInFormKey.currentState.save();
          if (!ngbrige.data['isload']) {
            http('login/login', {
              'username': username.text,
              'password': pwd.text
            }).then((data) async {
              var gets = gedata(context, data);

              if (gets != false) {
                _signInFormKey.currentState.reset();
                username.clear();
                pwd.clear();
                cache.set('user', gets, '-1');
                d(gets);
                gourl(context, new HomePage());
              }

              hide();
            });
          } // d(Form.of(context));
        } else {
          //上次请求还没结束，继续等待
        }
//          debugDumpApp();
      },
    );
  }
}
