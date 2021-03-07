import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Color color;
  final Function action;

  RoundedButton({this.label, this.color, this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        padding: EdgeInsets.all(10),
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () => action(),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
