import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/data/service/MealDataService.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/ui/menu/create_drinks.dart';
import 'package:saborissimo/utils/utils.dart';

class CreateDesserts extends StatefulWidget {
  final List<Meal> entrances;
  final List<Meal> middles;
  final List<Meal> stews;

  CreateDesserts(this.entrances, this.middles, this.stews);

  @override
  _CreateDessertsState createState() => _CreateDessertsState();
}

class _CreateDessertsState extends State<CreateDesserts> {
  MealDataService _service = MealDataService();
  Map<Meal, bool> _selected = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(Names.createDessertsAppBar, style: Styles.title(Colors.white)),
        backgroundColor: Palette.primary,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        backgroundColor: Palette.accent,
        onPressed: () => Utils.pushRoute(
          context,
          CreateDrinks(
              widget.entrances, widget.middles, widget.stews, getSelected()),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => createListTile(_service.meals[index]),
        itemCount: _service.meals.length,
      ),
    );
  }

  Widget createListTile(Meal meal) {
    _selected.putIfAbsent(meal, () => false);

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
      value: _selected[meal],
      onChanged: (value) =>
          setState(() => _selected.update(meal, (old) => !old)),
    );
  }

  List<Meal> getSelected() {
    final List<Meal> selectedNames = [];

    _selected.forEach((key, value) => {
          if (value) {selectedNames.add(key)}
        });

    return selectedNames;
  }
}
