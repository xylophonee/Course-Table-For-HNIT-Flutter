import 'package:flutter/material.dart';
import 'package:hgkcb/model/theme_model.dart';
import 'package:provider/provider.dart';

/*
  设置界面的分类tag
 */
class SettingTag extends StatelessWidget {

  final String text;

  const SettingTag(this.text);

  @override
  Widget build(BuildContext context) {
    Color textGreyColor = Provider.of<ThemeModel>(context).textGreyColor;
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 4.0,
          bottom: 8.0,
          left: 24.0,
          right: 24.0,
        ),
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 14.0,
            color: textGreyColor,
          ),
        ),
      )
    );
  }

}