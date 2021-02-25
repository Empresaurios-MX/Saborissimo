import 'package:flutter/material.dart';
import 'package:saborissimo/res/palette.dart';

class MaterialDialogNeutral extends StatelessWidget {
  final String title;
  final String body;

  MaterialDialogNeutral(this.title, this.body);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: createTitle(),
      content: Text(body),
      actions: [
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("OK"),
          textColor: Palette.primary,
        ),
      ],
    );
  }

  Widget createTitle() {
    if(title.isNotEmpty) {
      return Text(title);
    }

    return null;
  }
}
