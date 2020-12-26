import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/data/service/MealsDataService.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/ui/drawer/drawer_app.dart';
import 'package:saborissimo/ui/meals/meals_detail.dart';
import 'package:saborissimo/ui/menu/create_meal.dart';
import 'package:saborissimo/ui/menu/create_middles.dart';
import 'package:saborissimo/utils/PreferencesUtils.dart';
import 'package:saborissimo/utils/utils.dart';

class Meals extends StatefulWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _MealsState createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  String _token;
  MealsDataService _service;
  List<Meal> _meals = [];

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
      key: widget._scaffoldKey,
      appBar: AppBar(
        title: Text(Names.mealsAppBar, style: Styles.title(Colors.white)),
        backgroundColor: Palette.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Utils.pushRoute(context, CreateMeal())
                .then((_) => refreshList()),
          ),
          createRefreshButton(),
        ],
      ),
      drawer: DrawerApp(),
      body: createList(),
    );
  }

  void refreshList() {
    _service = MealsDataService(_token);
    _service.get().then((response) => setState(() => _meals = response.reversed.toList()));
  }

  Widget createRefreshButton() {
    return IconButton(
      icon: Icon(Icons.refresh),
      tooltip: 'Refrescar',
      onPressed: () => refreshList(),
    );
  }

  Widget createList() {
    if (_meals.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Palette.accent),
        ),
      );
    }

    return ListView.builder(
      itemBuilder: (context, index) => createListTile(_meals[index]),
      itemCount: _meals.length,
    );
  }

  Widget createListTile(Meal meal) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 5),
      leading: Utils.createThumbnail(meal.picture),
      title: Text(meal.name, style: Styles.subTitle(Colors.black)),
      subtitle: Text(meal.type.toUpperCase(), style: Styles.body(Colors.black)),
      onTap: () => Utils.pushRoute(context, MealsDetail(meal)).then((_) => refreshList()),
    );
  }
}
