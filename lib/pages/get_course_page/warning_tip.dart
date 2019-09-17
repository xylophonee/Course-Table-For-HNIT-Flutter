import 'package:flutter/material.dart';

/*
  登录界面的警告提示
  written by liuwenkiii on 2019/09/17
 */
class WarningTip extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: 16.0,
        bottom: 16.0
      ),
      padding: EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: 8.0,
        bottom: 18.0
      ),
      color: Color(0x337e96b3),
      child: Column(
        children: <Widget>[
          Center(
              child: Text(
                "警告⚠",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Color(0xffe7672e)
                ),
              )
          ),
          Center(
              child: Text(
                  "        由于教务系统还未使用https连接，所以登录时的所有数据都是明文传输，"
                      "建议不要在公共网络中获取课程表，这有可能会导致你的个人信息泄露。"
              )
          )
        ],
      ),
    );
  }

}