import 'package:an_app/Cubits/AdminAssignRequest/admin_assign_request_cubit.dart';
import 'package:an_app/Functions/dateFormatter.dart';
import 'package:an_app/UIValuesFolder/TextStyles.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/Widgets/BlueGradientAppBar.dart';
import 'package:an_app/Widgets/WorkerItem.dart';
import 'package:an_app/dialogs/AdminAssignRequestFilterDialog.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:an_app/models/user_data.dart';
import 'package:an_app/pages/AdminWorkerAssignmentsCalenderPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminAssignRequestPage extends StatefulWidget {
  @override
  _AdminAssignRequestPageState createState() => _AdminAssignRequestPageState();
}

class _AdminAssignRequestPageState extends State<AdminAssignRequestPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminAssignRequestCubit>(
      create: (context) => AdminAssignRequestCubit(),
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                BlueGradientAppBar(
                    TextPair('Available Workers', 'العمال المتاحين')),
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    BlocBuilder<AdminAssignRequestCubit,
                        AdminAssignRequestState>(builder: (context, state) {
                      if (state is! AdminAssignRequestLoading) {
                        return IconButton(
                          icon: Icon(
                            Icons.filter_list_sharp,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context1) => BlocProvider.value(
                                  value:
                                      BlocProvider.of<AdminAssignRequestCubit>(
                                          context),
                                  child:
                                      adminAssignRequestFilterDialog(context)),
                            );
                          },
                        );
                      } else {
                        return Container(
                          height: 0,
                          width: 0,
                        );
                      }
                    }),
                  ],
                )
              ],
            ),
            Expanded(
              child:
                  BlocBuilder<AdminAssignRequestCubit, AdminAssignRequestState>(
                      buildWhen: (previous, current) {
                return current is! AdminAssignRequestFilterStateChanged;
              }, builder: (context, state) {
                if (state is AdminAssignRequestLoading)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                if (state is AdminAssignRequestLoaded) {
                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                    itemCount: state.usersData.length,
                    itemBuilder: (context, i) {
                      UserData item = state.usersData[i];
                      return WorkerItem(item: item,
                      onItemPressed: () {
                        //TODO: dispaly worker calender
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              AdminWorkerAssignmentsCalenderPage(item),),);
                      },);
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}


