import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/data/model/Menu.dart';
import 'package:saborissimo/data/service/MealsDataService.dart';
import 'package:saborissimo/data/service/MenuDataService.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/ui/menu/daily_menu.dart';
import 'package:saborissimo/utils/PreferencesUtils.dart';
import 'package:saborissimo/utils/utils.dart';

class CreateDrinks extends StatefulWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Meal> entrances;
  final List<Meal> middles;
  final List<Meal> stews;
  final List<Meal> desserts;

  CreateDrinks(this.entrances, this.middles, this.stews, this.desserts);

  @override
  _CreateDrinksState createState() => _CreateDrinksState();
}

class _CreateDrinksState extends State<CreateDrinks> {
  bool working;
  String _token;
  MealsDataService _service;
  List<Meal> _meals = [];
  Map<Meal, bool> _selected = {};

  @override
  void initState() {
    working = false;
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
        title:
            Text(Names.createDrinksAppBar, style: Styles.title(Colors.white)),
        backgroundColor: Palette.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: createFAB(),
      body: createList(),
    );
  }

  void refreshList() {
    _service = MealsDataService(_token);
    _service.get().then((response) => setState(() => _meals = response));
  }

  void publishMenu() {
    final List<Meal> selectedMeals = [];

    _selected.forEach((key, value) => {
          if (value) {selectedMeals.add(key)}
        });

    if (selectedMeals.isNotEmpty) {
      if (selectedMeals.length <= 3) {
        MenuDataService service = MenuDataService(_token);

        final Menu menu = Menu(
          widget.entrances,
          widget.middles,
          widget.stews,
          widget.desserts,
          selectedMeals,
        );

        setState(() => working = true);

        service.post(menu).then(
              (success) =>
                  {if (success) showDoneDialog() else showErrorDialog()},
            );
      } else {
        Utils.showSnack(
            widget._scaffoldKey, "Solo puede agregar un máximo de 3 platillos");
      }
    } else {
      Utils.showSnack(
          widget._scaffoldKey, "Debe agregar por lo menos 1 platillo");
    }
  }

  void showDoneDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        title: Text(
          'Menú publicado con exito',
          textAlign: TextAlign.center,
          style: Styles.subTitle(Colors.black),
        ),
        content: Icon(
          Icons.done,
          color: Palette.done,
          size: 80,
        ),
      ),
    ).then((_) => {
          Navigator.of(context).popUntil((route) => route.isFirst),
          Utils.replaceRoute(context, DailyMenu()),
        });
  }

  void showErrorDialog() {
    setState(() => working = false);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
          title: Text(
            'Ha ocurrido un error, intente de nuevo',
            textAlign: TextAlign.center,
            style: Styles.subTitle(Colors.black),
          ),
          content: Icon(
            Icons.error,
            color: Palette.todo,
            size: 80,
          )),
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

    List<Meal> shortedMeals =
        _meals.where((meal) => meal.type == 'bebida').toList();

    return ListView.builder(
      itemBuilder: (context, index) => createListTile(shortedMeals[index]),
      itemCount: shortedMeals.length,
    );
  }

  Widget createListTile(Meal meal) {
    _selected.putIfAbsent(meal, () => false);

    return CheckboxListTile(
      contentPadding: EdgeInsets.all(10),
      title: Text(meal.name, style: Styles.subTitle(Colors.black)),
      secondary: Utils.createThumbnail(meal.picture),
      activeColor: Palette.done,
      value: _selected[meal],
      onChanged: (value) =>
          setState(() => _selected.update(meal, (old) => !old)),
    );
  }

  Widget createFAB() {
    if (working) {
      return Center();
    }

    return FloatingActionButton(
      backgroundColor: Palette.accent,
      mini: true,
      child: Icon(Icons.save),
      onPressed: publishMenu,
    );
  }
}
