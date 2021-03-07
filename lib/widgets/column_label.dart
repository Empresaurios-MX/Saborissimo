import 'package:flutter/material.dart';
import 'package:saborissimo/res/palette.dart';

class ColumnLabel extends StatelessWidget {
  final String label;
  final String text;

  ColumnLabel({this.label, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Palette.backgroundElevated,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "$label:",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
