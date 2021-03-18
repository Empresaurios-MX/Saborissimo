import 'package:flutter/material.dart';
import 'package:native_updater/native_updater.dart';
import 'package:saborissimo/res/strings.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/ui/menu/daily_menu.dart';

void main() => runApp(Saborissimo());

class Saborissimo extends StatelessWidget {
  Widget build(BuildContext context) {
    NativeUpdater.displayUpdateAlert(
        context,
        forceUpdate: true,
        playStoreUrl: 'https://play.google.com/store/apps/details?id=com.solucionescovirtuales.saborissimo'
    );

    return MaterialApp(
      title: Strings.APP_NAME,
      home: DailyMenu(),
      theme: ThemeData(
        primaryColor: Palette.primary,
        primaryColorLight: Palette.primaryLight,
        accentColor: Palette.accent,
        canvasColor: Palette.background,
        fontFamily: 'Lato-Regular',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
