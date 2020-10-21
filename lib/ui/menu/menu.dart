import 'package:flutter/material.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/ui/drawer/drawer_app.dart';
import 'package:saborissimo/utils/utils.dart';

class Menu extends StatelessWidget {
  final bool logged = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Names.menuAppBar),
          backgroundColor: Palette.primary,
          actions: [
            if (logged) createIconButton(context, null, 'Publicar menú'),
          ],
        ),
        drawer: DrawerApp(false),
        body: Center());
  }

  Widget createIconButton(
      BuildContext context, Widget destination, String toolTip) {
    return IconButton(
      icon: Icon(Icons.add),
      tooltip: toolTip,
      onPressed: () => Utils.pushRoute(context, destination),
    );
  }
}
