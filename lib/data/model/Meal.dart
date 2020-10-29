class Meal {
  int id;
  String name;
  String description;
  String picture;
  String type;

  Meal(this.id, this.name, this.description, this.picture);

  Meal.withType(this.id, this.name, this.description, this.picture, this.type);

  @override
  String toString() {
    return 'Meal{id: $id, name: $name, description: $description, picture: $picture, type: $type}';
  }
}
