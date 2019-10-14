import 'package:flutter/material.dart';

class SettingCard extends StatelessWidget {

  final String title;

  final double titleSize;

  final Color primaryColor;

  final double fill;

  final List<Widget> children;

  const SettingCard(
      {Key key,
      @required this.title,
      @required this.primaryColor,
      @required this.children,
      this.fill = 16.0, this.titleSize = 16.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //color: Colors.red,
      margin: EdgeInsets.only(
        top: 0,
        left: fill,
        right: fill,
        bottom: fill,
      ),
      child: Card(
        elevation: 4.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: fill,
            bottom: fill,
          ),
          child: Column(
            children: <Widget>[

              // 左上角小标题
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(32.0),
                      bottomRight: Radius.circular(32.0),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    top: 1.0,
                    left: 16.0,
                    right: 16.0,
                    bottom: 2.0,
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleSize,
                    ),
                  ),
                ),
              ),

              // 选项
              Container(
                margin: EdgeInsets.only(top: fill),
                child: Column(
                  children: children,
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
