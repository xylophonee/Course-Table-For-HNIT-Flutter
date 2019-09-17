import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:hgkcb/model/theme_model.dart';
import 'package:hgkcb/pages/home_page/course_table/course_table_left_item.dart';

/*
  课表左侧的节次标记
  TODO: 加上上下课时间
  written by liuwenkiii on 2019/09/17
 */
class CourseTableLeft extends StatelessWidget{

  final double width;

  CourseTableLeft({this.width = 24.0});

  @override
  Widget build(BuildContext context) {
    Color textSecondaryColor =
        Provider.of<ThemeModel>(context).textSecondaryColor;
    List<CourseTableLeftItem> items = List<CourseTableLeftItem>();
    for (int i = 1; i < 13; i++) {
      items.add(CourseTableLeftItem(i.toString(), textSecondaryColor));
    }
    return Container(
      width: this.width,
      child: Column(
        children: items,
      ),
    );
  }

}