import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/data/model/Menu.dart';
import 'package:saborissimo/data/model/MenuOrder.dart';
import 'package:saborissimo/data/service/MenuDataService.dart';
import 'package:saborissimo/res/strings.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/ui/cart/cart_review.dart';
import 'package:saborissimo/ui/drawer/drawer_app.dart';
import 'package:saborissimo/ui/menu/create_entrances.dart';
import 'package:saborissimo/ui/menu/meal_detail.dart';
import 'package:saborissimo/utils/navigation_utils.dart';
import 'package:saborissimo/utils/preferences_utils.dart';
import 'package:saborissimo/utils/printer.dart';
import 'package:saborissimo/widgets/material_dialog_neutral.dart';
import 'package:saborissimo/widgets/material_dialog_yes_no.dart';
import 'package:saborissimo/widgets/meal_grid_tile.dart';
import 'package:saborissimo/widgets/no_items_message.dart';
import 'package:saborissimo/widgets/rich_popup_menu.dart';

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
      appBar: AppBar(title: Text(DrawerApp.MENU), actions: createActions()),
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
                      Printer.snackBar(
                        widget._scaffoldKey,
                        'Error, inicie sesión e intente de nuevo',
                      )
                  },
                )
                .catchError(
                  (_) => Printer.snackBar(
                    widget._scaffoldKey,
                    'Error, inicie sesión e intente de nuevo',
                  ),
                )
          }
      },
    );
  }

  void addToCart(Meal meal) {
    if (!_logged) {
      if (meal.type == "entrada") {
        if (_entrance != null && _entrance.id == meal.id) {
          setState(() => _entrance = null);
        } else {
          setState(() => _entrance = meal);
        }
      }
      if (meal.type == "medio") {
        if (_middle != null && _middle.id == meal.id) {
          setState(() => _middle = null);
        } else {
          setState(() => _middle = meal);
        }
      }
      if (meal.type == "guisado") {
        if (_stew != null && _stew.id == meal.id) {
          setState(() => _stew = null);
        } else {
          setState(() => _stew = meal);
        }
      }
      if (meal.type == "postre") {
        if (_dessert != null && _dessert.id == meal.id) {
          setState(() => _dessert = null);
        } else {
          setState(() => _dessert = meal);
        }
      }
      if (meal.type == "bebida") {
        if (_drink != null && _drink.id == meal.id) {
          setState(() => _drink = null);
        } else {
          setState(() => _drink = meal);
        }
      }
    }
  }

  bool isInCart(Meal meal) {
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
      NavigationUtils.push(
        context,
        CartReview(MenuOrder(0, _entrance, _middle, _stew, _dessert, _drink)),
      ).then((value) => refreshMenu());
    } else {
      Printer.snackBar(
        widget._scaffoldKey,
        'Su pedido esta incompleto!\nUn pedido completo consta de los 3 tiempos más la bebida',
      );
    }
  }

  void actionClient(int selected) {
    switch (selected) {
      case 0:
        refreshMenu();
        break;
      case 1:
        showDialog(
          context: context,
          builder: (_) => MaterialDialogNeutral(
            'Ayuda',
            'Toca la imagen del platillo para ver mas detalles.',
          ),
        );
        break;
    }
  }

  void actionAdmin(int selected) {
    switch (selected) {
      case 0:
        refreshMenu();
        break;
      case 1:
        showDialog(
          context: context,
          builder: (_) => MaterialDialogYesNo(
            title: 'Eliminar el menú del día',
            body: 'Esta acción eliminará el menú publicado para siempre.',
            positiveActionLabel: 'Eliminar',
            positiveAction: () => {deleteMenu(), Navigator.pop(context)},
            negativeActionLabel: "Cancelar",
            negativeAction: () => Navigator.pop(context),
          ),
        );
        break;
    }
  }

  List<Widget> createActions() {
    List<Widget> actions = [];

    if (_logged) {
      actions = [
        IconButton(
          icon: Icon(Icons.receipt_long),
          tooltip: 'Publicar menu',
          onPressed: () => NavigationUtils.push(context, CreateEntrances()),
        ),
        RichPopupMenu(
          action: (int selected) => actionAdmin(selected),
          labels: ['Refrescar', 'Borrar menú'],
          icons: [Icons.refresh, Icons.delete],
        ),
      ];
    } else {
      actions = [
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () => goToCart(),
        ),
        RichPopupMenu(
          action: (int selected) => actionClient(selected),
          labels: ['Refrescar', 'Ayuda'],
          icons: [Icons.refresh, Icons.help],
        ),
      ];
    }

    return actions;
  }

  Widget createMenu() {
    List<Widget> tiles = [];

    if (_menu != null) {
      if (_menu.entrances.isNotEmpty) {
        _menu.entrances.forEach((meal) => tiles.add(
              MealGridTile(
                meal: meal,
                isSelected: () => this.isInCart(meal),
                goDetail: () =>
                    NavigationUtils.push(context, MealDetail(meal: meal)),
                addToCart: () => addToCart(meal),
              ),
            ));
        _menu.middles.forEach((meal) => tiles.add(
              MealGridTile(
                meal: meal,
                isSelected: () => this.isInCart(meal),
                goDetail: () =>
                    NavigationUtils.push(context, MealDetail(meal: meal)),
                addToCart: () => addToCart(meal),
              ),
            ));
        _menu.stews.forEach((meal) => tiles.add(
              MealGridTile(
                meal: meal,
                isSelected: () => this.isInCart(meal),
                goDetail: () =>
                    NavigationUtils.push(context, MealDetail(meal: meal)),
                addToCart: () => addToCart(meal),
              ),
            ));
        _menu.desserts.forEach((meal) => tiles.add(
              MealGridTile(
                meal: meal,
                isSelected: () => this.isInCart(meal),
                goDetail: () =>
                    NavigationUtils.push(context, MealDetail(meal: meal)),
                addToCart: () => addToCart(meal),
              ),
            ));
        _menu.drinks.forEach((meal) => tiles.add(
              MealGridTile(
                meal: meal,
                isSelected: () => this.isInCart(meal),
                goDetail: () =>
                    NavigationUtils.push(context, MealDetail(meal: meal)),
                addToCart: () => addToCart(meal),
              ),
            ));
      } else {
        return NoItemsMessage(
          title: 'Menu no disponible',
          subtitle:
              'El menu de hoy no ha sido publicado aún, disculpe las molestias',
          icon: Icons.watch_later,
        );
      }
    } else {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Palette.accent),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(3),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.90,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
        ),
        children: tiles,
      ),
    );
  }
}
