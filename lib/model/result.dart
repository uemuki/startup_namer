class Result {
  String code;
  bool success;
  String message;
  dynamic data;

  Result.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
    success = json['success'];
  }
}
