import 'package:flutter/material.dart';
import 'package:flutter_daydart/flutter_daydart.dart';
import 'package:hgkcb/event/event_bus.dart';
import 'package:hgkcb/event/events.dart';
import 'package:hgkcb/model/theme_model.dart';
import 'package:hgkcb/pages/setting_page/select_title_bar.dart';
import 'package:hgkcb/util/data_util.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

/*
  选择当前周次
  written by liuwenkiii on 2019/09/17
 */
class SelectWeek extends StatefulWidget {
  final int maxWeek;
  final int currentWeek;
  final callback;

  SelectWeek(
      {Key key,
      @required this.maxWeek,
      @required this.currentWeek,
      @required this.callback})
      : super(key: key);

  @override
  _SelectWeek createState() => _SelectWeek();
}

class _SelectWeek extends State<SelectWeek> {
  int selectWeek;

  _onChange(int value) {
    setState(() {
      selectWeek = value;
    });
  }

  //根据选择的周数计算第一周周一的日期
  List<String> _transformWeek2Date(int week) {
    DayDart thisMonday = DataUtil.getThisMondayDayDart();
    DayDart firstWeekMonday = thisMonday.subtract((week - 1) * 7, Units.D);
    return [
      "${firstWeekMonday.year()}",
      "${firstWeekMonday.month()}",
      "${firstWeekMonday.date()}"
    ];
  }

  _saveCurrentWeek() {
    DataUtil.saveDateOfStartWeek(_transformWeek2Date(selectWeek));
    eventBus.fire(RefreshEvent(RefreshType.currentWeek));
    widget.callback(selectWeek);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    selectWeek = widget.currentWeek;
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Provider.of<ThemeModel>(context).primaryColor;
    return Container(
      color: primaryColor,
      height: 300,
      child: Column(
        children: <Widget>[
          SelectTitleBar(title: "当前周", onConfirm: _saveCurrentWeek),
          Expanded(
            child: Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: NumberPicker.integer(
                  initialValue: selectWeek,
                  minValue: 1,
                  maxValue: widget.maxWeek,
                  onChanged: (newValue) => _onChange(newValue),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
