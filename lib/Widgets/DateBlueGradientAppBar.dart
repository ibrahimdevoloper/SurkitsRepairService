import 'package:an_app/UIValuesFolder/TextStyles.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:flutter/material.dart';

class DateBlueGradientAppBar extends StatelessWidget {
  final TextPair _topTxt;
  String _topStringEn;

  String _topStringAr;

  DateBlueGradientAppBar(this._topTxt)
      : _topStringEn = _topTxt.enTxt,
        _topStringAr = _topTxt.arTxt;

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(40),
      constraints: BoxConstraints.expand(height: 225),
      decoration: BoxDecoration(
          gradient: new LinearGradient(
            colors: [leftColor, rightColor],
            // begin: const FractionalOffset(1.0, 1.0),
            begin: Alignment.centerLeft,
            // end: const FractionalOffset(0.2, 0.2),
            end: Alignment.centerRight,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      child: Container(
        padding: EdgeInsets.only(top: 40),
        child: Stack(
          children: <Widget>[
            Container(
                child: Text(_topStringEn,
                    style: dateTitleStyleWhite, textScaleFactor: 1.5)),
            Container(
                padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                alignment: Alignment.centerRight,
                child: Text(_topStringAr,
                    textDirection: TextDirection.rtl,
                    style: dateTitleStyleWhite,
                    textScaleFactor: 1.5))
          ],
        ),
      ),
    );
  }
}
