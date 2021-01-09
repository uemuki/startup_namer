import 'package:flutter/cupertino.dart';
import 'package:startup_namer/views/app_list/app_list.dart';
import 'package:startup_namer/route/anim_route_builder.dart';
import 'package:startup_namer/views/login/login.dart';

class RouteName {
  static const String splash = 'splash';
  static const String appList = '/';
  static const String login = "login";
}

class YKDRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.appList:
        return NoAnimRouteBuilder(AppListPage());

      case RouteName.login:
        return NoAnimRouteBuilder(LoginPage());
    }
  }
}
