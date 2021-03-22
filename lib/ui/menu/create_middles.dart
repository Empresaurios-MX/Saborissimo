import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/data/service/MealsDataService.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/ui/menu/create_meal.dart';
import 'package:saborissimo/ui/menu/create_stews.dart';
import 'package:saborissimo/utils/navigation_utils.dart';
import 'package:saborissimo/utils/preferences_utils.dart';
import 'package:saborissimo/utils/printer.dart';
import 'package:saborissimo/widgets/no_items_message.dart';
import 'package:saborissimo/widgets/tile/image_checkbox_tile.dart';

class CreateMiddles extends StatefulWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Meal> entrances;

  CreateMiddles(this.entrances);

  @override
  _CreateMiddlesState createState() => _CreateMiddlesState();
}

class _CreateMiddlesState extends State<CreateMiddles> {
  String _token;
  MealsDataService _service;
  List<Meal> _meals = [];
  Map<Meal, bool> _selected = {};

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
        title: Text('Seleccione los platos medios'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => NavigationUtils.push(context, CreateMeal())
                .then((_) => refreshList()),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        mini: true,
        backgroundColor: Palette.accent,
        onPressed: () => attemptToGoNext(),
      ),
      body: createList(),
    );
  }

  void refreshList() {
    _service = MealsDataService(_token);
    _service.get().then((response) => setState(() => _meals = response));
  }

  void attemptToGoNext() {
    final List<Meal> selectedMeals = [];

    _selected.forEach((key, value) => {
          if (value) {selectedMeals.add(key)}
        });

    if (selectedMeals.isNotEmpty) {
      if (selectedMeals.length <= 3) {
        NavigationUtils.push(
          context,
          CreateStews(widget.entrances, selectedMeals),
        );
      } else {
        Printer.snackBar(
            widget._scaffoldKey, "Solo puede agregar un máximo de 3 platillos");
      }
    } else {
      Printer.snackBar(
          widget._scaffoldKey, "Debe agregar por lo menos 1 platillo");
    }
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
        title: 'Sin platos medios',
        subtitle: 'No hay platos medios registrados, registra uno seleccionando +',
        icon: Icons.no_meals,
      );
    }

    List<Meal> shortedMeals =
        _meals.where((meal) => meal.type == 'medio').toList();

    return ListView.builder(
      itemBuilder: (context, index) => createListTile(shortedMeals[index]),
      itemCount: shortedMeals.length,
    );
  }

  Widget createListTile(Meal meal) {
    _selected.putIfAbsent(meal, () => false);

    return ImageCheckboxTile(
      title: meal.name,
      imageUrl: meal.picture,
      checkedColor: Palette.done,
      isChecked: _selected[meal],
      checkListener: (value) =>
          setState(() => _selected.update(meal, (old) => !old)),
    );
  }
}
