import 'package:flutter/material.dart';

/*
  主题数据模型
  written by liuwenkiii on 2019/09/17
 */
class ThemeModel with ChangeNotifier {

  Color _primaryColor = Color(0xfffcfcfc);
  Color _secondaryColor = Color(0xffeeeeee);
  Color _textPrimaryColor = Color(0xff191919);
  Color _textSecondaryColor = Color(0xff3f3f3f);
  Color _textGreyColor = Color(0xff6f6f6f);
  Color _accentColor = Colors.blue;
  Color _accentLightColor = Colors.blue[300];
  Color _accentDarkColor = Colors.blue[700];

  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;
  Color get textPrimaryColor => _textPrimaryColor;
  Color get textSecondaryColor => _textSecondaryColor;
  Color get textGreyColor => _textGreyColor;
  Color get accentColor => _accentColor;
  Color get accentLightColor => _accentLightColor;
  Color get accentDarkColor => _accentDarkColor;

  void useDarkTheme() {
    _primaryColor = Color(0xff191919);
    _secondaryColor = Color(0xff3f3f3f);
    _textPrimaryColor = Color(0xfffcfcfc);
    _textSecondaryColor = Color(0xffeeeeee);
    _textGreyColor = Color(0xff6f6f6f);
    notifyListeners();
  }

  void useLightTheme() {
    _primaryColor = Color(0xfffcfcfc);
    _secondaryColor = Color(0xffeeeeee);
    _textPrimaryColor = Color(0xff191919);
    _textSecondaryColor = Color(0xff3f3f3f);
    _textGreyColor = Color(0xff6f6f6f);
    notifyListeners();
  }

}