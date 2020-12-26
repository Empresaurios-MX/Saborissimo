import 'dart:convert';

class Meal {
  final int id;
  final String name;
  final String description;
  final String picture;
  final String type;

  Meal(this.id, this.name, this.description, this.picture, this.type);

  @override
  String toString() {
    return 'Meal{id: $id, name: $name, description: $description, picture: $picture, type: $type}';
  }

  factory Meal.fromJson(Map<String, dynamic> map) {
    return Meal(
      map["id"],
      map["name"],
      map["description"],
      map["picture"],
      map["type"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "picture": picture,
      "type": type,
    };
  }

  static List<Meal> profileFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<Meal>.from(data.map((item) => Meal.fromJson(item)));
  }

  static String profileToJson(Meal data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }

  static Map<String, dynamic> profileToMap(Meal data) {
    if(data == null) {
      return Meal(0, "N/A", "N/A", "N/A", "N/A").toJson();
    }
    return data.toJson();
  }

  static bool profileFromJsonResponse(String jsonData) {
    final data = json.decode(jsonData);
    return data;
  }
}
