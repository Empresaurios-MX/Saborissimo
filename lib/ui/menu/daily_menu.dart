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
import 'package:saborissimo/ui/menu/create_menu.dart';
import 'package:saborissimo/ui/menu/meal_detail.dart';
import 'package:saborissimo/utils/utils.dart';

class DailyMenu extends StatefulWidget {
  final bool logged = true;

  @override
  _DailyMenuState createState() => _DailyMenuState();
}

class _DailyMenuState extends State<DailyMenu> {
  HashMap<Meal, bool> chosen = HashMap();

  Meal entrance;
  Meal middle;
  Meal stew;
  Meal drink;
  Meal dessert;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Names.menuAppBar, style: Styles.title(Colors.white)),
          backgroundColor: Palette.primary,
          actions: [
            if (widget.logged) createMenuIconButton(context),
            if (!widget.logged) createCartIconButton(context),
          ],
        ),
        drawer: DrawerApp(false),
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
    if (!widget.logged) {
      switch (meal.type) {
        case "ENTRANCE":
          {
            if (chosen.containsKey(entrance)) {
              chosen.update(entrance, (value) => false);
            }
            entrance = meal;
            chosen.update(entrance, (value) => true);
          }
          break;
        case "MIDDLE":
          {
            if (chosen.containsKey(middle)) {
              chosen.update(middle, (value) => false);
            }
            middle = meal;
            chosen.update(middle, (value) => true);
          }
          break;
        case "STEW":
          {
            if (chosen.containsKey(stew)) {
              chosen.update(stew, (value) => false);
            }
            stew = meal;
            chosen.update(stew, (value) => true);
          }
          break;
        case "DESSERT":
          {
            if (chosen.containsKey(dessert)) {
              chosen.update(dessert, (value) => false);
            }
            dessert = meal;
            chosen.update(dessert, (value) => true);
          }
          break;
        case "DRINK":
          {
            if (chosen.containsKey(drink)) {
              chosen.update(drink, (value) => false);
            }
            drink = meal;
            chosen.update(drink, (value) => true);
          }
          break;
      }
    }
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
      onPressed: () => Utils.pushRoute(
        context,
        ConfirmOrder(
          MenuOrder(
            0,
            entrance,
            middle,
            stew,
            dessert,
            drink,
          ),
        ),
      ).then((value) => setState(() => chosen = HashMap())),
    );
  }

  Widget createMenuIconButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.receipt_long),
      tooltip: 'Publicar menu',
      onPressed: () => Utils.pushRoute(context, CreateMenu()),
    );
  }

  List<Widget> createRow(BuildContext context, List<Meal> entrances) {
    List<Widget> cards = [];
    double dimension = 190;
    double fontSize = 20;

    if (entrances.length == 2) {
      dimension = 150;
    }
    if (entrances.length >= 3) {
      dimension = 110;
      fontSize = 15;
    }

    entrances.forEach(
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
