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

  static Widget createNoItemsMessage(String message) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Styles.subTitleBig(Colors.black),
          ),
          SizedBox(height: 25),
          Icon(
            Icons.mood_bad,
            size: 100,
            color: Palette.primary,
          ),
        ],
      ),
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

  static String getFirebaseName(String path) {
    return path
        .split('/o/')[1]
        .replaceAll('%2F', '/')
        .replaceAll('%20', ' ')
        .split('?alt')[0];
  }
}
