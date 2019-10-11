import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hgkcb/event/event_bus.dart';
import 'package:hgkcb/event/events.dart';
import 'package:hgkcb/model/theme_model.dart';
import 'package:provider/provider.dart';

/*
  主页面的下拉控件
  written by liuwenkiii on 2019/09/17
 */
class DropDown extends StatefulWidget {
  final Widget mainView;
  final Widget backView;

  const DropDown({Key key, @required this.mainView, @required this.backView})
      : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> with TickerProviderStateMixin {
  // 主要显示的视图
  Widget mainView;
  // 下拉展开显示的视图
  Widget backView;
  // 下拉还未展开时显示的视图
  Widget coverView;
  // mainView 的顶部高度
  double _mainViewTop = 0;
  // 是否为向下拖动
  bool isDropDown = false;
  // backView 的缩放值
  double _scaleValue = 0;
  // 传递的 offset 总量
  double totalTransferOffset = 0;
  // coverView 透明度
  double _coverViewOpacity = 1;
  // 下拉提示
  String tip = "tip";
  //下拉距离临界值
  static const double dragDistance = 150;

  @override
  void initState() {
    super.initState();
    mainView = widget.mainView;
    backView = widget.backView;
    eventBus
        .on<TransferDragUpdateEvent>()
        .listen((event) => _onVerticalDragUpdate(event.details));
    eventBus
        .on<TransferDragEndEvent>()
        .listen((event) => _onVerticalDragEnd(event.details));
  }

  // 获取缩放值, top 为 mainView 当前高度
  double _getScaleValue(double top) {
    double newScaleValue = top / ScreenUtil.screenHeightDp + 0.4;
    if (newScaleValue > 1) return 1;
    return newScaleValue;
  }

  // 计算 top 的值
  double _getTopValue(double dy) {
    double newTop = _mainViewTop + dy;
    if (newTop < 0) return 0;
    if (newTop > ScreenUtil.screenHeightDp) return ScreenUtil.screenHeightDp;
    return newTop;
  }

  double _getCoverOpacity(double top) {
    top -= dragDistance;
    if (top < 0) top = 0;
    double newOpacity = 1 - (top / (ScreenUtil.screenHeightDp - dragDistance));
    //print("top: $top, height: ${screenHeight * 0.75} opacity: $newOpacity");
    if (newOpacity > 1) return 1;
    if (newOpacity < 0) return 0;
    return newOpacity;
  }

  _onVerticalDragUpdate(DragUpdateDetails details) {
    //print(details.delta.direction);
    //记录滑动的方向
    if (details.delta.direction > 0) {
      isDropDown = true;
    } else {
      isDropDown = false;
    }
    //刷新视图
    setState(() {
      _mainViewTop = _getTopValue(details.delta.dy);
      _scaleValue = _getScaleValue(_mainViewTop);
      _coverViewOpacity = _getCoverOpacity(_mainViewTop);
    });
  }

  _onVerticalDragEnd(DragEndDetails details) {
    if (_mainViewTop == ScreenUtil.screenHeightDp || _mainViewTop == 0) return;
    if (isDropDown) {
      if (_mainViewTop > dragDistance)
        _open();
      else
        _close();
    } else {
      if (_mainViewTop < (ScreenUtil.screenHeightDp - dragDistance))
        _close();
      else
        _open();
    }
  }

  _open() {
    _doAnimation(_mainViewTop, ScreenUtil.screenHeightDp);
  }

  _close() {
    _doAnimation(_mainViewTop, 0);
  }

  _doAnimation(double begin, double end) {
    totalTransferOffset = 0;
    Animation<double> animation;
    final AnimationController controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    final Animation curve =
        CurvedAnimation(parent: controller, curve: Curves.easeOutCirc)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.dispose();
            }
          });
    animation = Tween<double>(begin: begin, end: end).animate(curve)
      ..addListener(() {
        double value = animation.value;
        setState(() {
          _mainViewTop = value;
          _scaleValue = _getScaleValue(value);
          _coverViewOpacity = _getCoverOpacity(value);
          //print(_mainViewTop);
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Provider.of<ThemeModel>(context).primaryColor;
    ScreenUtil.instance = ScreenUtil(
      width: 411,
      height: 731,
      allowFontScaling: false,
    )..init(context);
    return Container(
      child: GestureDetector(
        onVerticalDragUpdate: (details) => _onVerticalDragUpdate(details),
        onVerticalDragEnd: (details) => _onVerticalDragEnd(details),
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Positioned(
              child: Transform.translate(
                offset:
                    Offset(0, (_mainViewTop - ScreenUtil.screenHeightDp) * 0.6),
                child: Transform.scale(
                  scale: _scaleValue,
                  child: Container(
                    height: ScreenUtil.screenHeightDp,
                    //color: Color(0xfffefefe),
                    child: backView,
                  ),
                ),
              ),
            ),
            IgnorePointer(
              ignoring: true,
              child: Opacity(
                opacity: _coverViewOpacity,
                child: Container(
                  color: Color(0xffdfdfdf),
                  height: _mainViewTop,
                  child: Center(
                    child: Text(tip),
                  ),
                ),
              ),
            ),
            Positioned(
              top: _mainViewTop,
              width: ScreenUtil.screenWidthDp,
              height: ScreenUtil.screenHeightDp,
              child: Container(
                color: primaryColor,
                child: mainView,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
