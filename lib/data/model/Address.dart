import 'dart:convert';

class Address {
  final int id;
  final String street1;
  final String street2;
  final String colony;
  final String references;

  Address(this.id, this.street1, this.street2, this.colony, this.references);

  @override
  String toString() {
    return 'Address{id: $id, street1: $street1, street2: $street2, colony: $colony, references: $references}';
  }

  factory Address.fromJson(Map<String, dynamic> map) {
    return Address(
      map["id"],
      map["street1"],
      map["street2"],
      map["colony"],
      map["references"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "street1": street1,
      "street2": street2,
      "colony": colony,
      "references": references,
    };
  }

  static String profileToJson(Address data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }
}
