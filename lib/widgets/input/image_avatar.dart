import 'dart:io';

import 'package:flutter/material.dart';

class ImageAvatar extends StatelessWidget {
  final File image;
  final IconData icon;
  final Color theme;
  final Color themeAlt;
  final Function selector;

  ImageAvatar({
    this.image,
    this.icon,
    this.theme,
    this.themeAlt,
    this.selector,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme, width: 2),
        borderRadius: BorderRadius.circular(100),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () => selector(context),
        child: createPicture(),
      ),
    );
  }

  Widget createPicture() {
    if (image != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.file(
          image,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      width: 200,
      height: 200,
      child: Icon(
        icon,
        color: themeAlt,
        size: 100,
      ),
    );
  }
}
