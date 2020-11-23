import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/data/service/MealDataService.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/ui/menu/create_meal.dart';
import 'package:saborissimo/ui/menu/create_middles.dart';
import 'package:saborissimo/utils/utils.dart';

class CreateEntrances extends StatefulWidget {
  @override
  _CreateEntrancesState createState() => _CreateEntrancesState();
}

class _CreateEntrancesState extends State<CreateEntrances> {
  MealDataService _service = MealDataService();
  Map<Meal, bool> _selected = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Names.createEntrancesAppBar, style: Styles.title(Colors.white)),
        backgroundColor: Palette.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Utils.pushRoute(context, CreateMeal()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        backgroundColor: Palette.accent,
        onPressed: () => Utils.pushRoute(context, CreateMiddles(getSelected())),
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
      onChanged: (value) => setState(() => _selected.update(meal, (old) => !old)),
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
