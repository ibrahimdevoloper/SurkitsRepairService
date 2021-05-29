import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:flutter/material.dart';

class IntroTopAppBar extends StatelessWidget {
  final TextPair _topTxt;
  String _topStringEn;

  String _topStringAr;

  IntroTopAppBar(this._topTxt)
      : _topStringEn = _topTxt.enTxt,
        _topStringAr = _topTxt.arTxt;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32,vertical: 32),
      constraints: BoxConstraints.expand(height: 246),
      decoration: BoxDecoration(
        // gradient: new LinearGradient(
        //     colors: [lightBlueIsh, lightGreen],
        //     begin: const FractionalOffset(1.0, 1.0),
        //     end: const FractionalOffset(0.2, 0.2),
        //     stops: [0.0, 1.0],
        //     tileMode: TileMode.clamp
        // ),
        // color: lightGreen,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
      child: Container(
        // padding: EdgeInsets.only(top: 40),
        child: Stack(
          children: <Widget>[
            Container(
                child: Text(_topStringEn,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaleFactor: 5)),
            Container(
                padding: EdgeInsets.fromLTRB(0.0, 90.0, 0.0, 0.0),
                alignment: Alignment.centerRight,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(_topStringAr,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textScaleFactor: 5),
                      SizedBox(width: 5.0),
                      Text('.',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: middleColor),
                          textScaleFactor: 5),
                    ]))
          ],
        ),
      ),
    );  }
}
