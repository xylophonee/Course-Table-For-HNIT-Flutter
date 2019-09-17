import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hgkcb/event/events.dart';
import 'package:hgkcb/event/event_bus.dart';
import 'package:hgkcb/model/course.dart';
import 'package:hgkcb/model/page_model.dart';
import 'package:hgkcb/util/database_util.dart';
import 'package:hgkcb/pages/home_page/course_table/course_item.dart';
import 'package:provider/provider.dart';

/*
  课程表
  written by liuwenkiii on 2019/09/17
 */
// ignore: must_be_immutable
class CourseTable extends StatefulWidget {
  //课表周次
  final int week;
  //当前周次单双周标志
  int flag;

  CourseTable({Key key, this.week}) : super(key: key) {
    if (week % 2 == 1)
      flag = Course.single;
    else
      flag = Course.double;
  }

  @override
  _CourseTableState createState() => _CourseTableState();
}

class _CourseTableState extends State<CourseTable> {

  Future _future;

  //db工具类
  DatabaseUtil db = DatabaseUtil();

  //课程数据list、courseItem list
  List<Course> courseList = List();

  List<Widget> courseItemList = List();

  //课程widget的宽度
  double itemWidth = (ScreenUtil.screenWidthDp - 24) / 7;

  //当前课程颜色的index
  int colorIndex = 0;

  //课程颜色list
  List<int> colors = [
    0xffd0e6f4,
    0xfffdb7bc,
    0xffb4e9e2,
    0xfffde38c,
    0xffacd9f3,
    0xffbecbff,
    0xffade6d8,
    0xfffacf5a,
    0xffffd3b6,
    0xffffecda,
    0xffe2f4c4,
    0xffa7d7c5,
    0xffdcf4f5,
    0xffdbd1f7,
    0xffdcf2e9
  ];

  @override
  void initState() {
    super.initState();
    _future = _getDataFromDb();
    _setOnRefreshListen();
  }

  _setOnRefreshListen() {
    eventBus.on<RefreshEvent>().listen((event) {
      if (event.refreshType == RefreshType.courseTable) _getDataFromDb();
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  Future _getDataFromDb() async {
    courseList.clear();
    List data = await db.getTotalList();
    if (data.length > 0) {
      data.forEach((user) {
        Course item = Course.fromMap(user);
        courseList.add(item);
      });
    } else {
      Course course = Course.create("无课表数据", "0", "no data", 4, 5, 4, "0", 0);
      courseList.add(course);
    }
    _buildCourseItemList();
  }

  bool _inCurrentWeek(String time, int flag) {
    //周次区间
    time.replaceAll("，", ",");
    List<String> weekRanges = time.split(",");
    //print(weekRanges);
    for (String week in weekRanges) {
      RegExp regExp = RegExp("-");
      if (regExp.hasMatch(week)) {
        List<String> range = week.split("-");
        int start = int.parse(range[0]);
        int end = int.parse(range[1]);
        if ((widget.week >= start) && (widget.week <= end)) {
          if (flag == widget.flag || flag == Course.common) return true;
        }
      } else {
        if (widget.week == int.parse(week)) {
          if (flag == widget.flag || flag == Course.common) return true;
        }
      }
    }
    return false;
  }

  _buildCourseItemList() {
    courseItemList.clear();
    int delay = 0;
    bool shouldDoAnimation =
        !Provider.of<PageModel>(context).isAnimationComplete;
    //print(shouldDoAnimation);
    courseList.forEach((course) {
      int color = colors[colorIndex % 15];
      colorIndex++;
      if (!_inCurrentWeek(course.week, course.flag)) {
        course.name = "[非本周]\n" + course.name;
        color = 0xffefefef;
        colorIndex--;
      }
      courseItemList.add(CourseItem(
        course: course,
        color: color,
        width: itemWidth,
        delay: delay,
        doAnimation: shouldDoAnimation,
      ));
      delay += 30;
    });
    setState(() {});
    Provider.of<PageModel>(context).markedAsComplete();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('no data');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text('loading...');
          case ConnectionState.done:
            if (snapshot.hasError)
              return Text('error: ${snapshot.error}');
            else
              return Expanded(
              child: Container(
                height: 720.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: courseItemList,
                ),
              ),
            );
        }
        return null;
      },
    );
  }
}
