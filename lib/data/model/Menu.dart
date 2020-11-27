import 'dart:convert';
import 'package:saborissimo/data/model/Meal.dart';

class Menu {
  final List<Meal> entrances;
  final List<Meal> middles;
  final List<Meal> stews;
  final List<Meal> desserts;
  final List<Meal> drinks;

  Menu(this.entrances, this.middles, this.stews, this.desserts, this.drinks);

  @override
  String toString() {
    return 'Menu{entrances: $entrances, middles: $middles, stews: $stews, desserts: $desserts, drinks: $drinks}';
  }

  factory Menu.fromJson(Map<String, dynamic> map) {
    List<Meal> entrances = [];
    List<Meal> middles = [];
    List<Meal> stews = [];
    List<Meal> desserts = [];
    List<Meal> drinks = [];

    (map["entrances"] as List<dynamic>).forEach((element) => entrances.add(Meal(
          element["id"],
          element["name"],
          element["description"],
          element["picture"],
          element["type"],
        )));

    (map["middles"] as List<dynamic>).forEach((element) => middles.add(Meal(
      element["id"],
      element["name"],
      element["description"],
      element["picture"],
      element["type"],
    )));

    (map["stews"] as List<dynamic>).forEach((element) => stews.add(Meal(
      element["id"],
      element["name"],
      element["description"],
      element["picture"],
      element["type"],
    )));

    (map["desserts"] as List<dynamic>).forEach((element) => desserts.add(Meal(
      element["id"],
      element["name"],
      element["description"],
      element["picture"],
      element["type"],
    )));

    (map["drinks"] as List<dynamic>).forEach((element) => drinks.add(Meal(
      element["id"],
      element["name"],
      element["description"],
      element["picture"],
      element["type"],
    )));

    return Menu(
      entrances,
      middles,
      stews,
      desserts,
      drinks,
    );
  }

  Map<String, dynamic> toJson() {
/*    List<int> entrancesIds = [];
    List<int> middlesIds = [];
    List<int> stewsIds = [];
    List<int> dessertsIds = [];
    List<int> drinksIds = [];

    entrances.forEach((meal) => entrancesIds.add(meal.id));
    middles.forEach((meal) => middlesIds.add(meal.id));
    stews.forEach((meal) => stewsIds.add(meal.id));
    desserts.forEach((meal) => dessertsIds.add(meal.id));
    drinks.forEach((meal) => drinksIds.add(meal.id));*/

    return {
      "entrances": entrances,
      "middles": middles,
      "stews": stews,
      "desserts": desserts,
      "drinks": drinks,
    };
  }

  static Menu profileFromJson(String jsonData) {
    final data = json.decode(jsonData);
    print("-----------------------------------------------------data");
    //print(data[0]);
    print("-----------------------------------------------------data");
    return Menu.fromJson(data[0]);
  }

  static String profileToJson(Menu data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }

  static bool profileFromJsonResponse(String jsonData) {
    final data = json.decode(jsonData);
    return data;
  }
}
