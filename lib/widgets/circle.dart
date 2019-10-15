import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

class Circle extends CustomPainter {

  Paint mPaint;

  final Color color;

  final double progress;

  Circle({this.color, this.progress}) {
    mPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    double centerX = width / 2;
    double centerY = height / 2;
    mPaint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(width, height), [color, Color(0xff66ccff)]);
    //canvas.drawRect(Rect.fromPoints(Offset(0, height), Offset(width, 0)), mPaint);
    canvas.drawCircle(Offset(centerX, centerY), width * progress, mPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }


}