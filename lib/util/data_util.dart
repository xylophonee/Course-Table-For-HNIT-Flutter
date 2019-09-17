import 'package:flutter_daydart/flutter_daydart.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
  获取保存在本地的数据
  written by liuwenkiii on 2019/09/10
 */
class DataUtil {

  static saveUsrInfo(String id, String passwd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("studentId", id);
    prefs.setString("passwd", passwd);
  }

  static Future<Map<String, String>> getUsrInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var map = new Map<String, String>();
    map['studentId'] = prefs.getString("studentId") ?? "";
    map['passwd'] = prefs.getString("passwd") ?? "";
    return map;
  }

  //保存学期
  static saveXq(String xq) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("xq", xq);
  }

  //获取学期
  static Future<String> getXq() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String xq = prefs.getString("xq") ?? "";
    return xq;
  }

  //保存起始周数的日期，存储的日期一定是当周的周一
  static saveDateOfStartWeek(List<String> date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("dateOfStartWeek", date);
  }

  //获取当前周数
  static Future<int> getCurrentWeek() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> date = prefs.getStringList("dateOfStartWeek") ??
        ["2019", "8", "26"];
    //存储的年月日（必定是周一）
    int Y = int.parse(date[0]);
    int M = int.parse(date[1]);
    int D = int.parse(date[2]);
    DateTime oldDate = DateTime(Y, M, D);
    num currentWeek = getThisMondayDate().difference(oldDate).inDays / 7;
    //print(currentWeek);
    return currentWeek.toInt() + 1;
  }

  //获取本周周一的日期
  static DateTime getThisMondayDate() {
    //当前年月日周
    int cY = DayDart().year();
    int cM = DayDart().month();
    int cD = DayDart().date();
    int cW = DayDart().day();
    return DateTime(cY, cM, cD - cW + 1);
  }

  //获取本周周一的DayDart对象
  static DayDart getThisMondayDayDart() {
    //当前年月日周
    int cW = DayDart().day();
    if (cW == 1) return DayDart();
    else return DayDart().subtract(cW - 1, Units.D);
  }

  //保存主题
  static saveTheme(int theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("theme", theme);
  }

  //设置最大周数
  static setMaxWeek(int maxWeek) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("maxWeek", maxWeek);
  }

  //获取最大周数
  static Future<int> getMaxWeek() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("maxWeek") ?? 23;
  }

}
