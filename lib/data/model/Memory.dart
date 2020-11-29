import 'dart:convert';

class Memory {
  final int id;
  final String title;
  final String picture;
  final String date;

  Memory(this.id, this.title, this.picture, this.date);

  @override
  String toString() {
    return 'Memory{id: $id, title: $title, picture: $picture, date: $date}';
  }

  factory Memory.fromJson(Map<String, dynamic> map) {
    return Memory(
      map["id"],
      map["title"],
      map["picture"],
      map["date"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "picture": picture,
      "date": date,
    };
  }

  static List<Memory> profileFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<Memory>.from(data.map((item) => Memory.fromJson(item)));
  }

  static String profileToJson(Memory data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }

  static bool profileFromJsonResponse(String jsonData) {
    final data = json.decode(jsonData);
    return data;
  }
}