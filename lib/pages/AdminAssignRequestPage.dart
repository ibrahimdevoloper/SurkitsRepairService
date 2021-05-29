import 'package:an_app/UIValuesFolder/TextStyles.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/Widgets/BlueGradientAppBar.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:flutter/material.dart';

class AdminAssignRequestPage extends StatefulWidget {
  @override
  _AdminAssignRequestPageState createState() => _AdminAssignRequestPageState();
}

class _AdminAssignRequestPageState extends State<AdminAssignRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              BlueGradientAppBar(TextPair('Select Worker', 'اختر عاملاً')),
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              )
            ],
          ),
          // BlueGradientAppBar(TextPair('Select Worker', 'اختر عاملاً')),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(16.0, 8, 16, 8),
              itemCount: 10,
              itemBuilder: (context, i) {
                return Card(
                    child: InkWell(
                  onTap: () {
                    //TODO: assign to repairman
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Worker:محمد الأحمد",
                            style: titileStyleBlack,
                            textDirection: TextDirection.ltr,
                          ),
                          Text(
                            "Category: Electrical",
                            style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            textDirection: TextDirection.ltr,
                          ),
                          Text(
                            "E-mail:ibrahim@surkits.com",
                            style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16),
                            textDirection: TextDirection.ltr,
                          ),Text(
                            "Number:096655566",
                            style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16),
                            textDirection: TextDirection.ltr,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "9:00 AM",
                                style: TextStyle(
                                    fontFamily: 'Avenir',
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16),
                                textDirection: TextDirection.ltr,
                              ),
                              Icon(Icons.arrow_forward),
                              Text(
                                "9:00 PM",
                                style: TextStyle(
                                    fontFamily: 'Avenir',
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16),
                                textDirection: TextDirection.ltr,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
