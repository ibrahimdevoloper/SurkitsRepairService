// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../Widgets/active_project_card.dart';
// import '../../Widgets/task_column.dart';
// import '../global.dart';
// import 'CalendarPage.dart';
// import 'RepairCategoryPage.dart';
//
// class repairmanPage extends StatefulWidget {
//   @override
//   _repairmanPageState createState() => _repairmanPageState();
// }
//
// class _repairmanPageState extends State<repairmanPage> {
//   bool pressed = false;
//
//   Text subheading(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//           color: LightColors.kDarkBlue,
//           fontSize: 20.0,
//           fontWeight: FontWeight.w700,
//           letterSpacing: 1.2),
//     );
//   }
//
//   static CircleAvatar calendarIcon() {
//     return CircleAvatar(
//       radius: 30.0,
//       backgroundColor: selectedCalColor,
//       child: Icon(
//         Icons.calendar_today,
//         size: 25.0,
//         color: Colors.white,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (pressed == false) {
//       return Scaffold(
//         body: Container(
//           color: backgroundColor,
//           child: Column(
//             children: <Widget>[
//               getTopRepairmanContainer('Repairman Name'),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: <Widget>[
//                       Container(
//                         color: Colors.transparent,
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 20.0, vertical: 10.0),
//                         child: Column(
//                           children: <Widget>[
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 subheading('My Tasks'),
//                                 Container(
//                                   padding: EdgeInsets.only(top: 10, bottom: 5),
//                                   height: 90,
//                                   width: 70,
//                                   child: FloatingActionButton(
//                                       heroTag: null,
//                                       backgroundColor: myIconColor,
//                                       child: calendarIcon(),
//                                       elevation: 25,
//                                       onPressed: () {
//                                         // var push = Navigator.push(
//                                         //     context,
//                                         //     MaterialPageRoute(
//                                         //         builder: (context) =>
//                                         //             calendarPage()));
//                                       }),
//                                 ),
//                                 /*  GestureDetector(
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => calendarPage()),
//                                     );
//                                   },
//                                   child: calendarIcon(),
//                                 ),*/
//                               ],
//                             ),
//                             SizedBox(height: 15.0),
//                             TaskColumn(
//                               icon: Icons.alarm,
//                               iconBackgroundColor: selectedCalColor,
//                               title: 'To Do Today',
//                               iconColor: LightColors.kRed,
//                               subtitle: '5 tasks today',
//                             ),
//                             SizedBox(
//                               height: 15.0,
//                             ),
//                             TaskColumn(
//                               icon: Icons.blur_circular,
//                               iconBackgroundColor: selectedCalColor,
//                               iconColor: LightColors.kDarkYellow,
//                               title: 'In Progress / Active',
//                               subtitle: '1 request not closed',
//                             ),
//                             SizedBox(height: 15.0),
//                             TaskColumn(
//                               icon: Icons.check_circle_outline,
//                               iconBackgroundColor: selectedCalColor,
//                               title: 'Done',
//                               iconColor: middleColor,
//                               subtitle: '2 tasks today',
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         color: Colors.transparent,
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 20.0, vertical: 10.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             subheading('Active Requests'),
//                             SizedBox(height: 5.0),
//                             Row(
//                               children: <Widget>[
//                                 ActiveProjectsCard(
//                                   cardColor: LightColors.kGreen,
//                                   loadingPercent: 0.25,
//                                   title: 'Order Number xx',
//                                   subtitle: '9 hours progress',
//                                 ),
//                                 SizedBox(width: 20.0),
//                                 ActiveProjectsCard(
//                                   cardColor: LightColors.kRed,
//                                   loadingPercent: 0.6,
//                                   title: 'Order Number yy',
//                                   subtitle: '20 hours progress',
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: <Widget>[
//                                 ActiveProjectsCard(
//                                   cardColor: LightColors.kDarkYellow,
//                                   loadingPercent: 0.45,
//                                   title: 'Order Number zz',
//                                   subtitle: '5 hours progress',
//                                 ),
//                                 SizedBox(width: 20.0),
//                                 ActiveProjectsCard(
//                                   cardColor: LightColors.kBlue,
//                                   loadingPercent: 0.9,
//                                   title: 'Order Number tt',
//                                   subtitle: '23 hours progress',
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     } else {
//       return Scaffold(
//         // resizeToAvoidBottomPadding: false,
//         body: Container(
//           color: backgroundColor,
//           child: Column(
//             children: <Widget>[
//               getTopContainer(
//                   textPair('How can we help?', 'كيف يمكننا مساعدتك؟')),
//               Container(
//                   height: 500,
//                   margin: EdgeInsets.only(left: 20, right: 20),
//                   //padding: EdgeInsets.all(20),
//                   child: Column(children: <Widget>[
//                     Container(
//                         height: 330,
//                         padding: EdgeInsets.all(10),
//                         child: ListView(children: getRequestCategories())),
//                     TextField(
//                       decoration: InputDecoration(
//                           labelText: 'Choose Active Request',
//                           labelStyle: TextStyle(
//                               fontFamily: 'Montserrat',
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey),
//                           focusedBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: middleColor))),
//                     )
//                   ])),
//             ],
//           ),
//         ),
//       );
//     }
//   }
//
//   List<String> reqCategories = ["New", "Active"];
//
//   Map jobToIcon = {
//     "New": Icon(
//       Icons.miscellaneous_services,
//       color: myIconColor,
//       size: 50,
//     ),
//     "Active": Icon(
//       Icons.miscellaneous_services,
//       color: myIconColor,
//       size: 50,
//     ),
//   };
//
//   Map reqToAr = {
//     "New": "جديد",
//     "Active": "حالي",
//   };
//
//   Widget getNewContainer() {
//     return new Container(
//       margin: EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 10),
//       height: 220,
//       width: 140,
//       padding: EdgeInsets.all(25),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(Radius.circular(15)),
//         boxShadow: [new BoxShadow(color: Colors.grey, blurRadius: 10.0)],
//       ),
//       child: Column(
//         children: <Widget>[
//           Text("New", style: titileStyleLighterBlack),
//           Text("Request", style: titileStyleLighterBlack),
//           Container(
//             padding: EdgeInsets.only(top: 15, bottom: 15),
//             height: 90,
//             width: 70,
//             child: FloatingActionButton(
//                 heroTag: null,
//                 backgroundColor: Colors.white,
//                 child: jobToIcon["New"],
//                 elevation: 15,
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => new ContentPage()));
//                 }),
//           ),
//           Text("طلب جديد", style: titileStyleLighterBlack),
//           // Text(reqToAr["New"], style: titileStyleLighterBlack)
//         ],
//       ),
//     );
//   }
//
//   Widget getOldContainer() {
//     double elev = 0.0;
//     if (pressed == false) {
//       elev = 15.0;
//     }
//     ;
//
//     return new Container(
//       margin: EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 10),
//       height: 220,
//       width: 140,
//       padding: EdgeInsets.all(25),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(Radius.circular(15)),
//         boxShadow: [new BoxShadow(color: Colors.grey, blurRadius: 10.0)],
//       ),
//       child: Column(
//         children: <Widget>[
//           Text("Active", style: titileStyleLighterBlack),
//           Text("Request", style: titileStyleLighterBlack),
//           Container(
//             padding: EdgeInsets.only(top: 11, bottom: 15),
//             height: 90,
//             width: 70,
//             child: FloatingActionButton(
//                 heroTag: null,
//                 backgroundColor: Colors.white,
//                 child: jobToIcon["Active"],
//                 elevation: elev,
//                 onPressed: () {
//                   setState(() => pressed = true);
//                 }),
//           ),
//           Text("طلب حالي", style: titileStyleLighterBlack),
//           // Text(reqToAr["Active"], style: titileStyleLighterBlack)
//         ],
//       ),
//     );
//   }
//
//   List<Widget> getRequestCategories() {
//     List<Widget> reqCategoriesCards = [];
//     List<Widget> rows = [];
//     rows.add(getNewContainer());
//     rows.add(getOldContainer());
//     if (rows.length > 0) {
//       reqCategoriesCards.add(new Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: rows,
//       ));
//     }
//     return reqCategoriesCards;
//   }
// }
