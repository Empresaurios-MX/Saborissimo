import 'package:flutter/material.dart';

class NavigationUtils {
  static Future<dynamic> push(context, Widget destination) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => destination),
    );
  }

  static Future<dynamic> replace(context, Widget destination) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (ctx) => destination),
    );
  }

  static void popAndReplace(context, Widget replacement) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (ctx) => replacement),
    );
  }
}
