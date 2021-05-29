import 'package:an_app/UIValuesFolder/TextStyles.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/Widgets/BlueGradientAppBar.dart';
import 'package:an_app/Widgets/CustomCardButton.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:an_app/models/global.dart';
import 'package:an_app/pages/AdminAddWorkerPage.dart';
import 'package:an_app/pages/AdminAssignRequestPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'AdminDisplayRequestsPage.dart';
import 'RepairCategoryPage.dart';
// import '../global.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
      ),
      body: Column(
        children: <Widget>[
          // getTopContainer(TextPair('How can we help?', 'كيف يمكننا مساعدتك؟')),
          BlueGradientAppBar(TextPair('Control  Panel', 'منصة تحكم')),
          Expanded(
            child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomCardButton(
                      englishTitle: "Display Requests",
                      arabicTitle: "أظهر طلبات",
                      icon: Icons.assessment,
                      onPressed: () {
                        // print("true");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => new AdminDisplayRequestsPage(),
                          ),
                        );
                      },
                    ),
                    CustomCardButton(
                      englishTitle: "Assign Request",
                      arabicTitle: "أسند طلب",
                      icon: Icons.group,
                      onPressed: () {
                        print("true");
                        //TODO: go to assign requests page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => new AdminAssignRequestPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                CustomCardButton(
                  englishTitle: "Add Worker",
                  arabicTitle: "أضف عامل",
                  icon: Icons.person_add,
                  onPressed: () {
                    // print("true");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => new AdminAddWorkerPage(),
                      ),
                    );
                  },
                ),

              ],
            )),
          ),
        ],
      ),
    );
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
}
