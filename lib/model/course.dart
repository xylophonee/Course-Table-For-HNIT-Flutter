/*
  课程对象，包含的方法为方便数据库存储而用
  written by liuwenkiii on 2019/09/17
 */
class Course {
  //课程名
  String name;
  //老师名
  String tName;
  //上课地点
  String place;
  //星期
  int weekday;
  //开始节次
  int start;
  //结束节次
  int end;
  //周
  String week;
  //判断单双周标志，0为正常，1为单周，2为双周
  int flag;
  static final int common = 0;
  static final int single = 1;
  static final int double = 2;

  Course();

  Course.create(this.name, this.tName, this.place, this.start, this.end,
      this.weekday, this.week, this.flag);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['name'] = name;
    map['tName'] = tName;
    map['place'] = place;
    map['start'] = start;
    map['end'] = end;
    map['weekday'] = weekday;
    map['week'] = week;
    map['flag'] = flag;
    return map;
  }

  static Course fromMap(Map<String, dynamic> map) {
    Course course = new Course();
    course.name = map['name'];
    course.tName = map['tName'];
    course.place = map['place'];
    course.start = map['start'];
    course.end = map['end'];
    course.weekday = map['weekday'];
    course.week = map['week'];
    course.flag = map['flag'];
    return course;
  }
}
