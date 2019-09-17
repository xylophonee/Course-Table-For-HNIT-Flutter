import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hgkcb/event/event_bus.dart';
import 'package:hgkcb/event/events.dart';
import 'package:hgkcb/util/data_util.dart';
import 'package:provider/provider.dart';
import 'package:hgkcb/model/theme_model.dart';
import 'package:hgkcb/pages/home_page/header_bar/button_group.dart';

/*
  首页的头部，包含周次和一些功能按钮
  written by liuwenkiii on 2019/09/17
 */
class HeaderBar extends StatefulWidget {

  @override
  _HeaderBarState createState() => _HeaderBarState();

}

class _HeaderBarState extends State<HeaderBar> {

  String _week = "";
  int currentWeek = 0;
  double paddingTop = 0.0;

  _setCurrentWeek() async {
    int currentWeek = await DataUtil.getCurrentWeek();
    setState(() {
      _week = "第 $currentWeek 周";
    });
  }

  @override
  void initState() {
    super.initState();
    _setCurrentWeek();
    eventBus.on<PageEvent>().listen((event) {
      setState(() {
        _week = "第 ${event.page} 周";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Color textPrimaryColor = Provider.of<ThemeModel>(context).textPrimaryColor;
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtil.statusBarHeight + 8.0,
        bottom: 8.0
      ),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              eventBus.fire(Back2CurrentWeekEvent(true));
            },
            child: Container(
              padding: const EdgeInsets.only(
                  left: 36.0,
                  right: 0.0
              ),
              child: Center(
                child: Text(
                  _week,
                  style: TextStyle(
                    color: textPrimaryColor,
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          ButtonGroup(),
        ],
      ),
    );
  }

}

