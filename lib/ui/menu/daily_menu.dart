import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
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
  HashMap<Meal, bool> chosen = HashMap();
  bool _logged = false;

  Meal _entrance;
  Meal _middle;
  Meal _stew;
  Meal _drink;
  Meal _dessert;

  @override
  void initState() {
    PreferencesUtils.getPreferences().then(
      (preferences) => {
        if (preferences.getBool(PreferencesUtils.LOGGED_KEY) ?? false)
          {setState(() => _logged = true)}
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: widget._scaffoldKey,
        appBar: AppBar(
          title: Text(Names.menuAppBar, style: Styles.title(Colors.white)),
          backgroundColor: Palette.primary,
          actions: [
            if (_logged) createMenuIconButton(context),
            if (!_logged) createCartIconButton(context),
          ],
        ),
        drawer: DrawerApp(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              createLabel('Entradas'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: createRow(context, MenuDataService.menu.entrances),
              ),
              createLabel('Platos medios'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: createRow(context, MenuDataService.menu.middles),
              ),
              createLabel('Platos fuertes'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: createRow(context, MenuDataService.menu.stews),
              ),
              createLabel('Postres'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: createRow(context, MenuDataService.menu.desserts),
              ),
              createLabel('Bebidas'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: createRow(context, MenuDataService.menu.drinks),
              ),
            ],
          ),
        ));
  }

  void attemptToAddObject(Meal meal) {
    if (!_logged) {
      switch (meal.type) {
        case "ENTRANCE":
          {
            if (chosen.containsKey(_entrance)) {
              chosen.update(_entrance, (value) => false);
            }
            _entrance = meal;
            chosen.update(_entrance, (value) => true);
          }
          break;
        case "MIDDLE":
          {
            if (chosen.containsKey(_middle)) {
              chosen.update(_middle, (value) => false);
            }
            _middle = meal;
            chosen.update(_middle, (value) => true);
          }
          break;
        case "STEW":
          {
            if (chosen.containsKey(_stew)) {
              chosen.update(_stew, (value) => false);
            }
            _stew = meal;
            chosen.update(_stew, (value) => true);
          }
          break;
        case "DESSERT":
          {
            if (chosen.containsKey(_dessert)) {
              chosen.update(_dessert, (value) => false);
            }
            _dessert = meal;
            chosen.update(_dessert, (value) => true);
          }
          break;
        case "DRINK":
          {
            if (chosen.containsKey(_drink)) {
              chosen.update(_drink, (value) => false);
            }
            _drink = meal;
            chosen.update(_drink, (value) => true);
          }
          break;
      }
    }
  }

  bool isValidOrder() {
    return _entrance != null || _middle != null || _stew != null;
  }

  void resetSelection() {
    setState(
      () => {
        chosen = HashMap(),
        _entrance = null,
        _middle = null,
        _stew = null,
        _drink = null,
        _dessert = null,
      },
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

  Widget createCartIconButton(BuildContext context) {
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

  Widget createMenuIconButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.receipt_long),
      tooltip: 'Publicar menu',
      onPressed: () => Utils.pushRoute(context, CreateEntrances()),
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
    chosen.putIfAbsent(meal, () => false);

    return InkWell(
      onTap: () => Utils.pushRoute(context, MealDetail(meal)),
      onLongPress: () => setState(() => attemptToAddObject(meal)),
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
                if (!chosen[meal])
                  Text(
                    meal.name,
                    textAlign: TextAlign.center,
                    style: Styles.legend(fontSize),
                    overflow: TextOverflow.clip,
                  ),
                if (chosen[meal])
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
