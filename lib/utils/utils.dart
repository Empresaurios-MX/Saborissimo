import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';

class Utils {
  static Future<dynamic> pushRoute(BuildContext context, Widget destination) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => destination),
    );
  }

  static Future<dynamic> replaceRoute(
      BuildContext context, Widget destination) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (ctx) => destination),
    );
  }

  static Widget createDrawerHeader(double height, String title) {
    return Container(
      height: 150,
      width: double.infinity,
      padding: EdgeInsets.only(left: 20),
      color: Palette.primary,
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Styles.headerTitle(Colors.white),
      ),
    );
  }

  static Widget createLoginHeader(double height, String title) {
    return Container(
      height: 100,
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        title,
        style: Styles.headerTitle(Palette.primary),
      ),
    );
  }

  static Widget createThumbnail(String pictureUrl) {
    return Image.network(
      pictureUrl,
      height: double.infinity,
      width: 100,
      fit: BoxFit.cover,
    );
  }

  static InputDecoration createHint(String hint) {
    return InputDecoration(
      hintText: hint,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Palette.primary),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Palette.primaryLight),
      ),
    );
  }

  static void showSnack(scaffoldKey, message) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message, style: Styles.body(Colors.white))),
    );
  }
}
