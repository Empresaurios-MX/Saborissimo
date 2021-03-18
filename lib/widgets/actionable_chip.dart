import 'package:flutter/material.dart';

class ActionableChip extends StatelessWidget {
  final String label;
  final Color theme;
  final Function action;

  ActionableChip({this.label, this.theme, this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: ActionChip(
        elevation: 5,
        backgroundColor: theme,
        onPressed: () => action(),
        label: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
