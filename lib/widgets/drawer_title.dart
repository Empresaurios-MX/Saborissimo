import 'package:flutter/material.dart';
import 'package:saborissimo/widgets/banner_label.dart';

class DrawerTitle extends StatelessWidget {
  final String title;
  final Color theme;

  DrawerTitle(this.title, this.theme);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      padding: EdgeInsets.only(left: 10, bottom: 10),
      color: theme,
      alignment: Alignment.bottomLeft,
      child: BannerLabel(title, Colors.white),
    );
  }
}
