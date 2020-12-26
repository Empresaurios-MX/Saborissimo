import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:saborissimo/data/model/Login.dart';
import 'package:saborissimo/data/model/LoginResponse.dart';
import 'package:saborissimo/data/service/ApiPath.dart';

class AdminDataService {
  final Client http = Client();

  Future<LoginResponse> login(Admin admin) async {
    final response = await http.post(
      "${ApiPath.API}/login?password=${admin.password}&username=${admin.username}",
      headers: {"content-type": "application/json"},
    );

    if (response.statusCode == 200) {
      return LoginResponse.profileFromJson(utf8.decode(response.bodyBytes));
    } else {
      return Future.error("Ha ocurrido un error, intente de nuevo");
    }
  }
}
