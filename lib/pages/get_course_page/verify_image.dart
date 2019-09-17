import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hgkcb/event/event_bus.dart';
import 'package:hgkcb/event/events.dart';
import 'package:hgkcb/util/http_util.dart';

/*
  验证码图片
  written by liuwenkiii on 2019/09/17
 */
class VerifyImage extends StatefulWidget {

  final HttpUtil httpUtil;

  VerifyImage(this.httpUtil);

  @override
  _VerifyImage createState() => _VerifyImage();

}

class _VerifyImage extends State<VerifyImage> {

  //验证码图片
  Widget verifyImageWidget;

  _getVerifyImage() {
    widget.httpUtil.getVercode().then((stream) {
      List<Uint8List> verifyImageData = new List();
      if (stream == null) {
        eventBus.fire(HttpEvent(HttpEvent.vercodeFailed));
        setState(() {
          verifyImageWidget = Center(
              child: Container(
                width: 124,
                height: 44,
                child: GestureDetector(
                  child: Center(
                    child: Text("点击重试"),
                  ),
                  onTap: _getVerifyImage,
                ),
              )
          );
        });
        return;
      }
      stream.listen((data) {
        //print(data);
        verifyImageData.add(data);
      }, onDone: () {
        setState(() {
          verifyImageWidget = InkWell(
            onTap: _getVerifyImage,
            child: Image.memory(
              _mergeUint8List(verifyImageData),
              fit: BoxFit.fitHeight,
            ),
          );
        });
      });
    });
  }

  Uint8List _mergeUint8List(List<Uint8List> verifyImageData) {
    int length = 0;
    int index = 0;
    verifyImageData.forEach((u8list) {
      length += u8list.length;
      //print("length = ${u8list.length}");
    });
    //print("total length = $length");
    Uint8List mergedU8List = new Uint8List(length);
    verifyImageData.forEach((u8list) {
      u8list.forEach((value) {
        mergedU8List[index] = value;
        index++;
      });
    });
    return mergedU8List;
  }

  @override
  void initState() {
    super.initState();
    verifyImageWidget = Center(child: Text("加载中"));
    _getVerifyImage();
    eventBus.on<HttpEvent>().listen((event) {
      if (event.responseResult == HttpEvent.loginFailed) {
        _getVerifyImage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 124,
          height: 44,
          color: Color(0xffcccccc),
          margin: EdgeInsets.only(top: 32.0, bottom: 4.0),
          child: verifyImageWidget,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 28.0),
          child: Center(
            child: Text(
              "点击刷新验证码",
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ],
    );
  }

}