import 'package:an_app/Functions/dateFormatter.dart';
import 'package:an_app/UIValuesFolder/TextStyles.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/Widgets/BlueGradientAppBar.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:an_app/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Cubits/AdminSelectWorkerForADisplayedRequest/admin_select_worker_for_adisplayed_request_cubit.dart';
import '../Cubits/AdminSelectWorkerForADisplayedRequest/admin_select_worker_for_adisplayed_request_cubit.dart';

class AdminSelectWorkerForADisplayedRequestPage extends StatefulWidget {
  @override
  _AdminSelectWorkerForADisplayedRequestPageState createState() => _AdminSelectWorkerForADisplayedRequestPageState();
}

class _AdminSelectWorkerForADisplayedRequestPageState extends State<AdminSelectWorkerForADisplayedRequestPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminSelectWorkerForAdisplayedRequestCubit>(
      create: (context)=>AdminSelectWorkerForAdisplayedRequestCubit(),
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                BlueGradientAppBar(TextPair('Available Workers', 'العمال المتاحين')),
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                )
              ],
            ),
            Expanded(
              child: BlocBuilder<AdminSelectWorkerForAdisplayedRequestCubit,AdminSelectWorkerForAdisplayedRequestState>(
                builder: (context, state) {
                  if (state is AdminSelectWorkerForAdisplayedRequestLoading)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  if (state is AdminSelectWorkerForAdisplayedRequestLoaded) {
                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                    itemCount: state.usersData.length,
                    itemBuilder: (context, i) {
                      UserData item = state.usersData[i];
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
                                      dateFormater(item.startHour.toDate(),'hh:mm a'),
                                      style: TextStyle(
                                          fontFamily: 'Avenir',
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16),
                                      textDirection: TextDirection.ltr,
                                    ),
                                    Icon(Icons.arrow_forward),
                                    Text(
                                      dateFormater(item.startHour.toDate(),'hh:mm a'),
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
                  );
                }
              }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
