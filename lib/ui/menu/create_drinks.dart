import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/data/model/Menu.dart';
import 'package:saborissimo/data/service/MealsDataService.dart';
import 'package:saborissimo/data/service/MenuDataService.dart';
import 'package:saborissimo/res/strings.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/ui/menu/create_meal.dart';
import 'package:saborissimo/ui/menu/daily_menu.dart';
import 'package:saborissimo/utils/navigation_utils.dart';
import 'package:saborissimo/utils/preferences_utils.dart';
import 'package:saborissimo/utils/printer.dart';
import 'file:///C:/Users/daniel/Documents/AndroidStudio/saborissimo/lib/widgets/dialog/material_dialog_neutral.dart';
import 'package:saborissimo/widgets/no_items_message.dart';

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
        title: Text('Seleccione las bebidas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => NavigationUtils.push(context, CreateMeal())
                .then((_) => refreshList()),
          ),
        ],
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
                  {if (success) showDoneDialog() else showErrorMessage()},
            );
      } else {
        Printer.snackBar(
          widget._scaffoldKey,
          "Solo puede agregar un máximo de 3 platillos",
        );
      }
    } else {
      Printer.snackBar(
        widget._scaffoldKey,
        "Debe agregar por lo menos 1 platillo",
      );
    }
  }

  void showDoneDialog() {
    showDialog(
      context: context,
      builder: (_) => MaterialDialogNeutral('', 'Menú publicado con exito.'),
    ).then((_) => NavigationUtils.popAndReplace(context, DailyMenu()));
  }

  void showErrorMessage() {
    setState(() => working = false);

    Printer.snackBar(
      widget._scaffoldKey,
      "Ha ocurrido un error, intente de nuevo",
    );
  }

  Widget createList() {
    if (_meals == null) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Palette.accent),
        ),
      );
    }
    if (_meals.isEmpty) {
      return NoItemsMessage(
        title: 'Sin bebidas',
        subtitle: 'No hay bebidas registradas, registra una seleccionando +',
        icon: Icons.no_meals,
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
      title: Text(meal.name, style: Styles.subTitle()),
      secondary: Printer.createThumbnail(meal.picture),
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
