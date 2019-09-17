import 'package:flutter/widgets.dart';
import 'package:hgkcb/pages/home_page/course_table/course_table_header_text.dart';

/*
  课表头部，用于显示星期
  TODO: 加上日期显示
 */
// ignore: must_be_immutable
class CourseTableHeader extends StatelessWidget {

  final int weekday;
  List<Widget> weekdayWidgets = List();
  List<String> weekdayText = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"];

  CourseTableHeader({this.weekday}) {
    weekdayWidgets.add(Container(width: 24.0));
    for (int i = 1; i <= 7; i++) {
      bool isCurrentWeekday = false;
      if (weekday == i) {
        isCurrentWeekday = true;
      }
      weekdayWidgets.add(CourseTableHeaderText(weekdayText[i - 1], isCurrentWeekday));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: weekdayWidgets,
      ),
    );
  }

}
