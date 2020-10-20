import 'package:flutter/material.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/ui/drawer/drawer_app.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Names.loginAppBar),
          backgroundColor: Palette.primary,
        ),
        drawer: DrawerApp(true),
        body: Center());
  }
}
