import 'package:an_app/Cubits/WorkerAssignments/worker_assignments_cubit.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/Widgets/BlueGradientAppBar.dart';
import 'package:an_app/Widgets/EmptyListIndicator.dart';
import 'package:an_app/Widgets/ErrorIndicator.dart';
import 'package:an_app/Widgets/RequestListItem.dart';
import 'package:an_app/dialogs/WorkerDidYouCompleteThisAssignmentDialog.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:an_app/models/request.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkerAssignmentsPage extends StatelessWidget {
  final SharedPreferences pref;

  const WorkerAssignmentsPage({Key key, this.pref}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      FirebaseAnalytics().setCurrentScreen(
          screenName: "WorkerAssignmentsPage",
          screenClassOverride: "WorkerAssignmentsPage");

    return BlocProvider<WorkerAssignmentsCubit>(
      create: (context) => WorkerAssignmentsCubit(pref),
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //     heroTag: null,
        //     backgroundColor: Colors.white,
        //     child: Icon(
        //       Icons.add,
        //       color: myIconColor,
        //       size: 34,
        //     ),
        //     elevation: 16,
        //     onPressed: () {
        //       // TODO: Add request
        //       Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminRequestRepairPage(),),);
        //     }),
        body: Column(
          children: [
            Stack(
              children: [
                BlueGradientAppBar(TextPair("Select Request", "اختر طلبا")),
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  // actions: [
                  //   BlocBuilder<WorkerAssignmentsCubit,
                  //       WorkerAssignmentsState>(builder: (context, state) {
                  //     if (state is! WorkerAssignmentsLoading) {
                  //       return IconButton(
                  //         icon: Icon(
                  //           Icons.filter_list_sharp,
                  //           color: Colors.white,
                  //         ),
                  //         onPressed: () {
                  //           //TODO: show filter dialog
                  //
                  //         },
                  //       );
                  //     } else {
                  //       return Container(
                  //         height: 0,
                  //         width: 0,
                  //       );
                  //     }
                  //   }),
                  // ],
                )
              ],
            ),
            // BlueGradientAppBar(TextPair('Add Worker', 'أضف عامل')),
            Expanded(
              child: BlocConsumer<WorkerAssignmentsCubit,
                      WorkerAssignmentsState>(
                  // listenWhen: (previous, current) {},
                  listener: (context, state) {},
                  buildWhen: (previous, current) {
                    return current is WorkerAssignmentsLoaded ||
                        current
                            is WorkerAssignmentsPlayRecordButtonStateChange ||
                        current is WorkerAssignmentsLoading ||
                        current is WorkerAssignmentsError;
                  },
                  builder: (context, state) {
                    // if (state is WorkerAssignmentsLoading) {
                    //   return Center(
                    //     child: CircularProgressIndicator(),
                    //   );
                    // } else if (state is WorkerAssignmentsLoaded) {
                    //   var list = state.requests;
                    //   return ListView.builder(
                    //       padding: EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                    //       itemCount: list.length,
                    //       itemBuilder: (context, i) {
                    //         var item = list[i];
                    //         return RequestListItem(
                    //           onItemClicked: () {
                    //             //TODO: Confirm Completion
                    //             showDialog(
                    //               context: context,
                    //               builder: (context1) => BlocProvider.value(
                    //                   value: BlocProvider.of<
                    //                       WorkerAssignmentsCubit>(context),
                    //                   child:
                    //                       workerDidYouCompleteThisAssignmentDialog(
                    //                           context, item)),
                    //             );
                    //           },
                    //           request: item,
                    //           // imagePath: item.imagePath,
                    //           // requestText: item.requestText,
                    //           // category: item.category,
                    //           // requesterName: item.requesterName,
                    //           // recordURL: item.recordPath,
                    //           // appointmentDate:
                    //           //     dateFormater(item.appointmentDate.toDate()),
                    //           playIconButton: Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Center(
                    //               child: BlocProvider.of<
                    //                                   WorkerAssignmentsCubit>(
                    //                               context)
                    //                           .playerIndex !=
                    //                       i
                    //                   ? FloatingActionButton(
                    //                       heroTag: null,
                    //                       backgroundColor: Colors.white,
                    //                       child: Icon(
                    //                         Icons.play_arrow,
                    //                         color: myIconColor,
                    //                         size: 34,
                    //                       ),
                    //                       elevation: 16,
                    //                       onPressed: () {
                    //                         BlocProvider.of<
                    //                                     WorkerAssignmentsCubit>(
                    //                                 context)
                    //                             .playerIndex = i;
                    //                         BlocProvider.of<
                    //                                     WorkerAssignmentsCubit>(
                    //                                 context)
                    //                             .emit(
                    //                                 WorkerAssignmentsPlayRecordButtonStateChange());
                    //                       })
                    //                   : StreamBuilder<FileResponse>(
                    //                       stream: DefaultCacheManager()
                    //                           .getFileStream(item.recordPath,
                    //                               withProgress: true),
                    //                       builder: (context, value) {
                    //                         // var progress =
                    //                         //     value.data as DownloadProgress;
                    //                         if (value.hasError) {
                    //                           return FloatingActionButton(
                    //                               heroTag: null,
                    //                               backgroundColor: Colors.white,
                    //                               child: Icon(
                    //                                 Icons.error,
                    //                                 color: myIconColor,
                    //                                 size: 34,
                    //                               ),
                    //                               elevation: 16,
                    //                               onPressed: () {});
                    //                         } else if (value.connectionState ==
                    //                             ConnectionState.waiting) {
                    //                           var data = value.data
                    //                               as DownloadProgress;
                    //                           return Container(
                    //                             height: 15,
                    //                             width: 15,
                    //                             child:
                    //                                 CircularProgressIndicator(
                    //                               value: data.progress,
                    //                             ),
                    //                           );
                    //                         } else if (value.connectionState ==
                    //                                 ConnectionState.done ||
                    //                             value.data
                    //                                 is DownloadProgress) {
                    //                           return Container(
                    //                             child:
                    //                                 CircularProgressIndicator(),
                    //                           );
                    //                         } else {
                    //                           var file = value.data as FileInfo;
                    //                           print(file.file.path);
                    //                           BlocProvider.of<
                    //                                       WorkerAssignmentsCubit>(
                    //                                   context)
                    //                               .player
                    //                               .startPlayer(
                    //                                   fromURI:
                    //                                       'file://${file.file.path}');
                    //                           return FloatingActionButton(
                    //                               heroTag: null,
                    //                               backgroundColor: Colors.white,
                    //                               child: Icon(
                    //                                 Icons.stop,
                    //                                 color: myIconColor,
                    //                                 size: 34,
                    //                               ),
                    //                               elevation: 16,
                    //                               onPressed: () {});
                    //                         }
                    //                       },
                    //                     ),
                    //             ),
                    //           ),
                    //         );
                    //       });
                    // }
                    // else
                    if (state is WorkerAssignmentsPlayRecordButtonStateChange) {
                      var cubit =
                          BlocProvider.of<WorkerAssignmentsCubit>(context);
                      return RefreshIndicator(
                        onRefresh: () =>
                            BlocProvider.of<WorkerAssignmentsCubit>(context)
                                .getRequestsPage(0),
                        child: PagedListView<int, Request>(
                          pagingController:
                              BlocProvider.of<WorkerAssignmentsCubit>(context)
                                  .pagingController,
                          builderDelegate: PagedChildBuilderDelegate<Request>(
                            itemBuilder: (context, item, i) => RequestListItem(
                              onItemClicked: () {
                                //TODO: Confirm Completion
                                showDialog(
                                  context: context,
                                  builder: (context1) => BlocProvider.value(
                                      value: BlocProvider.of<
                                          WorkerAssignmentsCubit>(context),
                                      child:
                                          workerDidYouCompleteThisAssignmentDialog(
                                              context, item)),
                                );
                              },
                              request: item,
                              // imagePath: item.imagePath,
                              // requestText: item.requestText,
                              // category: item.category,
                              // requesterName: item.requesterName,
                              // recordURL: item.recordPath,
                              // appointmentDate:
                              // dateFormater(item.appointmentDate.toDate()),
                              playIconButton: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: BlocProvider.of<
                                                      WorkerAssignmentsCubit>(
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
                                                        WorkerAssignmentsCubit>(
                                                    context)
                                                .playerIndex = i;
                                            BlocProvider.of<
                                                        WorkerAssignmentsCubit>(
                                                    context)
                                                .emit(
                                                    WorkerAssignmentsPlayRecordButtonStateChange());
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
                                                    ConnectionState.waiting ||
                                                value.data
                                                    is DownloadProgress) {
                                              return Container(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else {
                                              var file = value.data as FileInfo;
                                              print(file.file.path);
                                              BlocProvider.of<
                                                          WorkerAssignmentsCubit>(
                                                      context)
                                                  .player
                                                  .startPlayer(
                                                      fromURI:
                                                          'file://${file.file.path}',
                                                      whenFinished: () {
                                                        BlocProvider.of<
                                                                    WorkerAssignmentsCubit>(
                                                                context)
                                                            .playerIndex = -1;
                                                        BlocProvider.of<
                                                                    WorkerAssignmentsCubit>(
                                                                context)
                                                            .emit(
                                                                WorkerAssignmentsPlayRecordButtonStateChange());
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
                                                          WorkerAssignmentsCubit>(
                                                      context);
                                                  if (cubit.player.isPlaying) {
                                                    cubit.player.stopPlayer();
                                                  }
                                                  cubit.playerIndex = -1;
                                                  cubit.emit(
                                                      WorkerAssignmentsPlayRecordButtonStateChange());
                                                },
                                              );
                                            }
                                          },
                                        ),
                                ),
                              ),
                            ),
                            firstPageErrorIndicatorBuilder: (context) =>
                                ErrorIndicator(),
                            noItemsFoundIndicatorBuilder: (context) =>
                                EmptyListIndicator(),
                          ),
                        ),
                      );
                    } else {
                      return RefreshIndicator(
                        onRefresh: () =>
                            BlocProvider.of<WorkerAssignmentsCubit>(context)
                                .getRequestsPage(0),
                        child: PagedListView<int, Request>(
                          pagingController:
                              BlocProvider.of<WorkerAssignmentsCubit>(context)
                                  .pagingController,
                          builderDelegate: PagedChildBuilderDelegate<Request>(
                            itemBuilder: (context, item, i) => RequestListItem(
                              onItemClicked: () {
                                //TODO: Confirm Completion
                                showDialog(
                                  context: context,
                                  builder: (context1) => BlocProvider.value(
                                      value: BlocProvider.of<
                                          WorkerAssignmentsCubit>(context),
                                      child:
                                          workerDidYouCompleteThisAssignmentDialog(
                                              context, item)),
                                );
                              },
                              request: item,
                              // imagePath: item.imagePath,
                              // requestText: item.requestText,
                              // category: item.category,
                              // requesterName: item.requesterName,
                              // recordURL: item.recordPath,
                              // appointmentDate:
                              // dateFormater(item.appointmentDate.toDate()),
                              playIconButton: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: BlocProvider.of<
                                                      WorkerAssignmentsCubit>(
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
                                                        WorkerAssignmentsCubit>(
                                                    context)
                                                .playerIndex = i;
                                            BlocProvider.of<
                                                        WorkerAssignmentsCubit>(
                                                    context)
                                                .emit(
                                                    WorkerAssignmentsPlayRecordButtonStateChange());
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
                                                    ConnectionState.waiting ||
                                                value.data
                                                    is DownloadProgress) {
                                              return Container(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else {
                                              var file = value.data as FileInfo;
                                              print(file.file.path);
                                              BlocProvider.of<
                                                          WorkerAssignmentsCubit>(
                                                      context)
                                                  .player
                                                  .startPlayer(
                                                      fromURI:
                                                          'file://${file.file.path}',
                                                      whenFinished: () {
                                                        BlocProvider.of<
                                                                    WorkerAssignmentsCubit>(
                                                                context)
                                                            .playerIndex = -1;
                                                        BlocProvider.of<
                                                                    WorkerAssignmentsCubit>(
                                                                context)
                                                            .emit(
                                                                WorkerAssignmentsPlayRecordButtonStateChange());
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
                                                          WorkerAssignmentsCubit>(
                                                      context);
                                                  if (cubit.player.isPlaying) {
                                                    cubit.player.stopPlayer();
                                                  }
                                                  cubit.playerIndex = -1;
                                                  cubit.emit(
                                                      WorkerAssignmentsPlayRecordButtonStateChange());
                                                },
                                              );
                                            }
                                          },
                                        ),
                                ),
                              ),
                            ),
                            firstPageErrorIndicatorBuilder: (context) =>
                                ErrorIndicator(),
                            noItemsFoundIndicatorBuilder: (context) =>
                                EmptyListIndicator(),
                          ),
                        ),
                      );
                    }
                    //   if (state is WorkerAssignmentsError) {
                    //   return Center(
                    //     child: Text("Error"),
                    //   );
                    // }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
