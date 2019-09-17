import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hgkcb/event/event_bus.dart';
import 'package:hgkcb/event/events.dart';
import 'package:hgkcb/pages/get_course_page/accent_button.dart';
import 'package:hgkcb/pages/get_course_page/text_input.dart';
import 'package:hgkcb/pages/get_course_page/verify_image.dart';
import 'package:hgkcb/util/data_util.dart';
import 'package:hgkcb/util/http_util.dart';
import 'package:hgkcb/util/system_util.dart';

/*
  登录表单，暂时使用
  written by liuwenkiii on 2019/09/17
 */
class LoginForm extends StatefulWidget {
  //Http工具类
  final HttpUtil httpUtil;
  //控制滚动
  final ScrollController controller;

  LoginForm(this.httpUtil, this.controller);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  //输入控制
  TextEditingController _studentIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _vercodeController = TextEditingController();
  //不同输入框的焦点
  final focus1 = FocusNode();
  final focus2 = FocusNode();

  @override
  void initState() {
    super.initState();
    _setUsrInfoByLastInput();
  }

  scrollUp(double offset) {
    Timer(Duration(milliseconds: 100), () {
      widget.controller.animateTo(offset,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  _setUsrInfoByLastInput() async {
    var map = await DataUtil.getUsrInfo();
    if (map['studentId'] != "") {
      _studentIdController.text = map['studentId'];
      _passwordController.text = map['passwd'];
    }
  }

  _getCourseTable() {
    String id = _studentIdController.text;
    String passwd = _passwordController.text;
    String vercode = _vercodeController.text;
    DataUtil.saveUsrInfo(id, passwd);
    if (id.isEmpty || passwd.isEmpty || vercode.isEmpty) {
      SystemUtil.showToast("学号、密码、验证码不能为空", Colors.red);
    } else {
      eventBus.fire(LoadingEvent(true));
      widget.httpUtil.login(id, passwd, vercode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Theme(
          data: Theme.of(context).copyWith(splashColor: Colors.transparent),
          child: TextField(
              maxLines: 1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              controller: _studentIdController,
              decoration: InputDecoration(
                  labelText: "学号",
                  hintText: "登录教务系统的学号",
                  prefixIcon: Icon(Icons.person)
              ),
              onSubmitted: (_) {
                scrollUp(30.0);
                FocusScope.of(context).requestFocus(focus1);
              },
              onTap: () {
                scrollUp(0.0);
              }
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(splashColor: Colors.transparent),
          child: TextField(
              focusNode: focus1,
              maxLines: 1,
              obscureText: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              controller: _passwordController,
              decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "登录教务系统的学号",
                  prefixIcon: Icon(Icons.lock)
              ),
              onSubmitted: (_) {
                scrollUp(60.0);
                FocusScope.of(context).requestFocus(focus2);
              },
              onTap: () {
                FocusScope.of(context).requestFocus(focus1);
                scrollUp(30.0);
              }
          ),
        ),
        TextInput(
          focusNode: focus2,
          controller: _vercodeController,
          label: "验证码",
          hint: "输入下方图片中的内容",
          icon: Icon(Icons.image),
          onTap: () {
            FocusScope.of(context).requestFocus(focus2);
            scrollUp(60.0);
          },
        ),
        VerifyImage(widget.httpUtil),
        Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: AccentButton(
              "确 定",
              onPress: () => _getCourseTable(),
            )),
      ],
    );
  }

}
