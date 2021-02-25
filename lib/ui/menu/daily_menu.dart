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
import 'package:saborissimo/widgets/material_dialog_neutral.dart';
import 'package:saborissimo/widgets/material_dialog_yes_no.dart';

class DailyMenu extends StatefulWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _DailyMenuState createState() => _DailyMenuState();
}

class _DailyMenuState extends State<DailyMenu> {
  bool _logged = false;
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
              _logged = false
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
        actions: createActions(),
      ),
      drawer: DrawerApp(),
      body: createMenu(),
    );
  }

  void refreshMenu() {
    MenuDataService service = MenuDataService("");
    resetSelection();
    service.get().then((response) => setState(() => {
          if (response.entrances.isNotEmpty)
            _menu = response
          else
            _menu = Menu([], [], [], [], []),
        }));
  }

  void deleteMenu() {
    String token = 'N/A';
    MenuDataService service;

    PreferencesUtils.getPreferences().then(
      (preferences) => {
        if (preferences.getBool(PreferencesUtils.LOGGED_KEY) ?? false)
          {
            token = preferences.getString(PreferencesUtils.TOKEN_KEY),
            service = MenuDataService(token),
            service
                .delete()
                .then(
                  (success) => {
                    if (success)
                      refreshMenu()
                    else
                      Utils.showSnack(
                        widget._scaffoldKey,
                        'Error, inicie sesión e intente de nuevo',
                      )
                  },
                )
                .catchError(
                  (_) => Utils.showSnack(
                    widget._scaffoldKey,
                    'Error, inicie sesión e intente de nuevo',
                  ),
                )
          }
      },
    );
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
    return _entrance != null &&
        _middle != null &&
        _stew != null &&
        _drink != null;
  }

  void resetSelection() {
    setState(
      () => {
        _menu = null,
        _entrance = null,
        _middle = null,
        _stew = null,
        _drink = null,
        _dessert = null,
      },
    );
  }

  void goToCart() {
    if (isValidOrder()) {
      Utils.pushRoute(
        context,
        ConfirmOrder(MenuOrder(0, _entrance, _middle, _stew, _dessert, _drink)),
      ).then((value) => refreshMenu());
    } else {
      Utils.showSnack(
        widget._scaffoldKey,
        'Su pedido esta incompleto!\nUn pedido completo consta de los 3 tiempos más la bebida',
      );
    }
  }

  List<Widget> createActions() {
    List<Widget> actions = [];

    actions.add(IconButton(
      icon: Icon(Icons.refresh),
      tooltip: 'Refrescar',
      onPressed: () => refreshMenu(),
    ));

    if (_logged) {
      actions.add(IconButton(
        icon: Icon(Icons.delete_forever),
        tooltip: 'Borrar menú',
        onPressed: () => showDialog(
          context: context,
          builder: (_) => MaterialDialogYesNo(
            title: 'Eliminar el menú del día',
            body: 'Esta acción eliminará el menú publicado para siempre.',
            positiveActionLabel: 'Eliminar',
            positiveAction: () => {deleteMenu(), Navigator.pop(context)},
            negativeActionLabel: "Cancelar",
            negativeAction: () => Navigator.pop(context),
          ),
        ),
      ));

      actions.add(IconButton(
        icon: Icon(Icons.receipt_long),
        tooltip: 'Publicar menu',
        onPressed: () => Utils.pushRoute(context, CreateEntrances()),
      ));
    } else {
      actions.add(IconButton(
        icon: Icon(Icons.help),
        tooltip: 'Ayuda',
        onPressed: () => showDialog(
          context: context,
          builder: (_) => MaterialDialogNeutral(
            'Ayuda',
            'Manten presionado cualquier platillo para agregarlo a tu orden',
          ),
        ),
      ));

      actions.add(IconButton(
        icon: Icon(Icons.shopping_cart),
        tooltip: 'Realizar pedido',
        onPressed: () => goToCart(),
      ));
    }

    return actions;
  }

  Widget createMenu() {
    List<Widget> rows = [];

    if (_menu != null) {
      if (_menu.entrances.isNotEmpty) {
        rows.add(createLabel('Entradas'));
        rows.add(createRow(_menu.entrances));
        rows.add(createLabel('Platos medios'));
        rows.add(createRow(_menu.middles));
        rows.add(createLabel('Platos fuertes'));
        rows.add(createRow(_menu.stews));
        rows.add(createLabel('Postres'));
        rows.add(createRow(_menu.desserts));
        rows.add(createLabel('Bebidas'));
        rows.add(createRow(_menu.drinks));
      } else {
        return Utils.createNoItemsMessage(
          'El menu de hoy no ha sido publicado aún, disculpe las molestias',
        );
      }
    } else {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Palette.accent),
        ),
      );
    }

    return ListView(children: rows);
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

  Widget createRow(List<Meal> meals) {
    List<Widget> cards = [];

    meals.forEach(
      (meal) => {cards.add(createCard(context, meal))},
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: cards,
      ),
    );
  }

  Widget createCard(context, Meal meal) {
    return InkWell(
      onTap: () => Utils.pushRoute(context, MealDetail(meal)),
      onLongPress: () => attemptToMark(meal),
      child: Container(
        color: Colors.transparent,
        width: 225,
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
                    height: 125,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                if (!isMarked(meal))
                  Text(
                    meal.name,
                    textAlign: TextAlign.center,
                    style: Styles.legend(20),
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
