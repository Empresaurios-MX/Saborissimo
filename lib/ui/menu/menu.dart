import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/data/service/MealDataService.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/ui/drawer/drawer_app.dart';
import 'package:saborissimo/utils/utils.dart';

class Menu extends StatelessWidget {
  final bool logged = false;
  final MealDataService dataService = MealDataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Names.menuAppBar, style: Styles.title(Colors.white)),
        backgroundColor: Palette.primary,
        actions: [
          if (logged)
            createIconButton(context, Icons.add, null, 'Publicar menú'),
          if (!logged)
            createIconButton(context, Icons.shopping_cart, null, 'Mis pedidos'),
        ],
      ),
      drawer: DrawerApp(false),
      body: ListView.builder(
        itemBuilder: (ctx, index) => createCard(ctx, dataService.meals[index]),
        itemCount: dataService.meals.length
      ),
    );
  }

  Widget createIconButton(BuildContext context, IconData iconData,
      Widget destination, String toolTip) {
    return IconButton(
      icon: Icon(iconData),
      tooltip: toolTip,
      onPressed: () => Utils.pushRoute(context, destination),
    );
  }

  Widget createCard(BuildContext context, Meal meal) {
    return InkWell(
      onTap: () => Utils.pushRoute(context, null),
      child: Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  meal.picture,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                meal.name,
                textAlign: TextAlign.center,
                style: Styles.legend(),
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
