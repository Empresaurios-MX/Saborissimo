import 'dart:convert';

import 'package:saborissimo/data/model/Meal.dart';

class MenuOrder {
  final int id;
  final Meal entrance;
  final Meal middle;
  final Meal stew;
  final Meal dessert;
  final Meal drink;

  MenuOrder(
      this.id, this.entrance, this.middle, this.stew, this.dessert, this.drink);

  @override
  String toString() {
    return 'MenuOrder{id: $id, entrance: $entrance, middle: $middle, stew: $stew, dessert: $dessert, drink: $drink}';
  }

  factory MenuOrder.fromJson(Map<String, dynamic> map) {
    return MenuOrder(
      map["id"],
      Meal.fromJson(map["entrance"]),
      Meal.fromJson(map["middle"]),
      Meal.fromJson(map["stew"]),
      Meal.fromJson(map["dessert"]),
      Meal.fromJson(map["drink"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "entrance": Meal.profileToMap(entrance),
      "middle": Meal.profileToMap(middle),
      "stew": Meal.profileToMap(stew),
      "dessert": Meal.profileToMap(dessert),
      "drink": Meal.profileToMap(drink)
    };
  }

  static String profileToJson(MenuOrder data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }
}
