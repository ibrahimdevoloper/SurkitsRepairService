import 'package:flutter/material.dart';

class EmptyListIndicator extends StatelessWidget {
  const EmptyListIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Image.asset("assets/box.png"),
      ),
    );
  }
}