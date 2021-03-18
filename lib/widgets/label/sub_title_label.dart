import 'package:flutter/material.dart';

class SubTitleLabel extends StatelessWidget {
  final String text;

  SubTitleLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
    );
  }
}
