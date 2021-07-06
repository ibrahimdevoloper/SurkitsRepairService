import 'package:an_app/Widgets/BlueGradientAppBar.dart';
import 'package:an_app/Widgets/EmptyListIndicator.dart';
import 'package:an_app/Widgets/ErrorIndicator.dart';
import 'package:an_app/Widgets/WorkerItem.dart';
import 'package:an_app/dialogs/AdminSelectWorkerFilterDialog.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:an_app/models/request.dart';
import 'package:an_app/models/user_data.dart';
import 'package:an_app/providers/SharedPreferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../Cubits/AdminSelectWorkerForADisplayedRequest/admin_select_worker_for_adisplayed_request_cubit.dart';

class AdminSelectWorkerForADisplayedRequestPage extends StatefulWidget {
  String requestId;
  Request request;

  AdminSelectWorkerForADisplayedRequestPage({this.requestId, this.request});

  @override
  _AdminSelectWorkerForADisplayedRequestPageState createState() =>
      _AdminSelectWorkerForADisplayedRequestPageState();
}

class _AdminSelectWorkerForADisplayedRequestPageState
    extends State<AdminSelectWorkerForADisplayedRequestPage> {
  void initState() {
    FirebaseAnalytics().setCurrentScreen(
        screenName: "AdminSelectWorkerForADisplayedRequestPage",
        screenClassOverride: "AdminSelectWorkerForADisplayedRequestPage");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminSelectWorkerForAdisplayedRequestCubit>(
      create: (context) => AdminSelectWorkerForAdisplayedRequestCubit(),
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
                    BlocBuilder<AdminSelectWorkerForAdisplayedRequestCubit,
                            AdminSelectWorkerForAdisplayedRequestState>(
                        builder: (context, state) {
                      if (state
                          is! AdminSelectWorkerForAdisplayedRequestLoading) {
                        return IconButton(
                          icon: Icon(
                            Icons.filter_list_sharp,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context1) => BlocProvider.value(
                                  value: BlocProvider.of<
                                          AdminSelectWorkerForAdisplayedRequestCubit>(
                                      context),
                                  child:
                                      adminSelectWorkerFilterDialog(context)),
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
              child: BlocBuilder<AdminSelectWorkerForAdisplayedRequestCubit,
                      AdminSelectWorkerForAdisplayedRequestState>(
                  buildWhen: (previous, current) {
                return current
                    is! AdminSelectWorkerForAdisplayedRequestFilterStateChanged;
              }, builder: (context, state) {
                if (state is AdminSelectWorkerForAdisplayedRequestLoading)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else
                // (state is AdminSelectWorkerForAdisplayedRequestLoaded)
                {
                  return RefreshIndicator(
                    onRefresh: () => BlocProvider.of<
                            AdminSelectWorkerForAdisplayedRequestCubit>(context)
                        .getWorkersPage(0),
                    child: PagedListView<int, UserData>(
                      pagingController: BlocProvider.of<
                                  AdminSelectWorkerForAdisplayedRequestCubit>(
                              context)
                          .pagingController,
                      builderDelegate: PagedChildBuilderDelegate<UserData>(
                        itemBuilder: (context, item, i) =>
                            Consumer<SharedPreferencesProvider>(
                          builder: (context, provider, _) {
                            return WorkerItem(
                                item: item,
                                onItemPressed: () {
                                  var cubit = BlocProvider.of<
                                          AdminSelectWorkerForAdisplayedRequestCubit>(
                                      context);
                                  if (widget.request != null) {
                                    cubit.addRequest(
                                        widget.request, item, provider.pref);
                                  } else if (widget.requestId != null) {
                                    cubit.assignRequest(
                                        widget.requestId, item, provider.pref);
                                  }
                                });
                          },
                        ),
                        firstPageErrorIndicatorBuilder: (context) =>
                            ErrorIndicator(),
                        noItemsFoundIndicatorBuilder: (context) =>
                            EmptyListIndicator(),
                      ),
                    ),
                  );
                  // return ListView.builder(
                  //   padding: EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                  //   itemCount: state.usersData.length,
                  //   itemBuilder: (context, i) {
                  //     UserData item = state.usersData[i];
                  //     return Consumer<SharedPreferencesProvider>(
                  //         builder: (context, provider, _) {
                  //       return WorkerItem(
                  //           item: item,
                  //           onItemPressed: () {
                  //             var cubit = BlocProvider.of<
                  //                     AdminSelectWorkerForAdisplayedRequestCubit>(
                  //                 context);
                  //             if (widget.request != null) {
                  //               cubit.addRequest(
                  //                   widget.request, item, provider.pref);
                  //             } else if (widget.requestId != null) {
                  //               cubit.assignRequest(
                  //                   widget.requestId, item, provider.pref);
                  //             }
                  //           });
                  //     });
                  //   },
                  // );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
