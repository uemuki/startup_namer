import 'package:startup_namer/provider/ykd_view_model.dart';
import 'package:startup_namer/model/user.dart';

class UserViewModel extends YKDViewModel {
  User _user;

  User get user => _user;

  Future<bool> login(String nickName) async {
    setBusy();
    this._user = (new User(nickName, "name"));
    setIdle();
    notifyListeners();
    return true;
  }
}
