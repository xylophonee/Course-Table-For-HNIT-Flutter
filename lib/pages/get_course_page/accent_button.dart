import 'package:flutter/material.dart';

/*
  使用主要颜色的圆角按钮，只是暂时使用
  written by liuwenkiii on 2019/09/17
 */
class AccentButton extends StatelessWidget {

  final String text;
  final Function onPress;

  AccentButton(this.text, {this.onPress});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.blue,
      highlightColor: Colors.blue[700],
      colorBrightness: Brightness.dark,
      child: Padding(
        padding: const EdgeInsets.only(
            left: 14.0, right: 14.0, top: 10.0, bottom: 10.0),
        child: Text(
          text,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0)),
      onPressed: onPress,
    );
  }

}