import 'package:http/http.dart' show Client;
import 'package:saborissimo/data/model/Order.dart';

import 'ApiPath.dart';

class MenuOrderDataService {
  final Client http = Client();
  final String token;

  MenuOrderDataService(this.token);

  Future<List<Order>> get() async {
    final response = await http.get(
      "${ApiPath.API}/order",
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      return Order.profileFromJson(response.body);
    } else {
      return Future.error("Ha ocurrido un error, intente de nuevo");
    }
  }

  Future<bool> post(Order order) async {
    final response = await http.post(
      "${ApiPath.API}/order",
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: Order.profileToJson(order),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return Order.profileFromJsonResponse(response.body);
    } else {
      return false;
    }
  }

  Future<bool> put(Order order) async {
    final response = await http.put(
      "${ApiPath.API}/order/${order.id}",
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: Order.profileToJson(order),
    );

    if (response.statusCode == 200) {
      return Order.profileFromJsonResponse(response.body);
    } else {
      return false;
    }
  }

  Future<bool> delete() async {
    final response = await http.delete(
      "${ApiPath.API}/order",
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (response.statusCode == 200) {
      return Order.profileFromJsonResponse(response.body);
    } else {
      return false;
    }
  }
}
