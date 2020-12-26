import 'dart:convert';

import 'package:saborissimo/data/model/Address.dart';
import 'package:saborissimo/data/model/Client.dart';
import 'package:saborissimo/data/model/MenuOrder.dart';

class Order {
  static final String isOrder = 'PEDIDO';
  static final String isReserved = 'APARTADO';

  final int id;
  bool state;
  final MenuOrder menuOrder;
  final String orderType;
  final String extras;
  final String comments;
  final Address address;
  final Client client;

  Order(this.id, this.state, this.menuOrder, this.orderType, this.extras,
      this.comments, this.address, this.client);

  @override
  String toString() {
    return 'Order{id: $id, state: $state, menuOrder: $menuOrder, orderType: $orderType, extras: $extras, address: $address, client: $client}';
  }

  factory Order.fromJson(Map<String, dynamic> map) {
    return Order(
      map["id"],
      map["state"],
      MenuOrder.fromJson(map["menuOrder"]),
      map["orderType"],
      map["extras"],
      map["comments"],
      Address.fromJson(map["address"]),
      Client.fromJson(map["client"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "\"id\"": id,
      "\"state\"": state,
      "\"menuOrder\"": MenuOrder.profileToJson(menuOrder),
      "\"orderType\"": "\"" + orderType + "\"",
      "\"extras\"": "\"" + extras + "\"",
      "\"comments\"": "\"" + comments + "\"",
      "\"address\"": Address.profileToJson(address),
      "\"client\"": Client.profileToJson(client),
    };
  }

  static List<Order> profileFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<Order>.from(data.map((item) => Order.fromJson(item)));
  }

  static String profileToJson(Order data) {
    return data.toJson().toString();
  }

  static bool profileFromJsonResponse(String jsonData) {
    final data = json.decode(jsonData);
    return data;
  }
}
