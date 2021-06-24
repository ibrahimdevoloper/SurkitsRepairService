import 'package:an_app/UIValuesFolder/TextStyles.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/Widgets/BlueGradientAppBar.dart';
import 'package:an_app/Widgets/CustomCardButton.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:an_app/models/global.dart';
import 'package:an_app/models/user_data.dart';
import 'package:an_app/pages/CustomerRequestsPage.dart';
import 'package:an_app/providers/SharedPreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CustomerRepairCategoryPage.dart';
// import '../global.dart';

class CustomerHomePage extends StatefulWidget {
  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton:  Consumer<SharedPreferencesProvider>(
          builder: (context, provider,_) {
            return FloatingActionButton(
              onPressed: () {
                provider.pref.setString(UserData.ROLE, "");
                FirebaseAuth.instance.signOut();
              },
            );
          }
      ),
      body: Column(
        children: <Widget>[
          // getTopContainer(TextPair('How can we help?', 'كيف يمكننا مساعدتك؟')),
          BlueGradientAppBar(
              TextPair('How can we help?', 'كيف يمكننا مساعدتك؟')),
          // Container(
          //     height: 500,
          //     margin: EdgeInsets.only(left: 20, right: 20),
          //     //padding: EdgeInsets.all(20),
          //     child: Column(
          //         children: <Widget>[
          //           Container(
          //               height: 350,
          //               padding: EdgeInsets.all(10),
          //               child: ListView(children: getRequestCategories() )),
          //         ]
          //     )
          // ),
          Expanded(
            child: Center(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomCardButton(
                  englishTitle: "New Request",
                  arabicTitle: "طلب جديد",
                  icon: Icons.miscellaneous_services,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerRepairCategoryPage(),
                      ),
                    );
                  },
                ),
                Consumer<SharedPreferencesProvider>(
                  builder: (_, provider, __) => CustomCardButton(
                    englishTitle: "Active Request",
                    arabicTitle: "طلب حالي",
                    icon: Icons.miscellaneous_services,
                    onPressed: () {
                      print("pressed ${provider.pref.get(UserData.UID)}");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  CustomerRequestsPage(provider.pref.getString(UserData.UID)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
    // if (pressed == false) {
    //   return Scaffold(
    //     body: Container(
    //       color: backgroundColor,
    //       child: Column(
    //         children: <Widget>[
    //           // getTopContainer(TextPair('How can we help?', 'كيف يمكننا مساعدتك؟')),
    //           BlueGradientAppBar(TextPair('How can we help?', 'كيف يمكننا مساعدتك؟')),
    //           Container(
    //               height: 500,
    //               margin: EdgeInsets.only(left: 20, right: 20),
    //               //padding: EdgeInsets.all(20),
    //               child: Column(
    //                   children: <Widget>[
    //                     Container(
    //                         height: 350,
    //                         padding: EdgeInsets.all(10),
    //                         child: ListView(children: getRequestCategories() )),
    //                   ]
    //               )
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // } else {
    //   return Scaffold(
    //     // resizeToAvoidBottomPadding: false,
    //     backgroundColor: backgroundColor,
    //     body: Column(
    //       children: <Widget>[
    //         // getTopContainer(TextPair('How can we help?', 'كيف يمكننا مساعدتك؟')),
    //         BlueGradientAppBar(TextPair('How can we help?', 'كيف يمكننا مساعدتك؟')),
    //         Container(
    //           height: 500,
    //           margin: EdgeInsets.only(left: 20, right: 20),
    //           //padding: EdgeInsets.all(20),
    //           child: Column(
    //             children: <Widget>[
    //               Container(
    //                   height: 330,
    //                   padding: EdgeInsets.all(10),
    //                 child: ListView(children: getRequestCategories() )),
    //               TextField(
    //                 decoration: InputDecoration(
    //                   labelText: 'Choose Active Request',
    //                     labelStyle: TextStyle(
    //                     fontFamily: 'Montserrat',
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.grey),
    //                 focusedBorder: UnderlineInputBorder(
    //                   borderSide: BorderSide(color: middleColor))),
    //               )
    //             ]
    //           )
    //         ),
    //       ],
    //     ),
    //   );
    // }
  }

  List<String> reqCategories = ["New", "Active"];

  Map jobToIcon = {
    "New": Icon(
      Icons.miscellaneous_services,
      color: myIconColor,
      size: 50,
    ),
    "Active": Icon(
      Icons.miscellaneous_services,
      color: myIconColor,
      size: 50,
    ),
  };

  Map reqToAr = {
    "New": "جديد",
    "Active": "حالي",
  };

// Widget getNewContainer() {
//   return new Container(
//     margin: EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 10),
//     height: 220,
//     width: 140,
//     padding: EdgeInsets.all(25),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.all(Radius.circular(15)),
//       boxShadow: [new BoxShadow(color: Colors.grey, blurRadius: 10.0)],
//     ),
//     child: Column(
//       children: <Widget>[
//         Text("New", style: titileStyleLighterBlack),
//         Text("Request", style: titileStyleLighterBlack),
//         Container(
//           padding: EdgeInsets.only(top: 15, bottom: 15),
//           height: 90,
//           width: 70,
//           child: FloatingActionButton(
//               // heroTag: null,
//               backgroundColor: Colors.white,
//               child: jobToIcon["New"],
//               elevation: 15,
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => new ContentPage(),
//                   ),
//                 );
//               }),
//         ),
//         Text("طلب جديد", style: titileStyleLighterBlack),
//         // Text(reqToAr["New"], style: titileStyleLighterBlack)
//       ],
//     ),
//   );
// }

// Widget getOldContainer() {
//   double elev = 0.0;
//   if (pressed == false) {
//     elev = 15.0;
//   }
//   ;
//
//   return new Container(
//     margin: EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 10),
//     height: 220,
//     width: 140,
//     padding: EdgeInsets.all(25),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.all(Radius.circular(15)),
//       boxShadow: [new BoxShadow(color: Colors.grey, blurRadius: 10.0)],
//     ),
//     child: Column(
//       children: <Widget>[
//         Text("Active", style: titileStyleLighterBlack),
//         Text("Request", style: titileStyleLighterBlack),
//         Container(
//           padding: EdgeInsets.only(top: 11, bottom: 15),
//           height: 90,
//           width: 70,
//           child: FloatingActionButton(
//               heroTag: null,
//               backgroundColor: Colors.white,
//               child: jobToIcon["Active"],
//               elevation: elev,
//               onPressed: () {
//                 setState(() => pressed = true);
//               }),
//         ),
//         Text("طلب حالي", style: titileStyleLighterBlack),
//         // Text(reqToAr["Active"], style: titileStyleLighterBlack)
//       ],
//     ),
//   );
// }

// List<Widget> getRequestCategories() {
//   List<Widget> reqCategoriesCards = [];
//   List<Widget> rows = [];
//   rows.add(getNewContainer());
//   rows.add(getOldContainer());
//   if (rows.length > 0) {
//     reqCategoriesCards.add(new Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: rows,
//     ));
//   }
//   return reqCategoriesCards;
// }
}
