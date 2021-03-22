import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/utils/string_utils.dart';

class MealListTile extends StatelessWidget {
  final Meal meal;
  final Function action;

  MealListTile({this.meal, this.action});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => action(),
      contentPadding: EdgeInsets.all(0),
      leading: Image.network(
        meal.picture,
        width: 100,
        fit: BoxFit.cover,
      ),
      title: Text(
        meal.name,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      subtitle: Text(
        meal.type.capitalize(),
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
