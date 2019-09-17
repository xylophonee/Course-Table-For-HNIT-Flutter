import 'package:flutter/material.dart';
import 'package:hgkcb/model/theme_model.dart';
import 'package:provider/provider.dart';

/*
  选择主题
  written by liuwenkiii on 2019/09/17
 */
class SelectTheme extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Provider.of<ThemeModel>(context).primaryColor;
    return Container(
      color: primaryColor,
      height: 400,
      child: Center(
        child: Text("还没写完"),
      ),
    );
  }

}