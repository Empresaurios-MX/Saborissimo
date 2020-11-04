import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/data/model/Menu.dart';
import 'package:saborissimo/data/service/MealDataService.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';

class CreateDrinks extends StatefulWidget {
  final List<Meal> entrances;
  final List<Meal> middles;
  final List<Meal> stews;
  final List<Meal> desserts;

  CreateDrinks(this.entrances, this.middles, this.stews, this.desserts);

  @override
  _CreateDrinksState createState() => _CreateDrinksState();
}

class _CreateDrinksState extends State<CreateDrinks> {
  Map<Meal, bool> selected = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(Names.createDrinksAppBar, style: Styles.title(Colors.white)),
        backgroundColor: Palette.primary,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        backgroundColor: Palette.accent,
        onPressed: () => {},
      ),
      body: ListView.builder(
        itemBuilder: (context, index) =>
            createListTile(MealDataService.meals[index]),
        itemCount: MealDataService.meals.length,
      ),
    );
  }

  Widget createListTile(Meal meal) {
    selected.putIfAbsent(meal, () => false);

    return CheckboxListTile(
      contentPadding: EdgeInsets.all(10),
      title: Text(meal.name, style: Styles.subTitle(Colors.black)),
      secondary: Image.network(
        meal.picture,
        height: double.infinity,
        width: 100,
        fit: BoxFit.cover,
      ),
      activeColor: Palette.done,
      value: selected[meal],
      onChanged: (value) =>
          setState(() => selected.update(meal, (old) => !old)),
    );
  }

  List<Meal> getSelected() {
    final List<Meal> selectedNames = [];

    selected.forEach((key, value) => {
          if (value) {selectedNames.add(key)}
        });

    return selectedNames;
  }

  void publishMenu() {
    final Menu menu = Menu(
      widget.entrances,
      widget.middles,
      widget.stews,
      widget.desserts,
      getSelected(),
    );
  }
}
