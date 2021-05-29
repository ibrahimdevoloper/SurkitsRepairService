import 'package:an_app/UIValuesFolder/TextStyles.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomCardButton extends StatelessWidget {
  final String _englishTitle;
  final String _arabicTitle;
  final IconData _icon;
  final Function _onPressed;

  CustomCardButton(
      {Key key,
        @required String englishTitle,
        @required String arabicTitle,
        @required IconData icon,
        @required Function onPressed})
      : this._englishTitle = englishTitle,
        this._arabicTitle = arabicTitle,
        this._icon = icon,
        this._onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(right: 8, left: 8, bottom: 8, top: 8),
      height: 220,
      width: 140,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [new BoxShadow(color: Colors.grey, blurRadius: 10.0)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AutoSizeText(
            _englishTitle,
            style: titileStyleLighterBlack,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          Expanded(
            // padding: EdgeInsets.only(top: 15, bottom: 15),
            // height: 90,
            // width: 70,
            child: FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.white,
                child: Icon(
                  _icon,
                  color: myIconColor,
                  size: 34,
                ),
                elevation: 15,
                onPressed: _onPressed),
          ),
          AutoSizeText(
            _arabicTitle,
            style: titileStyleLighterBlack,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          // Text(reqToAr["New"], style: titileStyleLighterBlack)
        ],
      ),
    );
  }
}
