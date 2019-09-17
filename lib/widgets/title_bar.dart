import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hgkcb/model/theme_model.dart';
import 'package:hgkcb/util/system_util.dart';
import 'package:provider/provider.dart';

/*
  页面顶部的title，没写完
  written by liuwenkiii on 2019/09/10
 */
class TitleBar extends StatelessWidget {

  final String title;

  final bool setPadding;

  final bool setBackBtn;

  TitleBar({this.title, this.setPadding = true, this.setBackBtn = true});

  @override
  Widget build(BuildContext context) {
    Color textPrimaryColor = Provider.of<ThemeModel>(context).textPrimaryColor;
    return Padding(
      padding: EdgeInsets.only(
        top: setPadding? SystemUtil.getStatusBarHeight() : 0,
      ),
      child: Container(
        //color: Colors.grey,
        height: 200,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Positioned(
              top: 30,
              left: 36,
              child: Container(
                //color: Colors.blue,
                width: 50,
                height: 50,
                child: setBackBtn? IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 42,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ) : null,
              ),
            ),
            Positioned(
              top: setBackBtn? 110 : 48,
              left: 48,
              child: Container(
                //color: Colors.red,
                height: 50,
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: textPrimaryColor),
                ),
              ),
            ),
            Container(
              width: ScreenUtil.screenWidthDp,
            )
          ],
        ),
      ),
    );
  }

}