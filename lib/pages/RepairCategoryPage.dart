import 'package:an_app/UIValuesFolder/TextStyles.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/Widgets/BlueGradientAppBar.dart';
import 'package:an_app/Widgets/CustomCardButton.dart';
import 'package:an_app/Widgets/GoBackButton.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:flutter/material.dart';
import 'RequestRepairPage.dart';

class ContentPage extends StatefulWidget {
  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: <Widget>[
          // getTopContainer(TextPair('How can we help?','كيف يمكننا مساعدتك؟')),
          BlueGradientAppBar(
              TextPair('How can we help?', 'كيف يمكننا مساعدتك؟')),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomCardButton(
                      englishTitle: "Electrical",
                      arabicTitle: "كهربائية",
                      icon: Icons.electrical_services,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestRepairPage("Electrical"),
                          ),
                        );
                      },
                    ),
                    CustomCardButton(
                      englishTitle: "Pluming",
                      arabicTitle: "صحية",
                      icon: Icons.plumbing,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestRepairPage("Pluming"),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomCardButton(
                      englishTitle: "Heating",
                      arabicTitle: "تدفئة",
                      icon: Icons.ac_unit,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestRepairPage("Heating"),
                          ),
                        );
                      },
                    ),
                    CustomCardButton(
                      englishTitle: "Electronic",
                      arabicTitle: "الكترونية",
                      icon: Icons.tv,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestRepairPage("Electronic"),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 36,horizontal: 16),
            child: GoBackButton(),
          ),
        ],
      ),
    );
  }

// List<String> jobCategories = [
//   "Electrical",
//   "Plumbing",
//   "Heating",
//   "Category 1",
//   "Category 2"
// ];
//
// Map jobToIcon = {
//   "Electrical": Icon(
//     Icons.electrical_services,
//     color: myIconColor,
//     size: 50,
//   ),
//   "Plumbing": Icon(Icons.plumbing, color: myIconColor, size: 50),
//   "Heating": Icon(Icons.ac_unit, color: myIconColor, size: 50),
//   "Category 1": Icon(Icons.location_on, color: myIconColor, size: 50),
//   "Category 2":
//       Icon(Icons.keyboard_voice_outlined, color: myIconColor, size: 50),
//   "Category 3":
//       Icon(Icons.photo_camera_outlined, color: myIconColor, size: 50),
// };
//
// Map jobToAr = {
//   "Electrical": "كهربائيات",
//   "Plumbing": "صحية",
//   "Heating": "تدفئة",
//   "Category 1": "bof",
//   "Category 2": "baf",
// };
//
// Widget getCategoryContainer(String categoryName) {
//   return new Container(
//     margin: EdgeInsets.only(right: 10, left: 10, bottom: 10),
//     height: 170,
//     width: 140,
//     padding: EdgeInsets.all(10),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.all(Radius.circular(15)),
//       boxShadow: [new BoxShadow(color: Colors.grey, blurRadius: 10.0)],
//     ),
//     child: Column(
//       children: <Widget>[
//         Text(categoryName, style: titileStyleLighterBlack),
//         Container(
//           padding: EdgeInsets.only(top: 10, bottom: 5),
//           height: 90,
//           width: 70,
//           child: FloatingActionButton(
//               heroTag: null,
//               backgroundColor: Colors.white,
//               child: jobToIcon[categoryName],
//               elevation: 15,
//               onPressed: () {
//                 var push = Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => requestScreens(categoryName)));
//               }),
//         ),
//         Text(jobToAr[categoryName], style: titileStyleLighterBlack)
//       ],
//     ),
//   );
// }
//
// List<Widget> getJobCategories() {
//   List<Widget> jobCategoriesCards = [];
//   List<Widget> rows = [];
//   int i = 0;
//   for (String category in jobCategories) {
//     if (i < 2) {
//       rows.add(getCategoryContainer(category));
//       i++;
//     } else {
//       i = 0;
//       jobCategoriesCards.add(new Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: rows,
//       ));
//       rows = [];
//       rows.add(getCategoryContainer(category));
//       i++;
//     }
//   }
//   if (rows.length > 0) {
//     jobCategoriesCards.add(new Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: rows,
//     ));
//   }
//   return jobCategoriesCards;
// }
}
