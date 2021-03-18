import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Printer {
  static Widget createThumbnail(String pictureUrl) {
    return Image.network(
      pictureUrl,
      height: double.infinity,
      width: 100,
      fit: BoxFit.cover,
    );
  }

  static void snackBar(scaffoldKey, message) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
