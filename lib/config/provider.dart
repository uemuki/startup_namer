import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:startup_namer/view_model/user_view_model.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<UserViewModel>(
    create: (context) => UserViewModel(),
  ),
];
