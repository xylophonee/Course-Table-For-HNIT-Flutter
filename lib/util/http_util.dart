import 'dart:io';
import 'dart:typed_data';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:hgkcb/event/event_bus.dart';
import 'package:hgkcb/event/events.dart';
import 'package:hgkcb/util/data_util.dart';
import 'package:hgkcb/util/database_util.dart';
import 'package:hgkcb/util/parse_util.dart';

/*
  http 工具类
 */
class HttpUtil {
  //baseUrl
  static final String baseUrl = "http://jwgl.hnit.edu.cn";
  //验证码
  static final String verifyCodeUrl = "$baseUrl/verifycode.servlet";
  //登录
  static final String loginUrl = "$baseUrl/Logon.do?method=logon";
  //登录之后验证登录状态
  static final String loginVerifyUrl = "$baseUrl/Logon.do?method=logonBySSO";
  //课表数据post方法，可获取全校课表，可以通过设置学院班级对数据进行过滤
  static final String courseUrlPost =
      "$baseUrl/zcbqueryAction.do?method=goQueryZKbByXzbj";
  //课表数据get方法，获取当前登录账号的课表
  static final String courseUrlGet =
      "$baseUrl/tkglAction.do?method=goListKbByXs&istsxx=no&xnxqh=";
  //学生信息
  static final String studentInfoUrl =
      "$baseUrl/xszhxxAction.do?method=addStudentPic&tktime=";
  //成绩信息
  static final String gradeUrl = "$baseUrl/xszqcjglAction.do?method=queryxscj";

  Dio _dio;
  CancelToken token = CancelToken();

  HttpUtil() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 10000,
      receiveTimeout: 10000,
    );
    _dio = new Dio(options);
    _dio.interceptors.add(CookieManager(CookieJar()));
  }

  cancel() {
    if (token == null) return;
    token.cancel();
    //print("canceled");
  }

  Future<Stream<Uint8List>> getVercode() async {
    try {
      Response<ResponseBody> response = await _dio.get<ResponseBody>(
        verifyCodeUrl,
        options: Options(responseType: ResponseType.stream),
        cancelToken: token,
      );
      return response.data.stream;
    } on DioError catch (e) {
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        eventBus.fire(HttpEvent(HttpEvent.timeOut));
      }
    }
    return null;
  }

  login(String studentId, String password, String vercode) async {
    Map<String, dynamic> headers = {
      "Accept": "text/html, application/xhtml+xml, image/jxr, */*",
      "Referer": "http://jwgl.hnit.edu.cn/",
      "Accept-Language": "zh-Hans-CN,zh-Hans;q=0.8,en-US;q=0.5,en;q=0.3",
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko",
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept-Encoding": "gzip, deflate",
      "Host": "jwgl.hnit.edu.cn",
      "Connection": "Keep-Alive",
      "Pragma": "no-cache",
    };
    try {
      Response response = await _dio.post(
        loginUrl,
        cancelToken: token,
        data: {
          "USERNAME": studentId,
          "PASSWORD": password,
          "useDogCode": "",
          "RANDOMCODE": vercode,
          "x": "36",
          "y": "12",
        },
        options: Options(
          headers: headers,
          contentType: ContentType.parse("application/x-www-form-urlencoded"),
          responseType: ResponseType.plain,
        ),
      );
      if (response.statusCode == 200) {
        print(response.data.toString());
        _verifyLogin();
      } else {
        eventBus.fire(HttpEvent(HttpEvent.serverRefused));
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE) {
        eventBus.fire(HttpEvent(HttpEvent.loginFailed));
      }
    }

  }

  _verifyLogin() async {
    try {
      Response response = await _dio.post(
        loginVerifyUrl,
        data: {},
        cancelToken: token,
      );
      //print(response.data);
      if (response.statusCode == 200) {
        _getCourseTable();
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE) {
        eventBus.fire(HttpEvent(HttpEvent.loginFailed));
      }
    }
  }

  _getCourseTable() async {
    DatabaseUtil databaseUtil = new DatabaseUtil();
    databaseUtil.deleteAllCourse();
    String xq = await DataUtil.getXq();
    try {
      Response response = await _dio.get(
          courseUrlGet + xq,
          cancelToken: token,
          options: Options(
            headers: {
              "Accept": "text/html, application/xhtml+xml, image/jxr, */*",
              "Accept-Encoding": "deflate",
              "Accept-Language":
              "zh-Hans-CN, zh-Hans; q=0.8, en-US; q=0.5, en; q=0.3",
              "Host": "jwgl.hnit.edu.cn",
              "Pragma": "no-cache",
              "Proxy-Connection": "Keep-Alive",
              "User-Agent":
              "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko",
            },
            responseType: ResponseType.plain,
          ));
      ParseUtil.parseCourseTable(response);
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE) {
        eventBus.fire(HttpEvent(HttpEvent.loginFailed));
      }
    }
  }
}
