import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';

class MealDetail extends StatelessWidget {
  final Meal meal;

  const MealDetail(this.meal);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name, style: Styles.title(Colors.white)),
        backgroundColor: Palette.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              meal.picture,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                meal.description,
                textAlign: TextAlign.justify,
                style: Styles.body(Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
