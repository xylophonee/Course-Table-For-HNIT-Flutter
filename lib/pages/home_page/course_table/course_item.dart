import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hgkcb/model/course.dart';

/*
  课程控件
  TODO：优化文本排版
  written by liuwenkiii on 2019/09/17
 */
// ignore: must_be_immutable
class CourseItem extends StatefulWidget {
  // 课程对象
  final Course course;

  // 课程名称
  String _courseName;

  // 课程地点
  String _place;

  // 课程颜色
  final int color;

  // 宽度
  final double width;

  // 最大行数
  int _maxLines;

  // 离顶部的距离
  double _top;

  // 离左边的距离
  double _left;

  // 高度
  double _height;

  // 动画延迟
  final int delay;

  // 是否进行动画
  bool doAnimation;

  CourseItem({this.course, this.color, this.width, this.delay,
      this.doAnimation}) {
    this._courseName = course.name;
    this._place = course.place
        .replaceAll("多媒体", "")
        .replaceAll("录播室", "")
        .replaceAll("语音室", "")
        .replaceAll("（", "")
        .replaceAll("）", "")
        .replaceAll("(", "")
        .replaceAll(")", "")
        .replaceAll("北区田径场", "北田径场")
        .replaceAll("南区田径场", "南田径场");
    _setCoursePos();
    //print("top = $_top, left = $_left, height = $_height");
  }

  _setCoursePos() {
    _top = (course.start - 1) * 60.0;
    _left = (course.weekday - 1) * this.width;
    _height = (course.end - course.start + 1) * 60.0;
    _maxLines = (course.end - course.start) * 5;
  }

  @override
  _CourseItemState createState() => _CourseItemState();
}

class _CourseItemState extends State<CourseItem> with TickerProviderStateMixin {
  AnimationController _controller;
  CurvedAnimation _animation;
  double _value = 0;

  @override
  void initState() {
    super.initState();
    if (widget.doAnimation) {
      _controller =
          AnimationController(vsync: this, duration: Duration(milliseconds: 300));
      _animation = new CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutBack,
      )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          //print('completed');
        } else if (status == AnimationStatus.dismissed) {
          //print('forward');
          _controller.forward();
        }
      })..addListener(() {
        setState(() {
          _value = _animation.value;
        });
      });
      Timer(Duration(milliseconds: widget.delay), () {
        _controller.forward();
      });
    } else {
      _value = 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget._left,
      top: widget._top,
      child: Transform.scale(
        scale: _value,
        child: Container(
          padding: EdgeInsets.all(2.0),
          width: widget.width,
          height: widget._height,
          child: Material(
              color: Color(widget.color),
              borderRadius: BorderRadius.circular(4.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        widget._courseName,
                        textAlign: TextAlign.center,
                        maxLines: widget._maxLines,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      widget._place,
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
