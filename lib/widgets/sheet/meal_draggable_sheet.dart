import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/res/palette.dart';

class MealDraggableSheet extends StatelessWidget {
  final Meal meal;

  MealDraggableSheet(this.meal);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      builder: (ctx, controller) => SingleChildScrollView(
        controller: controller,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Palette.backgroundElevated,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Divider(
                thickness: 2,
                height: 30,
                color: Palette.primary,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20, top: 5),
                child: Text(
                  meal.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  meal.description,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
