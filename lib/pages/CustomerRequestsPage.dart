import 'package:an_app/Cubits/AdminAssignRequest/admin_assign_request_cubit.dart';
import 'package:an_app/Cubits/CustomerRequests/customer_requests_cubit.dart';
import 'package:an_app/Functions/dateFormatter.dart';
import 'package:an_app/UIValuesFolder/TextStyles.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/Widgets/BlueGradientAppBar.dart';
import 'package:an_app/Widgets/RequestListItem.dart';
import 'package:an_app/dialogs/AdminAssignRequestFilterDialog.dart';
import 'package:an_app/dialogs/CustomerRequestFilterDialog.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:an_app/models/user_data.dart';
import 'package:an_app/pages/AdminWorkerAssignmentsCalenderPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomerRequestsPage extends StatefulWidget {
  final customerId;
  CustomerRequestsPage(String this.customerId);

  @override
  _CustomerRequestsPageState createState() => _CustomerRequestsPageState();
}

class _CustomerRequestsPageState extends State<CustomerRequestsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerRequestsCubit>(
      create: (context) => CustomerRequestsCubit(widget.customerId),
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                BlueGradientAppBar(
                    TextPair('Active Request', 'الطلب الحالي')),
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    BlocBuilder<CustomerRequestsCubit,
                        CustomerRequestsState>(builder: (context, state) {
                      if (state is! CustomerRequestsLoading) {
                        return IconButton(
                          icon: Icon(
                            Icons.filter_list_sharp,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            //TODO: show filter dialog
                            showDialog(
                              context: context,
                              builder: (context1) => BlocProvider.value(
                                  value: BlocProvider.of<
                                      CustomerRequestsCubit>(context),
                                  child:
                                  customerRequestFilterDialog(context)),
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
                ),



              ],
            ),
            Expanded(
              child: BlocConsumer<CustomerRequestsCubit,
                  CustomerRequestsState>(
                // listenWhen: (previous, current) {},
                  listener: (context, state) {},
                  buildWhen: (previous, current) {
                    return current is CustomerRequestsLoaded ||
                        current
                        is CustomerRequestsPlayRecordButtonStateChange ||
                        current is CustomerRequestsLoading ||
                        current is CustomerRequestsError;
                  },
                  builder: (context, state) {
                    if (state is CustomerRequestsLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is CustomerRequestsLoaded) {
                      var list = state.requests;
                      return ListView.builder(
                          padding: EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                          itemCount: list.length,
                          itemBuilder: (context, i) {
                            var item = list[i];
                            return RequestListItem(
                              request: item,
                              imagePath: item.imagePath,
                              requestText: item.requestText,
                              category: item.category,
                              requesterName: item.requesterName,
                              recordURL: item.recordPath,
                              appointmentDate:
                              dateFormater(item.appointmentDate.toDate()),
                              playIconButton: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: BlocProvider.of<
                                      CustomerRequestsCubit>(
                                      context)
                                      .playerIndex !=
                                      i
                                      ? FloatingActionButton(
                                      heroTag: null,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: myIconColor,
                                        size: 34,
                                      ),
                                      elevation: 16,
                                      onPressed: () {
                                        BlocProvider.of<
                                            CustomerRequestsCubit>(
                                            context)
                                            .playerIndex = i;
                                        BlocProvider.of<
                                            CustomerRequestsCubit>(
                                            context)
                                            .emit(
                                            CustomerRequestsPlayRecordButtonStateChange());
                                      })
                                      : StreamBuilder<FileResponse>(
                                    stream: DefaultCacheManager()
                                        .getFileStream(item.recordPath,
                                        withProgress: true),
                                    builder: (context, value) {
                                      // var progress =
                                      //     value.data as DownloadProgress;
                                      if (value.hasError) {
                                        return FloatingActionButton(
                                            heroTag: null,
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.error,
                                              color: myIconColor,
                                              size: 34,
                                            ),
                                            elevation: 16,
                                            onPressed: () {});
                                      } else if (value.connectionState ==
                                          ConnectionState.waiting) {
                                        var data = value.data
                                        as DownloadProgress;
                                        return Container(
                                          height: 15,
                                          width: 15,
                                          child:
                                          CircularProgressIndicator(
                                            value: data.progress,
                                          ),
                                        );
                                      }else if (value
                                          .connectionState ==
                                          ConnectionState
                                              .done|| value.data is DownloadProgress) {
                                        return Container(
                                          child:
                                          CircularProgressIndicator(),
                                        );
                                      } else {
                                        var file = value.data as FileInfo;
                                        print(file.file.path);
                                        BlocProvider.of<
                                            CustomerRequestsCubit>(
                                            context)
                                            .player
                                            .startPlayer(
                                            fromURI:
                                            'file://${file.file.path}');
                                        return FloatingActionButton(
                                            heroTag: null,
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.stop,
                                              color: myIconColor,
                                              size: 34,
                                            ),
                                            elevation: 16,
                                            onPressed: () {});
                                      }
                                    },
                                  ),
                                ),
                              ),
                            );
                          });
                    } else if (state
                    is CustomerRequestsPlayRecordButtonStateChange) {
                      var cubit =
                      BlocProvider.of<CustomerRequestsCubit>(context);
                      var list = cubit.requests;
                      return ListView.builder(
                          padding: EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                          itemCount: list.length,
                          itemBuilder: (context, i) {
                            var item = list[i];
                            return RequestListItem(
                              request: item,
                              imagePath: item.imagePath,
                              requestText: item.requestText,
                              category: item.category,
                              requesterName: item.requesterName,
                              recordURL: item.recordPath,
                              appointmentDate:
                              dateFormater(item.appointmentDate.toDate()),
                              playIconButton: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: BlocProvider.of<
                                      CustomerRequestsCubit>(
                                      context)
                                      .playerIndex !=
                                      i
                                      ? FloatingActionButton(
                                      heroTag: null,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: myIconColor,
                                        size: 34,
                                      ),
                                      elevation: 16,
                                      onPressed: () {
                                        BlocProvider.of<
                                            CustomerRequestsCubit>(
                                            context)
                                            .playerIndex = i;
                                        BlocProvider.of<
                                            CustomerRequestsCubit>(
                                            context)
                                            .emit(
                                            CustomerRequestsPlayRecordButtonStateChange());
                                      })
                                      : StreamBuilder<FileResponse>(
                                    stream: DefaultCacheManager()
                                        .getFileStream(item.recordPath,
                                        withProgress: true),
                                    builder: (context, value) {
                                      // var progress =
                                      //     value.data as DownloadProgress;
                                      print(value.connectionState);
                                      print(value.data.toString());
                                      if (value.hasError) {
                                        return FloatingActionButton(
                                            heroTag: null,
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.error,
                                              color: myIconColor,
                                              size: 34,
                                            ),
                                            elevation: 16,
                                            onPressed: () {});
                                      } else if (value.connectionState ==
                                          ConnectionState.waiting || value.data is DownloadProgress) {
                                        return Container(
                                          child:
                                          CircularProgressIndicator(),
                                        );
                                      } else {
                                        var file = value.data as FileInfo;
                                        print(file.file.path);
                                        BlocProvider.of<
                                            CustomerRequestsCubit>(
                                            context)
                                            .player
                                            .startPlayer(
                                            fromURI:
                                            'file://${file.file.path}',
                                            whenFinished: () {
                                              BlocProvider.of<
                                                  CustomerRequestsCubit>(
                                                  context)
                                                  .playerIndex = -1;
                                              BlocProvider.of<
                                                  CustomerRequestsCubit>(
                                                  context)
                                                  .emit(
                                                  CustomerRequestsPlayRecordButtonStateChange());
                                            });
                                        return FloatingActionButton(
                                          heroTag: null,
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.stop,
                                            color: myIconColor,
                                            size: 34,
                                          ),
                                          elevation: 16,
                                          onPressed: () {
                                            var cubit = BlocProvider.of<
                                                CustomerRequestsCubit>(
                                                context);
                                            if (cubit.player.isPlaying) {
                                              cubit.player.stopPlayer();
                                            }
                                            cubit.playerIndex = -1;
                                            cubit.emit(
                                                CustomerRequestsPlayRecordButtonStateChange());
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),

                            );
                          });
                    } else if (state is CustomerRequestsError) {
                      return Center(
                        child: Text("Error"),
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
