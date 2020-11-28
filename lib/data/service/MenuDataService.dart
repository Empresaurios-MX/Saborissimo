import 'package:http/http.dart' show Client;
import 'package:saborissimo/data/model/Menu.dart';
import 'package:saborissimo/data/service/ApiPath.dart';

class MenuDataService {
  final Client http = Client();
  final String token;

  MenuDataService(this.token);

  Future<Menu> get() async {
    final response = await http.get(
      "${ApiPath.API}/menu",
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      return Menu.profileFromJson(response.body);
    } else {
      return Future.error("Ha ocurrido un error, intente de nuevo");
    }
  }

  Future<bool> post(Menu menu) async {
    final response = await http.post(
      "${ApiPath.API}/menu",
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: Menu.profileToJson(menu),
    );

    if (response.statusCode == 200) {
      return Menu.profileFromJsonResponse(response.body);
    } else {
      return false;
    }
  }

  Future<bool> delete() async {
    final response = await http.delete(
      "${ApiPath.API}/menu",
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      return Menu.profileFromJsonResponse(response.body);
    } else {
      return false;
    }
  }
}
