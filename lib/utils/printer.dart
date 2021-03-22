import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Printer {
  static void snackBar(scaffoldKey, message) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
