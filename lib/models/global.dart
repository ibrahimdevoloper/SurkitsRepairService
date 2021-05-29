import 'package:an_app/UIValuesFolder/TextStyles.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/UIValuesFolder/lightColors.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';




//
// class textPair {
//   String enTxt;
//   String arTxt;
//
//   textPair(this.enTxt, this.arTxt);
// }

// for app bar in main app flow
//registering the pages later
// Widget getTopContainer(TextPair topTxt) {
//   String topStringEn = topTxt.enTxt;
//   String topStringAr = topTxt.arTxt;
//   return new Container(
//     padding: EdgeInsets.all(40),
//     constraints: BoxConstraints.expand(height: 225),
//     decoration: BoxDecoration(
//         gradient: new LinearGradient(
//             colors: [leftColor, rightColor],
//             begin: const FractionalOffset(1.0, 1.0),
//             end: const FractionalOffset(0.2, 0.2),
//             stops: [0.0, 1.0],
//             tileMode: TileMode.clamp,),
//         borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
//     child: Container(
//       padding: EdgeInsets.only(top: 40),
//       child: Stack(
//         children: <Widget>[
//           Container(
//               child: Text(topStringEn,
//                   style: titleStyleWhite, textScaleFactor: 1.5)),
//           Container(
//               padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
//               alignment: Alignment.centerRight,
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   textDirection: TextDirection.rtl,
//                   children: <Widget>[
//                     Text(topStringAr,
//                         textDirection: TextDirection.rtl,
//                         style: titleStyleWhite,
//                         textScaleFactor: 1.5),
//                   ]))
//         ],
//       ),
//     ),
//   );
// }

// Widget getTopFirstContainer(TextPair topTxt) {
//   String topStringEn = topTxt.enTxt;
//   String topStringAr = topTxt.arTxt;
//   return Container(
//     padding: EdgeInsets.all(40),
//     constraints: BoxConstraints.expand(height: 315),
//     decoration: BoxDecoration(
//         // gradient: new LinearGradient(
//         //     colors: [lightBlueIsh, lightGreen],
//         //     begin: const FractionalOffset(1.0, 1.0),
//         //     end: const FractionalOffset(0.2, 0.2),
//         //     stops: [0.0, 1.0],
//         //     tileMode: TileMode.clamp
//         // ),
//         // color: lightGreen,
//         borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
//     child: Container(
//       padding: EdgeInsets.only(top: 40),
//       child: Stack(
//         children: <Widget>[
//           Container(
//               child: Text(topStringEn,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                   textScaleFactor: 5)),
//           Container(
//               padding: EdgeInsets.fromLTRB(0.0, 90.0, 0.0, 0.0),
//               alignment: Alignment.centerRight,
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   textDirection: TextDirection.rtl,
//                   children: <Widget>[
//                     Text(topStringAr,
//                         textDirection: TextDirection.rtl,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                         textScaleFactor: 5),
//                     SizedBox(width: 5.0),
//                     Text('.',
//                         textDirection: TextDirection.rtl,
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, color: middleColor),
//                         textScaleFactor: 5),
//                   ]))
//         ],
//       ),
//     ),
//   );
// }

//TODO: fix this when repair is Added

Widget getTopRepairmanContainer(String rmName) {
  return new Container(
    padding: EdgeInsets.all(40),
    constraints: BoxConstraints.expand(height: 225),
    decoration: BoxDecoration(
        gradient: new LinearGradient(
            colors: [leftColor, rightColor],
            begin: const FractionalOffset(1.0, 1.0),
            end: const FractionalOffset(0.2, 0.2),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
    child: Container(
      padding: EdgeInsets.only(top: 40),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircularPercentIndicator(
                    radius: 95.0,
                    lineWidth: 10.0,
                    animation: true,
                    percent: 0.75,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: LightColors.kRed,
                    backgroundColor: LightColors.kDarkYellow,
                    center: CircleAvatar(
                      backgroundColor: LightColors.kBlue,
                      radius: 35.0,
                      /*backgroundImage: AssetImage(
                        'assets/images/avatar.png',
                      ),*/
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Repairman Name',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          'Company name',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ]),
    ),
  );
}
