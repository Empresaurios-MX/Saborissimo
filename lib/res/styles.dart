import 'package:flutter/material.dart';

class Styles {
  static TextStyle headerTitle(Color color) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
      fontFamily: 'ReliqStd-Active',
      fontSize: 50,
    );
  }

  static TextStyle title() {
    return TextStyle(
      color: Colors.black,
      fontSize: 20,
    );
  }

  static TextStyle subTitle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 18,
    );
  }

  static TextStyle body() {
    return TextStyle(
      color: Colors.black,
      fontSize: 16,
    );
  }

  static TextStyle legend(double fontSize) {
    return TextStyle(
      color: Colors.white,
      backgroundColor: Colors.black54,
      fontWeight: FontWeight.bold,
      fontFamily: 'Lato-Regular',
      fontSize: fontSize,
    );
  }
}
