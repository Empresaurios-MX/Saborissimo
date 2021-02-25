import 'package:flutter/material.dart';
import 'package:native_updater/native_updater.dart';
import 'package:saborissimo/res/names.dart';
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
      title: Names.appName,
      home: DailyMenu(),
      theme: ThemeData(
        canvasColor: Palette.background,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
