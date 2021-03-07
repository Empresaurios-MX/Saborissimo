import 'package:flutter/material.dart';
import 'package:saborissimo/res/palette.dart';

class RichPopupMenu extends StatelessWidget {
  final Function action;
  final List<String> labels;
  final List<IconData> icons;

  RichPopupMenu({this.action, this.labels, this.icons});

  @override
  Widget build(BuildContext context) {
    List<PopupMenuItem> items = [];

    for (int i = 0; i < labels.length; i++) {
      items.add(
        PopupMenuItem(
          child: Row(
            children: [
              Icon(icons[i], color: Palette.primary),
              SizedBox(width: 10),
              Text(labels[i]),
            ],
          ),
          value: i,
        ),
      );
    }

    return PopupMenuButton(
      onSelected: (selected) => action(selected),
      itemBuilder: (ctx) => items,
    );
  }
}
