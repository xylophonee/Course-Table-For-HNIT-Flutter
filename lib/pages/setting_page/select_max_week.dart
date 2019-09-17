import 'package:flutter/material.dart';
import 'package:hgkcb/model/theme_model.dart';
import 'package:hgkcb/pages/setting_page/select_title_bar.dart';
import 'package:hgkcb/util/data_util.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

/*
  选择最大周数
  written by liuwenkiii on 2019/09/17
 */
class SelectMaxWeek extends StatefulWidget {
  final int maxWeek;
  final callback;

  const SelectMaxWeek({Key key, @required this.maxWeek, this.callback})
      : super(key: key);

  @override
  _SelectMaxWeekState createState() => _SelectMaxWeekState();
}

class _SelectMaxWeekState extends State<SelectMaxWeek> {
  int _maxWeek;

  _onChange(int value) {
    setState(() {
      _maxWeek = value;
    });
  }

  _saveMaxWeek() {
    DataUtil.setMaxWeek(_maxWeek);
    Navigator.of(context).pop();
    widget.callback(_maxWeek);
  }

  @override
  void initState() {
    super.initState();
    _maxWeek = widget.maxWeek;
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Provider.of<ThemeModel>(context).primaryColor;
    return Container(
      color: primaryColor,
      height: 300,
      child: Column(
        children: <Widget>[
          SelectTitleBar(title: "总周数", onConfirm: _saveMaxWeek),
          Expanded(
            child: Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: NumberPicker.integer(
                  initialValue: _maxWeek,
                  minValue: 18,
                  maxValue: 30,
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
