import 'package:an_app/UIValuesFolder/TextStyles.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:flutter/material.dart';

class ImageBanner extends StatelessWidget {
  final String _topStringEn;
  final String _topStringAr;

  final Widget _child;

  ImageBanner({topStringEn, topStringAr, child})
      : this._topStringEn = topStringEn,
        this._topStringAr = topStringAr,
        this._child = child;

  @override
  Widget build(BuildContext context) {
    final bannerStyle = TextStyle(
        color: Colors.white,
        fontSize: Theme.of(context).textTheme.headline5.fontSize);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.indigo[900].withOpacity(0.21),
      ),
      child: Container(
        child: Column(
          children: [
            Container(
              height: 88,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  // stops: [0.1, 0.85],
                  colors: [
                    leftColor,
                    // Theme.of(context).primaryColor,
                    // Theme.of(context).accentColor
                    // Colors.deepPurpleAccent[500],
                    rightColor
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        _topStringEn,
                        style: bannerStyleWhite,
                        textScaleFactor: 1.5,
                      ),
                      Text(
                        _topStringAr,
                        textDirection: TextDirection.rtl,
                        style: bannerStyleWhite,
                        textScaleFactor: 1.5,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(36.0),
              child: AspectRatio(
                aspectRatio: 21 / 9,
                child: _child,
              ),
            )
          ],
        ),
      ),
    );
  }
}
