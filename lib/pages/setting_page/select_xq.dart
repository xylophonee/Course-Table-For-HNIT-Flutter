import 'package:flutter/material.dart';
import 'package:hgkcb/model/theme_model.dart';
import 'package:hgkcb/pages/setting_page/select_title_bar.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

/*
  选择当前学期
  written by liuwenkiii on 2019/09/17
 */
class SelectXq extends StatefulWidget {
  @override
  _SelectXqState createState() => _SelectXqState();
}

class _SelectXqState extends State<SelectXq> {
  int startYear;
  int endYear;

  _onPicker1Change(int value) {
    setState(() {
      startYear = value;
    });
  }

  _onPicker2Change(int value) {
    setState(() {
      endYear = value;
    });
  }

  @override
  void initState() {
    super.initState();
    startYear = 2019;
    endYear = 2020;
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Provider.of<ThemeModel>(context).primaryColor;
    return Container(
      color: primaryColor,
      height: 300,
      child: Column(
        children: <Widget>[
          SelectTitleBar(title: "当前学期", onConfirm: null),
          Expanded(
            child: Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: NumberPicker.integer(
                        initialValue: startYear,
                        minValue: 2016,
                        maxValue: 2019,
                        onChanged: (value) => _onPicker1Change(value),
                      ),
                    ),
                    Center(
                      child: Text(" 没写完 "),
                    ),
                    Expanded(
                      child: NumberPicker.integer(
                        initialValue: endYear,
                        minValue: 2017,
                        maxValue: 2020,
                        onChanged: (value) => _onPicker2Change(value),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
