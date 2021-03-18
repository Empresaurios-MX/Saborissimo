import 'package:flutter/material.dart';

class NoItemsMessage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  NoItemsMessage({this.title, this.subtitle, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            icon,
            size: 100,
            color: Colors.black26,
          ),
          SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
