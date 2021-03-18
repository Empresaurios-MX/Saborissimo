import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/data/service/MealsDataService.dart';
import 'package:saborissimo/res/messages.dart';
import 'package:saborissimo/utils/firebase_storage_helper.dart';
import 'package:saborissimo/utils/preferences_utils.dart';
import 'package:saborissimo/widgets/dialog/material_dialog_yes_no.dart';
import 'file:///C:/Users/daniel/Documents/AndroidStudio/saborissimo/lib/widgets/sheet/meal_draggable_sheet.dart';

class MealDetail extends StatelessWidget {
  final Meal meal;
  final bool logged;

  const MealDetail({this.meal, this.logged = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      floatingActionButton: logged ? DeleteMealButton(meal) : Container(),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              meal.picture,
              fit: BoxFit.fill,
            ),
          ),
          MealDraggableSheet(meal),
        ],
      ),
    );
  }
}

class DeleteMealButton extends StatefulWidget {
  final Meal meal;

  DeleteMealButton(this.meal);

  @override
  _DeleteMealButtonState createState() => _DeleteMealButtonState();
}

class _DeleteMealButtonState extends State<DeleteMealButton> {
  bool _working;
  String token;

  @override
  void initState() {
    _working = false;
    PreferencesUtils.getToken((result) => setState(() => token = result));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: getIcon(),
      onPressed: () => startWork(),
    );
  }

  void startWork() {
    if (_working) {
      return;
    }

    showDialog(
      context: context,
      builder: (_) => MaterialDialogYesNo(
        title: 'Eliminar platillo',
        body:
        'Esta acción eliminará el platillo ${this.widget.meal.name} para siempre.',
        positiveActionLabel: 'Eliminar',
        positiveAction: () => {deleteMeal(), Navigator.of(context).pop()},
        negativeActionLabel: "Cancelar",
        negativeAction: () => Navigator.of(context).pop(),
      ),
    );
  }

  void deleteMeal() {
    MealsDataService service = MealsDataService(token);

    setState(() => _working = true);
    service
        .delete(widget.meal.id.toString())
        .then(
          (success) => {
        if (success)
          {
            FirebaseStorageHelper.deleteFile(widget.meal.picture),
            Navigator.of(context).pop(),
          }
        else
          showErrorMessage(),
      },
    )
        .catchError(
          (_) => showErrorMessage(),
    );
  }

  void showErrorMessage() {
    setState(() => _working = false);

    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text(Messages.ERROR_SESSION)),
    );
  }

  Widget getIcon() {
    if (_working) {
      return Padding(
        padding: EdgeInsets.all(15),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
          strokeWidth: 2,
        ),
      );
    }

    return Icon(Icons.delete);
  }
}

