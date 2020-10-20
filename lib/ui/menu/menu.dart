import 'package:flutter/material.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/ui/drawer/drawer_app.dart';
import 'package:saborissimo/utils/utils.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Names.menuAppBar),
          backgroundColor: Palette.primary,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              tooltip: 'Publicar Menú',
              onPressed: () => Utils.pushRoute(context, null),
            )
          ],
        ),
        drawer: DrawerApp(false),
        body: Center());
  }
}
