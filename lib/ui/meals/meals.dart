import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/data/service/MealsDataService.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/ui/drawer/drawer_app.dart';
import 'package:saborissimo/ui/menu/create_meal.dart';
import 'package:saborissimo/ui/menu/meal_detail.dart';
import 'package:saborissimo/utils/navigation_utils.dart';
import 'package:saborissimo/utils/preferences_utils.dart';
import 'package:saborissimo/utils/printer.dart';
import 'package:saborissimo/widgets/meal_list_tile.dart';
import 'package:saborissimo/widgets/no_items_message.dart';

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
    PreferencesUtils.getToken(
      (result) => {setState(() => _token = result), refreshList()},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(
        title: Text(Names.mealsAppBar),
        actions: [
          createRefreshButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => NavigationUtils.push(context, CreateMeal())
            .then((_) => refreshList()),
      ),
      drawer: DrawerApp(),
      body: createList(),
    );
  }

  void refreshList() {
    _service = MealsDataService(_token);
    _service.get().then(
        (response) => setState(() => _meals = response.reversed.toList()));
  }

  Widget createRefreshButton() {
    return IconButton(
      icon: Icon(Icons.refresh),
      tooltip: 'Refrescar',
      onPressed: () => refreshList(),
    );
  }

  Widget createList() {
    if(_meals == null) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Palette.accent),
        ),
      );
    }
    if (_meals.isEmpty) {
      return NoItemsMessage(
        title: 'Sin platillos',
        subtitle: 'No hay platillos registrados, registra uno seleccionando +',
        icon: Icons.no_meals,
      );
    }

    return ListView.builder(
      itemBuilder: (context, index) => MealListTile(
        meal: _meals[index],
        action: () => NavigationUtils.push(
          context,
          MealDetail(meal: _meals[index], logged: true),
        ).then((_) => refreshList()),
      ),
      itemCount: _meals.length,
    );
  }
}
