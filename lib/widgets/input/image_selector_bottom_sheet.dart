import 'package:flutter/material.dart';

class ImageSelectorBottomSheet extends StatelessWidget {
  final Color theme;
  final String cameraLabel;
  final String galleryLabel;
  final Function cameraAction;
  final Function galleryAction;

  ImageSelectorBottomSheet({
    this.theme,
    this.cameraLabel,
    this.galleryLabel,
    this.cameraAction,
    this.galleryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.photo_camera, color: theme),
            title: Text(cameraLabel, style: TextStyle(fontSize: 16)),
            onTap: () => {cameraAction(), Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.photo_library, color: theme),
            title: Text(galleryLabel, style: TextStyle(fontSize: 16)),
            onTap: () => {galleryAction(), Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
