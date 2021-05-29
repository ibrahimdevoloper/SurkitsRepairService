import 'package:flutter/material.dart';
import '../models/global.dart';

class TaskColumn extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  TaskColumn({
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    this.title,
    this.subtitle,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 30.0,
          backgroundColor: iconBackgroundColor,
          child: Icon(
            icon,
            size: 50.0,
            color: iconColor,
          ),
        ),
        SizedBox(width: 10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black45),
            ),
          ],
        )
      ],
    );
  }
}
