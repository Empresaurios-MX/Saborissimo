import 'dart:convert';

class LoginResponse {
  final String key;

  LoginResponse(this.key);

  @override
  String toString() {
    return 'LoginResponse{key: $key}';
  }

  factory LoginResponse.fromJson(Map<String, dynamic> map) {
    return LoginResponse(map["key"]);
  }

  static LoginResponse profileFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return LoginResponse.fromJson(data);
  }
}
