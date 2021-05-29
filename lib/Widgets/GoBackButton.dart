import 'package:flutter/material.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.black, style: BorderStyle.solid, width: 1.0),
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        //borderRadius: BorderRadius.circular(20.0)
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child: Text(
            'Go Back',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
          ),
        ),
      ),
    );
  }
}
