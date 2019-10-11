import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hgkcb/custom/circle.dart';
import 'package:hgkcb/model/theme_model.dart';
import 'package:provider/provider.dart';

/*
  页面顶部的title
  written by liuwenkiii on 2019/09/10
 */
class TitleBar extends StatelessWidget {

  final String title;

  final bool setPadding;

  final bool setBackBtn;

  TitleBar({this.title, this.setPadding = false, this.setBackBtn = true});

  @override
  Widget build(BuildContext context) {
    Color textPrimaryColor = Provider.of<ThemeModel>(context).textPrimaryColor;
    ScreenUtil.instance = ScreenUtil(
      width: 411,
      height: 731,
      allowFontScaling: false,
    )..init(context);
    double statusBarHeight = ScreenUtil.statusBarHeight;
    double height = ScreenUtil.screenHeightDp * 0.2;
    double width = ScreenUtil.screenWidthDp;
    double lrDistance = width * 0.05;
    double tbDistance = height * 0.1 + statusBarHeight;
    double itemSize = height * 0.4;
    return Padding(
      padding: EdgeInsets.only(
        top: setPadding? statusBarHeight : 0,
      ),
      child: Container(
        //color: Colors.grey,
        height: height,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[

            // 返回按钮
            Positioned(
              bottom: tbDistance,
              left: lrDistance,
              child: Container(
                //color: Colors.blue,
                width: itemSize,
                height: itemSize,
                child: setBackBtn? IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: itemSize * 0.8,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ) : null,
              ),
            ),

            // 标题背景
            Positioned(
              right: - (height * 0.5),
              top: - (height * 0.5),
              child: CustomPaint(
                size: Size(height, height),
                painter: Circle(color: Colors.blue[300], progress: 1),
              ),
            ),

            // 标题
            Positioned(
              bottom: tbDistance,
              left: setBackBtn? itemSize + 36 : lrDistance * 2,
              child: Container(
                //color: Colors.red,
                height: itemSize,
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: textPrimaryColor
                  ),
                ),
              ),
            ),

            // 填充
            Container(
              width: ScreenUtil.screenWidthDp,
            )
          ],
        ),
      ),
    );
  }

}