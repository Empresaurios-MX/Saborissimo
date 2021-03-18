import 'package:flutter/material.dart';

class AvatarChip extends StatelessWidget {
  final String label;
  final Widget avatar;
  final Color theme;
  final Color avatarTheme;

  AvatarChip({this.label, this.avatar, this.theme, this.avatarTheme});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: theme,
      avatar: CircleAvatar(
        backgroundColor: avatarTheme,
        foregroundColor: Colors.white,
        child: avatar,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
    );
  }
}
