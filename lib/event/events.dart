import 'package:flutter/widgets.dart';

// 请求课程表时发生的http事件
class HttpEvent {

  int responseResult;

  //登录成功
  static int getCourseSuccess = 0;
  //登录失败
  static int loginFailed = 1;
  //超时
  static int timeOut = 2;
  //服务器拒绝请求
  static int serverRefused = 3;
  //没有进行教学评价
  static int noTeachingAssessment = 4;
  //验证码获取失败
  static int vercodeFailed = 5;
  //未知错误
  static int unknownError = 9;

  HttpEvent(this.responseResult);

}

// 发生错误
class ErrorEvent {

  int error;

  ErrorEvent(this.error);

}

// 错误类型
class Error {
  //没有设置学期
  static int noXq = 0;
}

// 当数据发生变动需要刷新
class RefreshEvent {

  int refreshType;

  RefreshEvent(this.refreshType);

}

//数据刷新类型
class RefreshType {

  //课表数据改变
  static const courseTable = 0;
  //最大周数改变
  static const maxWeek = 1;
  //当前周改变
  static const currentWeek = 2;
  //当前学期改变
  static const currentXq = 3;

}

// 获取课程表时需要弹出loading dialog
class LoadingEvent {

  bool shouldShowLoadingDialog;

  LoadingEvent(this.shouldShowLoadingDialog);

}

// 左右滑动课表时触发的事件
class PageEvent {

  int page;

  PageEvent(this.page);

}

// 返回当前周次课表的事件
class Back2CurrentWeekEvent {

  bool shouldBack;

  Back2CurrentWeekEvent(this.shouldBack);

}

// 对课表点击事件拦截的事件
class AbsorbEvent {

  bool shouldAbsorb;

  AbsorbEvent(this.shouldAbsorb);

}

// 将课程表的滚动移交给外层处理
class TransferDragUpdateEvent {

  DragUpdateDetails details;

  TransferDragUpdateEvent(this.details);

}

class TransferDragEndEvent {

  DragEndDetails details;

  TransferDragEndEvent(this.details);

}