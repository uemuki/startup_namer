import 'package:flutter/material.dart';
import 'package:dokit/dokit.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/config/provider.dart';
import 'package:startup_namer/config/router.dart';

void main() {
  // runApp(MyApp());
  // 线下测试工具
  DoKit.runApp(
      app: DoKitApp(MyApp()),
      // 是否在release包内使用，默认release包会禁用
      useInRelease: true,
      releaseAction: () => {
            // release模式下执行该函数，一些用到runZone之类实现的可以放到这里，该值为空则会直接调用系统的runApp(MyApp())，
          });
  // 设置app风格
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // android
      statusBarBrightness: Brightness.light)); // ios
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  ThemeData defaultTargetPlatform;
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: "Friendlychat",
    //   home: new ChatScreen(),
    // );
    return OKToast(
      child: MultiProvider(
        providers: providers,
        child: MaterialApp(
          onGenerateRoute: YKDRouter.generateRoute,
          initialRoute: RouteName.appList,
        ),
      ),
    );
  }
}
