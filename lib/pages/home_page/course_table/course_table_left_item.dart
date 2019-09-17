import 'package:flutter/widgets.dart';

/*
  课表左侧节次的单个控件
  written by liuwenkiii on 2019/09/17
 */
class CourseTableLeftItem extends StatelessWidget {

  final String text;
  final Color color;

  CourseTableLeftItem(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      child: Center(
        child: Text(
            this.text,
            style: TextStyle(color: this.color)
        ),
      ),
    );
  }

}