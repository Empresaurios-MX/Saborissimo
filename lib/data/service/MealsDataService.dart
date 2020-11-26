import 'package:http/http.dart' show Client;
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/data/service/ApiPath.dart';

class MealsDataService {
  final Client http = Client();
  final String token;

  MealsDataService(this.token);

  Future<List<Meal>> get() async {
    final response = await http.get(
      "${ApiPath.API}/meal",
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      return Meal.profileFromJson(response.body);
    } else {
      return Future.error("Ha ocurrido un error, intente de nuevo");
    }
  }

  Future<bool> post(Meal meal) async {
    final response = await http.post(
      "${ApiPath.API}/meal",
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: Meal.profileToJson(meal),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> put(Meal meal) async {
    final response = await http.put(
      "${ApiPath.API}/meal",
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: Meal.profileToJson(meal),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> delete(String id) async {
    final response = await http.delete(
      "${ApiPath.API}/meal/$id",
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
