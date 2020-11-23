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
}
