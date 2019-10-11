import 'package:flutter/material.dart';
import 'package:hgkcb/custom/circle.dart';
import 'package:hgkcb/event/event_bus.dart';
import 'package:hgkcb/event/events.dart';

/*
  TitleBar 右上角的圆形角标
  written by liuwenkiii on 2019/10/11
 */
class CornerCircle extends StatefulWidget {
  final double size;
  final IconData icon;
  final double iconSize;
  final bool doAnimation;

  @override
  State<CornerCircle> createState() => CornerCircleState();

  CornerCircle({this.size, this.icon, this.iconSize, this.doAnimation});
}

class CornerCircleState extends State<CornerCircle>
    with TickerProviderStateMixin {
  double progress = 0;

  @override
  void initState() {
    super.initState();
    if (widget.doAnimation) {
      eventBus
          .on<OnDropDownUpdateEvent>()
          .listen((event) => _updateProgress(event.progress));
    } else {
      progress = 1;
    }
  }

  _updateProgress(double p) {
    setState(() {
      progress = p;
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = widget.size;
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        // 背景
        Positioned(
          right: - (size * 0.4),
          top: - (size * 0.4),
          child: CustomPaint(
            size: Size(size, size),
            painter: Circle(color: Colors.blue, progress: progress),
          ),
        ),

        //图标
        Positioned(
          right: size * 0.2,
          top: size * 0.2,
          child: Icon(
            widget.icon ?? Icons.error,
            size: size * 0.5,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
