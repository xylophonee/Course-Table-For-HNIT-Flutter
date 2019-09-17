import 'package:flutter/widgets.dart';
import 'package:flutter_daydart/flutter_daydart.dart';
import 'package:hgkcb/event/event_bus.dart';
import 'package:hgkcb/event/events.dart';
import 'package:hgkcb/pages/home_page/course_table/course_table.dart';
import 'package:hgkcb/pages/home_page/course_table/course_table_header.dart';
import 'package:hgkcb/pages/home_page/course_table/course_table_left.dart';
import 'package:hgkcb/util/data_util.dart';

/*
  课程表容器
  这里通过插入一个中间层处理手势，EventBus一把梭
  written by liuwenkiii on 2019/09/17
 */
class CourseTableContainer extends StatefulWidget {
  CourseTableContainer({Key key}) : super(key: key);

  @override
  _CourseTableContainerState createState() => _CourseTableContainerState();
}

class _CourseTableContainerState extends State<CourseTableContainer> {

  PageController _controller;

  ScrollController _scrollController = ScrollController();

  Future _future;

  // 当前周数
  int _currentWeek;

  // 最大周数
  int _maxWeek;

  // 当前offset
  double currentOffset = 0;

  // offset最大值
  double maxOffset = 0;

  // 是否为向下拖动
  bool isDragDown = false;

  @override
  void initState() {
    super.initState();
    _future = _getData();
    _setEventListen();
  }

  _onVerticalDragUpdate(DragUpdateDetails details) {
    if (details.delta.direction > 0) {
      //向下
      currentOffset -= details.delta.distance;
      isDragDown = true;
      //print("向下 dy: ${details.delta.dy}");
    } else {
      //向上
      currentOffset += details.delta.distance;
      //print("向上 dy: ${details.delta.dy}");
    }
    if (currentOffset < 0) currentOffset = 0;
    if (currentOffset > maxOffset) currentOffset = maxOffset;
    //print("currentOffset: $currentOffset");
    //如果向下拖拽到了顶部则交给外层 DropDown 处理
    if (isDragDown && currentOffset == 0) {
      eventBus.fire(TransferDragUpdateEvent(details));
    }
    _scrollController.jumpTo(currentOffset);
  }

  _onVerticalDragEnd(DragEndDetails details) {
    eventBus.fire(TransferDragEndEvent(details));
  }

  _setEventListen() {
    eventBus.on<Back2CurrentWeekEvent>().listen((event) {
      if (event.shouldBack) {
        _back2CurrentWeek();
      }
    });
    eventBus.on<RefreshEvent>().listen((event) {
      if (event.refreshType == RefreshType.maxWeek) {
        _setMaxWeek();
      } else if (event.refreshType == RefreshType.currentWeek) {
        _setCurrentWeek();
      }
    });
  }

  Future _getData() async {
    _currentWeek = await DataUtil.getCurrentWeek();
    _maxWeek = await DataUtil.getMaxWeek();
    //若当前周数大于最大周数则设置当前周数为1
    if (_currentWeek > _maxWeek) _currentWeek = 1;
    _controller = PageController(initialPage: _currentWeek - 1);
  }

  _setCurrentWeek() async {
    _currentWeek = await DataUtil.getCurrentWeek();
  }

  _setMaxWeek() async {
    _maxWeek = await DataUtil.getMaxWeek();
  }

  _back2CurrentWeek() {
    //print("currentWeek: $currentWeek");
    _controller.animateToPage(_currentWeek - 1,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
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
                return PageView.builder(
                  onPageChanged: (int) {
                    eventBus.fire(PageEvent(int + 1));
                  },
                  controller: _controller,
                  itemCount: _maxWeek,
                  itemBuilder: (BuildContext context, int page) {
                    return Container(
                      child: Column(
                        children: <Widget>[
                          CourseTableHeader(weekday: DayDart().day()),
                          Expanded(
                            // 通过增加一个中间层控制课程表的滑动和外层滑动实现联动
                            child: GestureDetector(
                              onVerticalDragStart: (_) {
                                maxOffset = _scrollController
                                    .position.maxScrollExtent;
                              },
                              onVerticalDragUpdate: (details) =>
                                  _onVerticalDragUpdate(details),
                              onVerticalDragEnd: (details) =>
                                  _onVerticalDragEnd(details),
                              child: AbsorbPointer(
                                absorbing: true,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  controller: _scrollController,
                                  child: Row(
                                    children: <Widget>[
                                      CourseTableLeft(),
                                      CourseTable(week: page + 1),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
          }
          return null;
        },
      ),
    );
  }
}
