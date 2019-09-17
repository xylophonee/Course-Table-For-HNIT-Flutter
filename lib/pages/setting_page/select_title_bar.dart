import 'package:flutter/material.dart';

/*
  选择面板的标题
  包含取消按钮、确定按钮、中间的标题
  written by liuwenkiii on 2019/09/10
 */
class SelectTitleBar extends StatelessWidget {
  final String title;
  final onConfirm;

  const SelectTitleBar(
      {Key key, @required this.title, @required this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 4.0),
          child: FlatButton(
            child: Text(
              "取消",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 4.0),
          child: FlatButton(
            child: Text(
              "确定",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            onPressed: () => onConfirm(),
          ),
        )
      ],
    );
  }
}
