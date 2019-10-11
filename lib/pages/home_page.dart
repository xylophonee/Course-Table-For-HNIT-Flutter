import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hgkcb/custom/drop_down.dart';
import 'package:hgkcb/model/theme_model.dart';
import 'package:hgkcb/pages/home_page/header_bar/header_bar.dart';
import 'package:hgkcb/pages/home_page/course_table/course_table_container.dart';
import 'package:hgkcb/util/http_util.dart';
import 'package:hgkcb/widgets/title_bar.dart';
import 'package:provider/provider.dart';

/*
  主页面
  written by liuwenkiii on 2019/09/10
 */
// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  //Http工具类
  HttpUtil httpUtil = HttpUtil();
  //控制滚动
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Provider.of<ThemeModel>(context).primaryColor;
    ScreenUtil.instance = ScreenUtil(
      width: 411,
      height: 731,
      allowFontScaling: false,
    )..init(context);
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        height: ScreenUtil.screenHeightDp,
        child: DropDown(
          mainView: Column(
            children: <Widget>[
              HeaderBar(),
              CourseTableContainer(),
            ],
          ),
          backView: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: <Widget>[
                TitleBar(title: "同步课表", setBackBtn: false, setPadding: false),
                Padding(
                  padding: const EdgeInsets.only(left: 64.0, right: 64.0),
                  //child: Center(child: Text("test")),
                ),
                //WarningTip(),
              ],
            ),
          ),
        ),
      ),
    );
  }

}