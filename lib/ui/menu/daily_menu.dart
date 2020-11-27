import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/data/model/Menu.dart';
import 'package:saborissimo/data/model/MenuOrder.dart';
import 'package:saborissimo/data/service/MenuDataService.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/ui/cart/confirm_order.dart';
import 'package:saborissimo/ui/drawer/drawer_app.dart';
import 'package:saborissimo/ui/menu/create_entrances.dart';
import 'package:saborissimo/ui/menu/meal_detail.dart';
import 'package:saborissimo/utils/PreferencesUtils.dart';
import 'package:saborissimo/utils/utils.dart';

class DailyMenu extends StatefulWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _DailyMenuState createState() => _DailyMenuState();
}

class _DailyMenuState extends State<DailyMenu> {
  bool _logged = false;
  String _token;
  MenuDataService _service;
  Menu _menu;

  Meal _entrance;
  Meal _middle;
  Meal _stew;
  Meal _drink;
  Meal _dessert;

  @override
  void initState() {
    PreferencesUtils.getPreferences()
        .then(
          (preferences) => {
            if (preferences.getBool(PreferencesUtils.LOGGED_KEY) ?? false)
              setState(() => _logged = true)
            else
              _logged = false,
            if (preferences.getString(PreferencesUtils.TOKEN_KEY) != null)
              _token = preferences.getString(PreferencesUtils.TOKEN_KEY)
            else
              _token = 'N/A'
          },
        )
        .then((_) => refreshMenu());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: widget._scaffoldKey,
        appBar: AppBar(
          title: Text(Names.menuAppBar, style: Styles.title(Colors.white)),
          backgroundColor: Palette.primary,
          actions: [createRefreshButton(), createIconButton(context)],
        ),
        drawer: DrawerApp(),
        body: SingleChildScrollView(
          child: createMenu(),
        ));
  }

  void refreshMenu() {
    _service = MenuDataService(_token);
    _service.get().then((response) => setState(() => {
          if (response.entrances.isNotEmpty)
            _menu = response
          else
            _menu = Menu([], [], [], [], []),
          resetSelection()
        }));
  }

  void attemptToMark(Meal meal) {
    if (!_logged) {
      if (meal.type == "entrada") {
        setState(() => _entrance = meal);
      }
      if (meal.type == "medio") {
        setState(() => _middle = meal);
      }
      if (meal.type == "guisado") {
        setState(() => _stew = meal);
      }
      if (meal.type == "postre") {
        setState(() => _dessert = meal);
      }
      if (meal.type == "bebida") {
        setState(() => _drink = meal);
      }
    }
  }

  bool isMarked(Meal meal) {
    if (!_logged) {
      if (meal.type == "entrada" && _entrance != null) {
        return _entrance.id == meal.id;
      }
      if (meal.type == "medio" && _middle != null) {
        return _middle.id == meal.id;
      }
      if (meal.type == "guisado" && _stew != null) {
        return _stew.id == meal.id;
      }
      if (meal.type == "postre" && _dessert != null) {
        return _dessert.id == meal.id;
      }
      if (meal.type == "bebida" && _drink != null) {
        return _drink.id == meal.id;
      }
    }

    return false;
  }

  bool isValidOrder() {
    return _entrance != null || _middle != null || _stew != null;
  }

  void resetSelection() {
    setState(
      () => {
        _entrance = null,
        _middle = null,
        _stew = null,
        _drink = null,
        _dessert = null,
      },
    );
  }

  Widget createIconButton(BuildContext context) {
    if (_logged) {
      return IconButton(
        icon: Icon(Icons.receipt_long),
        tooltip: 'Publicar menu',
        onPressed: () => Utils.pushRoute(context, CreateEntrances()),
      );
    }

    return IconButton(
        icon: Icon(Icons.shopping_cart),
        tooltip: 'Realizar pedido',
        onPressed: () => {
              if (isValidOrder())
                {
                  Utils.pushRoute(
                    context,
                    ConfirmOrder(
                      MenuOrder(
                        0,
                        _entrance,
                        _middle,
                        _stew,
                        _dessert,
                        _drink,
                      ),
                    ),
                  ).then((value) => resetSelection()),
                }
              else
                {
                  Utils.showSnack(widget._scaffoldKey, 'Su pedido esta vacío!'),
                }
            });
  }

  Widget createRefreshButton() {
    return IconButton(
      icon: Icon(Icons.refresh),
      tooltip: 'Refrescar',
      onPressed: () => refreshMenu(),
    );
  }

  Widget createMenu() {
    List<Widget> rows = [];

    if (_menu != null) {
      rows.add(createLabel('Entradas'));
      rows.add(drawRow(false, _menu.entrances));
      rows.add(createLabel('Platos medios'));
      rows.add(drawRow(false, _menu.middles));
      rows.add(createLabel('Platos fuertes'));
      rows.add(drawRow(false, _menu.stews));
      rows.add(createLabel('Postres'));
      rows.add(drawRow(false, _menu.desserts));
      rows.add(createLabel('Bebidas'));
      rows.add(drawRow(false, _menu.drinks));
    } else {
      rows.add(createLabel('Entradas'));
      rows.add(drawRow(true, null));
      rows.add(createLabel('Platos medios'));
      rows.add(drawRow(true, null));
      rows.add(createLabel('Platos fuertes'));
      rows.add(drawRow(true, null));
      rows.add(createLabel('Postres'));
      rows.add(drawRow(true, null));
      rows.add(createLabel('Bebidas'));
      rows.add(drawRow(true, null));
    }

    return Column(children: [...rows]);
  }

  Widget drawRow(bool loading, List<Meal> meals) {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Palette.accent),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: createRow(context, meals),
    );
  }

  Widget createLabel(String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Styles.title(Colors.black),
      ),
    );
  }

  List<Widget> createRow(BuildContext context, List<Meal> meals) {
    List<Widget> cards = [];
    double dimension = 190;
    double fontSize = 20;

    if (meals.length == 2) {
      dimension = 150;
    }
    if (meals.length >= 3) {
      dimension = 110;
      fontSize = 15;
    }

    meals.forEach(
      (meal) => {cards.add(createMiniCard(context, meal, dimension, fontSize))},
    );

    return cards;
  }

  Widget createMiniCard(context, Meal meal, dimension, fontSize) {
    Color color = Colors.transparent;

    return InkWell(
      onTap: () => Utils.pushRoute(context, MealDetail(meal)),
      onLongPress: () => attemptToMark(meal),
      child: Container(
        color: color,
        width: dimension,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    meal.picture,
                    height: dimension,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (!isMarked(meal))
                  Text(
                    meal.name,
                    textAlign: TextAlign.center,
                    style: Styles.legend(fontSize),
                    overflow: TextOverflow.clip,
                  ),
                if (isMarked(meal))
                  Container(
                    color: Colors.black54,
                    child: Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
