import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hgkcb/model/theme_model.dart';
import 'package:provider/provider.dart';

/*
  课表头部文本，用于判断是否当前星期
  如果是当前星期会加上一个灰色圆角背景
  TODO: 去掉其它周的显示
 */
// ignore: must_be_immutable
class CourseTableHeaderText extends StatelessWidget {
  final String text;
  final bool isCurrentWeekday;
  Color color = Colors.transparent;

  CourseTableHeaderText(this.text, this.isCurrentWeekday) {
    if (isCurrentWeekday) {
      color = Colors.grey[200];
    }
  }

  @override
  Widget build(BuildContext context) {
    Color textSecondaryColor = Provider.of<ThemeModel>(context).textSecondaryColor;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 4.0, right: 4.0),
        child: Material(
          type: MaterialType.card,
          color: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          child: Center(
            child: Text(
              this.text,
              style: TextStyle(
                color: textSecondaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }


}