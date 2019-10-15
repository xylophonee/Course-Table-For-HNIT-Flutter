import 'package:flutter/material.dart';
import 'package:hgkcb/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:hgkcb/util/system_util.dart';
import 'package:hgkcb/model/theme_model.dart';
import 'package:hgkcb/model/page_model.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<ThemeModel>.value(value: ThemeModel()),
      ChangeNotifierProvider<PageModel>.value(value: PageModel())
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemUtil.setBarColorLight();
    return MaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        );
      },
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
