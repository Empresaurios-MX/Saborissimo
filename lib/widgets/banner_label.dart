import 'package:flutter/material.dart';

class BannerLabel extends StatelessWidget {
  final String message;
  final Color theme;

  BannerLabel(this.message, this.theme);

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyle(
        color: theme,
        fontWeight: FontWeight.bold,
        fontFamily: 'ReliqStd-Active',
        fontSize: 50,
      ),
    );
  }
}
