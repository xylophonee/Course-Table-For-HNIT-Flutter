import 'package:flutter/material.dart';
import 'package:hgkcb/pages/setting_page/select_max_week.dart';
import 'package:hgkcb/pages/setting_page/select_theme.dart';
import 'package:hgkcb/pages/setting_page/select_week.dart';
import 'package:hgkcb/pages/setting_page/select_xq.dart';
import 'package:hgkcb/pages/setting_page/tap_bottom_sheet_option.dart';
import 'package:hgkcb/pages/setting_page/setting_tag.dart';
import 'package:hgkcb/util/data_util.dart';
import 'package:hgkcb/widgets/title_bar.dart';

/*
  设置页面
  written by liuwenkiii on 2019/09/10
 */
class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _xq;
  int _currentWeek;
  int _maxWeek;
  Future _future;

  @override
  void initState() {
    super.initState();
    _future = _setData();
  }

  Future _setData() async {
    _xq = await DataUtil.getXq();
    if (_xq.isEmpty) _xq = "默认";
    _currentWeek = await DataUtil.getCurrentWeek();
    _maxWeek = await DataUtil.getMaxWeek();
  }

  _onSelectCurrentWeek(int selectWeek) {
    setState(() {
      _currentWeek = selectWeek;
    });
  }

  _onSelectMaxWeek(int maxWeek) {
    setState(() {
      _maxWeek = maxWeek;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('no data');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text('loading...');
            case ConnectionState.done:
              if (snapshot.hasError)
                return Text('error: ${snapshot.error}');
              else
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      TitleBar(title: "设置"),
                      SettingTag("课表设置"),
                      TapBottomSheetOption(
                        mainText: "当前学期",
                        resultText: _xq,
                        showBottomSheet: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SelectXq();
                              });
                        },
                      ),
                      TapBottomSheetOption(
                        mainText: "当前周数",
                        resultText: "第 $_currentWeek 周",
                        showBottomSheet: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SelectWeek(
                                  maxWeek: _maxWeek,
                                  currentWeek: _currentWeek,
                                  callback: (currentWeek) =>
                                      _onSelectCurrentWeek(currentWeek),
                                );
                              });
                        },
                      ),
                      TapBottomSheetOption(
                        mainText: "总周数",
                        resultText: "$_maxWeek",
                        showBottomSheet: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SelectMaxWeek(
                                  maxWeek: _maxWeek,
                                  callback: (maxWeek) =>
                                      _onSelectMaxWeek(maxWeek),
                                );
                              });
                        },
                      ),
                      SettingTag("UI相关"),
                      TapBottomSheetOption(
                        mainText: "界面主题",
                        resultText: "默认",
                        showBottomSheet: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SelectTheme();
                              });
                        },
                      ),
                      SettingTag("其它"),
                      TapBottomSheetOption(
                        mainText: "关于湖工课程表",
                        resultText: " ",
                      ),
                    ],
                  ),
                );
          }
          return null;
        },
      ),
    );
  }
}
