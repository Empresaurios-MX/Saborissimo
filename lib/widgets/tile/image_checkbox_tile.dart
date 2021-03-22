import 'package:flutter/material.dart';

class ImageCheckboxTile extends StatelessWidget {
  final String title;
  final String imageUrl;
  final bool isChecked;
  final Color checkedColor;
  final Function checkListener;

  ImageCheckboxTile({
    this.title,
    this.imageUrl,
    this.isChecked,
    this.checkedColor,
    this.checkListener,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.all(10),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      secondary: Image.network(
        imageUrl,
        height: double.infinity,
        width: 100,
        fit: BoxFit.cover,
      ),
      activeColor: checkedColor,
      value: isChecked,
      onChanged: (value) => checkListener(value),
    );
  }
}
