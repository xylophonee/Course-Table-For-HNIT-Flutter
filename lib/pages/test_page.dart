import 'package:flutter/material.dart';
import 'package:hgkcb/widgets/setting_card.dart';

/*
  测试页面
  written by liuwenkiii on 2019/09/10
 */
class TestPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            SettingCard(
              title: "test",
              primaryColor: Colors.blue,
              fill: 16,
              children: <Widget>[
                Text("test1"),
                Text("test2")
              ],
            ),
            SettingCard(
              title: "test",
              primaryColor: Colors.blue,
              children: <Widget>[
                Text("test1"),
                Text("test2")
              ],
            ),
          ],
        )
      ),
    );
  }
}
