import 'package:flutter/material.dart';
/*
  页面模型数据
  保存一个布尔值用于判断是否需要进行课程弹出动画
  written by liuwenkiii on 2019/09/17
 */
class PageModel with ChangeNotifier {

  bool _animationComplete = false;

  bool get isAnimationComplete => _animationComplete;

  markedAsComplete() {
    _animationComplete = true;
    notifyListeners();
  }

}