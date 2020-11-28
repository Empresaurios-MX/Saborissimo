import 'dart:convert';

class Client {
  final int id;
  final String name;
  final String phone;

  Client(this.id, this.name, this.phone);

  @override
  String toString() {
    return 'Client{id: $id, name: $name, phone: $phone}';
  }

  factory Client.fromJson(Map<String, dynamic> map) {
    return Client(
      map["id"],
      map["name"],
      map["phone"].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
    };
  }

  static String profileToJson(Client data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }
}
