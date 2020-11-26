import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/data/service/MealsDataService.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/ui/menu/create_desserts.dart';
import 'package:saborissimo/utils/PreferencesUtils.dart';
import 'package:saborissimo/utils/utils.dart';

class CreateStews extends StatefulWidget {
  final List<Meal> entrances;
  final List<Meal> middles;

  CreateStews(this.entrances, this.middles);

  @override
  _CreateStewsState createState() => _CreateStewsState();
}

class _CreateStewsState extends State<CreateStews> {
  String _token;
  MealsDataService _service;
  List<Meal> _meals = [];
  Map<int, bool> _selected = {};

  @override
  void initState() {
    PreferencesUtils.getPreferences()
        .then((preferences) => {
              if (preferences.getString(PreferencesUtils.TOKEN_KEY) != null)
                _token = preferences.getString(PreferencesUtils.TOKEN_KEY)
              else
                _token = 'N/A'
            })
        .then((_) => refreshList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Names.createStewsAppBar, style: Styles.title(Colors.white)),
        backgroundColor: Palette.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        mini: true,
        backgroundColor: Palette.accent,
        onPressed: () => Utils.pushRoute(
          context,
          CreateDesserts(widget.entrances, widget.middles, getSelected()),
        ),
      ),
      body: createList(),
    );
  }

  void refreshList() {
    _service = MealsDataService(_token);
    _service.get().then((response) => setState(() => _meals = response));
  }

  Widget createList() {
    if (_meals.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Palette.accent),
        ),
      );
    }

    List<Meal> shortedMeals =
        _meals.where((meal) => meal.type == 'entrada').toList();

    return ListView.builder(
      itemBuilder: (context, index) => createListTile(shortedMeals[index]),
      itemCount: shortedMeals.length,
    );
  }

  Widget createListTile(Meal meal) {
    _selected.putIfAbsent(meal.id, () => false);

    return CheckboxListTile(
      contentPadding: EdgeInsets.all(10),
      title: Text(meal.name, style: Styles.subTitle(Colors.black)),
      secondary: Utils.createThumbnail(meal.picture),
      activeColor: Palette.done,
      value: _selected[meal.id],
      onChanged: (value) =>
          setState(() => _selected.update(meal.id, (old) => !old)),
    );
  }

  List<Meal> getSelected() {
    final List<Meal> selectedNames = [];

    _selected.forEach((key, value) => {
          if (value) {selectedNames.add(Meal(key, '', '', '', ''))}
        });

    return selectedNames;
  }
}
