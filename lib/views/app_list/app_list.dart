import 'package:flutter/material.dart';
import 'package:startup_namer/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/config/router.dart';

class AppListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<UserViewModel>(builder: (context, value, child) {
          if (value.user == null) {
            Future.microtask(
                () => Navigator.of(context).pushNamed(RouteName.login));
          }
          return Text(value.user?.nickName ?? "佚名");
        }),
      ),
    );
  }
}
