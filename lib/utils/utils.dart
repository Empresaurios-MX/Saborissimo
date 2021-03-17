import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';

class Utils {
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
    return Text(
      title,
      style: Styles.headerTitle(Palette.primary),
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
            style: Styles.title(),
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

  static void showSnack(scaffoldKey, message) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
