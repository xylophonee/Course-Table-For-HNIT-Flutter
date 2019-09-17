import 'package:flutter/material.dart';
import 'package:hgkcb/pages/get_course_page.dart';
import 'package:hgkcb/pages/setting_page.dart';
import 'package:hgkcb/pages/test_page.dart';

/*
  首页的按钮组，暂时使用，后面会去掉
  written by liuwenkiii on 2019/09/17
 */
class ButtonGroup extends StatefulWidget {

  @override
  _ButtonGroupState createState() => _ButtonGroupState();

}

class _ButtonGroupState extends State<ButtonGroup> {

  _jump2GetCoursePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GetCoursePage()
      ),
    );
  }

  _jump2SettingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SettingPage()
      ),
    );
  }

  _jump2TestPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TestPage()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
            left: 46.0,
            right: 22.0
        ),
        child: Row(
          children: <Widget>[
            Expanded(
                child: IconButton(
                  color: Color(0xff666666),
                  iconSize: 38.0,
                  icon: Icon(Icons.add),
                  onPressed: _jump2TestPage,
                )
            ),
            Expanded(
                child: IconButton(
                  color: Color(0xff666666),
                  iconSize: 34.0,
                  icon: Icon(Icons.refresh),
                  onPressed: _jump2GetCoursePage,
                )
            ),
            Expanded(
                child: IconButton(
                  color: Color(0xff666666),
                  iconSize: 30.0,
                  icon: Icon(Icons.settings),
                  onPressed: _jump2SettingPage,
                )
            ),
          ],
        ),
      ),
    );
  }

}