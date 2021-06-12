import 'package:an_app/Functions/dateFormatter.dart';
import 'package:an_app/UIValuesFolder/TextStyles.dart';
import 'package:an_app/models/user_data.dart';
import 'package:flutter/material.dart';

class WorkerItem extends StatelessWidget {
  const WorkerItem({
    Key key,
    @required this.item,
    @required this.onItemPressed
  }) : super(key: key);

  final UserData item;
  final Function onItemPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
          onTap:onItemPressed,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Worker: ${item.fullName}",
                    style: titileStyleBlack,
                    textDirection: TextDirection.ltr,
                  ),
                  Text(
                    "Category: ${item.category}",
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    textDirection: TextDirection.ltr,
                  ),
                  Text(
                    "E-mail: ${item.email}",
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                    textDirection: TextDirection.ltr,
                  ),
                  Text(
                    "Number: ${item.phoneNumber}",
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                    textDirection: TextDirection.ltr,
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        dateFormater(
                            item.startHour.toDate(), 'hh:mm a'),
                        style: TextStyle(
                            fontFamily: 'Avenir',
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 16),
                        textDirection: TextDirection.ltr,
                      ),
                      Icon(Icons.arrow_forward),
                      Text(
                        dateFormater(
                            item.endHour.toDate(), 'hh:mm a'),
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
  }
}