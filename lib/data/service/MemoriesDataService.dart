import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:saborissimo/data/model/Memory.dart';
import 'package:saborissimo/data/model/Order.dart';

import 'ApiPath.dart';

class MemoriesDataService {
  final Client http = Client();
  final String token;

  MemoriesDataService(this.token);

  Future<List<Memory>> get() async {
    final response = await http.get(
      "${ApiPath.API}/memory",
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      return Memory.profileFromJson(utf8.decode(response.bodyBytes));
    } else {
      return Future.error("Ha ocurrido un error, intente de nuevo");
    }
  }

  Future<bool> post(Memory memory) async {
    final response = await http.post(
      "${ApiPath.API}/memory",
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: Memory.profileToJson(memory),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return Order.profileFromJsonResponse(response.body);
    } else {
      return false;
    }
  }

  Future<bool> delete(String id) async {
    final response = await http.delete(
      "${ApiPath.API}/memory/$id",
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      return Memory.profileFromJsonResponse(response.body);
    } else {
      return false;
    }
  }
}
