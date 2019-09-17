import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

/*
  系统工具类，包括状态栏、导航栏的颜色改变
  written by liuwenkiii on 2019/09/10
 */
class SystemUtil {

  // 获取状态栏高度
  // 可以用这个，也可以用 ScreenUtil里面的
  // written by liuwenkiii on 2019/09/10
  static double getStatusBarHeight() {
    return MediaQueryData.fromWindow(WidgetsBinding.instance.window).padding.top;
  }

  // 设置状态栏和导航栏颜色为亮色
  static void setBarColorLight() {
    SystemUiOverlayStyle uiStyle = const SystemUiOverlayStyle(
      systemNavigationBarColor: const Color(0xfffcfcfc),
      systemNavigationBarDividerColor: null,
      statusBarColor: const Color(0x00000000),
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(uiStyle);
  }

  // 设置状态栏和导航栏颜色为暗色
  static void setBarColorDark() {
    SystemUiOverlayStyle uiStyle = const SystemUiOverlayStyle(
      systemNavigationBarColor: const Color(0xff191919),
      systemNavigationBarDividerColor: null,
      statusBarColor: const Color(0x000000),
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(uiStyle);
  }

  // 弹出一个toast
  static void showToast(String text, Color color) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}