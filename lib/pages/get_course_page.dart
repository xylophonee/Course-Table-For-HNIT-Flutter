import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hgkcb/pages/get_course_page/login_form.dart';
import 'package:hgkcb/event/events.dart';
import 'package:hgkcb/util/http_util.dart';
import 'package:hgkcb/util/system_util.dart';
import 'package:hgkcb/widgets/loading_dialog.dart';
import 'package:hgkcb/widgets/title_bar.dart';
import 'package:hgkcb/pages/get_course_page/warning_tip.dart';
import 'package:hgkcb/event/event_bus.dart';

/*
  获取课程的页面
  TODO: 将错误处理集中到另一个类中
  written by liuwenkiii on 2019/09/10
 */
class GetCoursePage extends StatefulWidget {
  @override
  _GetCoursePage createState() {
    return _GetCoursePage();
  }
}

class _GetCoursePage extends State<GetCoursePage> {
  //Http工具类
  HttpUtil httpUtil = HttpUtil();
  //控制滚动
  ScrollController controller = ScrollController();

  @override
  void dispose() {
    super.dispose();
    httpUtil.cancel();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _setEventListen();
  }

  _setEventListen() {
    eventBus.on<HttpEvent>().listen((event) {
      if (context != null) {
        if (event.responseResult == HttpEvent.getCourseSuccess) {
          SystemUtil.showToast("获取课表数据成功", Colors.green);
          eventBus.fire(RefreshEvent(RefreshType.courseTable));
          Navigator.of(context, rootNavigator: true).pop(true);
        } else if (event.responseResult == HttpEvent.loginFailed) {
          SystemUtil.showToast("请检查学号密码及验证码是否填写正确", Colors.red[700]);
          Navigator.of(context).pop();
        } else if (event.responseResult == HttpEvent.noTeachingAssessment) {
          SystemUtil.showToast("请先完成教学评价", Colors.red[700]);
          Navigator.of(context).pop();
        } else if (event.responseResult == HttpEvent.timeOut) {
          SystemUtil.showToast("请求超时", Colors.red[700]);
        } else if (event.responseResult == HttpEvent.serverRefused) {
          SystemUtil.showToast("请求被服务器拒绝", Colors.red[700]);
          Navigator.of(context).pop();
        } else if (event.responseResult == HttpEvent.vercodeFailed) {
          SystemUtil.showToast("验证码获取失败，请重试", Colors.red[700]);
        } else if (event.responseResult == HttpEvent.unknownError) {
          SystemUtil.showToast("未知错误", Colors.red[700]);
          Navigator.of(context).pop();
        }
      }
    });
    eventBus.on<LoadingEvent>().listen((event) {
      if (event.shouldShowLoadingDialog) {
        _showLoadingDialog();
      }
    });
  }

  _showLoadingDialog() async {
    var shouldPop = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return LoadingDialog();
        });
    if (shouldPop) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(
      width: 411,
      height: 731,
      allowFontScaling: false,
    )..init(context);
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: <Widget>[
            TitleBar(title: "获取课表", setPadding: false),
            Padding(
              padding: const EdgeInsets.only(left: 64.0, right: 64.0),
              child: Center(
                child: LoginForm(httpUtil, controller)
              ),
            ),
            WarningTip(),
          ],
        ),
      ),
    );
  }
}
