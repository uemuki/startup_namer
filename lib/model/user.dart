// 文档地址https://flutter.cn/docs/development/data-and-backend/json
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String nickName;
  String name;
  User(this.nickName, this.name);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
