import 'package:saborissimo/data/model/Meal.dart';

class MenuOrder {
  final int id;
  final Meal entrance;
  final Meal middle;
  final Meal stew;
  final Meal dessert;
  final Meal drink;

  MenuOrder(this.id, this.entrance, this.middle, this.stew, this.dessert, this.drink);

  @override
  String toString() {
    return 'MenuOrder{id: $id, entrance: $entrance, middle: $middle, stew: $stew, dessert: $dessert, drink: $drink}';
  }
}