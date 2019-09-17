import 'package:dio/dio.dart';
import 'package:hgkcb/event/event_bus.dart';
import 'package:hgkcb/event/events.dart';
import 'package:hgkcb/model/course.dart';
import 'package:hgkcb/util/database_util.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

/*
  解析网页数据的工具类
  written by liuwenkiii on 2019/09/10
 */
class ParseUtil {

  static parseCourseTable(Response response) async {
    try {
      var document = parse(response.toString());
      var rowIndex = 0;
      List<Element> rows = document.body.querySelectorAll("#kbtable > tbody > tr");
      rows.forEach((row) {
        rowIndex++;
        var colIndex = -1;
        if (rowIndex > 1 && rowIndex < 7) {
          List<Element> cols = row.querySelectorAll("td");
          cols.forEach((col) {
            colIndex++;
            if (col.children.length > 1 && colIndex > 0) {
              List<Node> courseInfo = col.children[1].nodes;
              if (courseInfo.length > 1) {
                _parseAndSaveCourse(courseInfo, colIndex);
              }
            }
          });
        }
      });
    } catch(e) {
      print(e);
      eventBus.fire(HttpEvent(HttpEvent.unknownError));
    }
    eventBus.fire(HttpEvent(HttpEvent.getCourseSuccess));
  }

  static _parseAndSaveCourse(List<Node> courseInfo, int weekday) async {
    var info = Map<String, dynamic>();
    info['name'] = courseInfo[0].text;
    info['tName'] = courseInfo[4].text;
    info['place'] = courseInfo[7].nodes[1].text;
    info['weekday'] = weekday;
    //解析时间
    String time = courseInfo[6].text;
    print("course: ${info['name']}, time: $time");
    List<String> timeSplit = time.split("[");
    //周次
    RegExp flagExp1 = RegExp("单周");
    RegExp flagExp2 = RegExp("双周");
    String week;
    if (flagExp1.hasMatch(timeSplit[0])) {
      info['flag'] = Course.single;
      week = timeSplit[0].replaceAll("单周", "");
    } else if (flagExp2.hasMatch(timeSplit[0])) {
      info['flag'] = Course.double;
      week = timeSplit[0].replaceAll("双周", "");
    } else {
      info['flag'] = Course.common;
      week = timeSplit[0].replaceAll("周", "");
    }
    info['week'] = week;
    //节次
    String jcStr = timeSplit[1].replaceAll("节]", "");
    List<String> jc = jcStr.split("-");
    info['start'] = jcFix(jc[0]);
    info['end'] = jcFix(jc[1]);
    Course course = Course.fromMap(info);
    //print(course);
    DatabaseUtil databaseUtil = DatabaseUtil();
    databaseUtil.insertCourseItem(course);
  }

  /// 用于处理教务系统节次数据的错误
  /// 实在不好吐槽，强烈怀疑我们学校课表数据是手打的
  /// 01-02节 写成 01-20节，无语了
  /// written by liuwenkiii on 2019/09/11
  static int jcFix(String jc) {
    int j = num.parse(jc) as int;
    if (j > 12) j = (j / 10).round();
    return j;
  }

}
