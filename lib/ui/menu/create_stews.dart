import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/data/service/MealDataService.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/ui/menu/create_desserts.dart';
import 'package:saborissimo/utils/utils.dart';

class CreateStews extends StatefulWidget {
  final List<Meal> entrances;
  final List<Meal> middles;

  CreateStews(this.entrances, this.middles);

  @override
  _CreateStewsState createState() => _CreateStewsState();
}

class _CreateStewsState extends State<CreateStews> {
  Map<Meal, bool> selected = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Names.createStewsAppBar, style: Styles.title(Colors.white)),
        backgroundColor: Palette.primary,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        backgroundColor: Palette.accent,
        onPressed: () => Utils.pushRoute(
          context,
          CreateDesserts(widget.entrances, widget.middles, getSelected()),
        ),
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
}