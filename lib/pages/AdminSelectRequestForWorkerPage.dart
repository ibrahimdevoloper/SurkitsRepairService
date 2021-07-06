import 'package:an_app/Cubits/AdminSelectRequestForWorker/admin_select_request_for_worker_cubit.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/Widgets/DateBlueGradientAppBar.dart';
import 'package:an_app/Widgets/RequestListItem.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:an_app/models/request.dart';
import 'package:an_app/models/user_data.dart';
import 'package:an_app/providers/SharedPreferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';

import '../Functions/dateFormatter.dart';

class AdminSelectRequestForWorkerPage extends StatelessWidget {
  final DateTime _selectedDate;
  final List<Request> _assignedRequests;
  final UserData _worker;

  AdminSelectRequestForWorkerPage(
      {@required DateTime selectedDate,
      @required List<Request> assignedRequests,
      @required UserData worker})
      : this._selectedDate = selectedDate,
        this._assignedRequests = assignedRequests,
        this._worker = worker;

  //Does not need pagenation
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics().setCurrentScreen(
        screenName: "AdminSelectRequestForWorkerPage",
        screenClassOverride: "AdminSelectRequestForWorkerPage");
    return BlocProvider<AdminSelectRequestForWorkerCubit>(
      create: (context) => AdminSelectRequestForWorkerCubit(
          _selectedDate, _assignedRequests, _worker),
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                DateBlueGradientAppBar(
                  TextPair(
                    "Select Request ${dateFormater(_selectedDate, "yyyy/MM/dd")}",
                    "اختر طلبا ${dateFormater(_selectedDate, "yyyy/MM/dd")}",
                  ),
                ),
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                )
              ],
            ),
            // BlueGradientAppBar(TextPair('Add Worker', 'أضف عامل')),
            Expanded(
              child: Consumer<SharedPreferencesProvider>(
                  builder: (context, provider, child) {
                return BlocConsumer<AdminSelectRequestForWorkerCubit,
                        AdminSelectRequestForWorkerState>(
                    // listenWhen: (previous, current) {},
                    listener: (context, state) {},
                    buildWhen: (previous, current) {
                      return current is AdminSelectRequestForWorkerLoaded ||
                          current
                              is AdminSelectRequestForWorkerPlayRecordButtonStateChange ||
                          current is AdminSelectRequestForWorkerLoading ||
                          current is AdminSelectRequestForWorkerError;
                    },
                    builder: (context, state) {
                      if (state is AdminSelectRequestForWorkerLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is AdminSelectRequestForWorkerLoaded) {
                        var list = state.requests;
                        return ListView.builder(
                            padding: EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                            itemCount: list.length,
                            itemBuilder: (context, i) {
                              var item = list[i];
                              return RequestListItem(
                                onItemClicked: () {
                                  BlocProvider.of<
                                              AdminSelectRequestForWorkerCubit>(
                                          context)
                                      .assignRequest(
                                          item.requestId, provider.pref);
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
                                    child:
                                        BlocProvider.of<AdminSelectRequestForWorkerCubit>(
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
                                                              AdminSelectRequestForWorkerCubit>(
                                                          context)
                                                      .playerIndex = i;
                                                  BlocProvider.of<
                                                              AdminSelectRequestForWorkerCubit>(
                                                          context)
                                                      .emit(
                                                          AdminSelectRequestForWorkerPlayRecordButtonStateChange());
                                                })
                                            : StreamBuilder<FileResponse>(
                                                stream: DefaultCacheManager()
                                                    .getFileStream(
                                                        item.recordPath,
                                                        withProgress: true),
                                                builder: (context, value) {
                                                  // var progress =
                                                  //     value.data as DownloadProgress;
                                                  if (value.hasError) {
                                                    return FloatingActionButton(
                                                        heroTag: null,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Icon(
                                                          Icons.error,
                                                          color: myIconColor,
                                                          size: 34,
                                                        ),
                                                        elevation: 16,
                                                        onPressed: () {});
                                                  } else if (value
                                                          .connectionState ==
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
                                                  } else if (value
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done ||
                                                      value.data
                                                          is DownloadProgress) {
                                                    return Container(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  } else {
                                                    var file =
                                                        value.data as FileInfo;
                                                    print(file.file.path);
                                                    BlocProvider.of<
                                                                AdminSelectRequestForWorkerCubit>(
                                                            context)
                                                        .player
                                                        .startPlayer(
                                                            fromURI:
                                                                'file://${file.file.path}');
                                                    return FloatingActionButton(
                                                        heroTag: null,
                                                        backgroundColor:
                                                            Colors.white,
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
                          is AdminSelectRequestForWorkerPlayRecordButtonStateChange) {
                        var cubit =
                            BlocProvider.of<AdminSelectRequestForWorkerCubit>(
                                context);
                        var list = cubit.requests;
                        return ListView.builder(
                            padding: EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                            itemCount: list.length,
                            itemBuilder: (context, i) {
                              var item = list[i];
                              return RequestListItem(
                                onItemClicked: () {
                                  BlocProvider.of<
                                              AdminSelectRequestForWorkerCubit>(
                                          context)
                                      .assignRequest(
                                          item.requestId, provider.pref);
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
                                                        AdminSelectRequestForWorkerCubit>(
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
                                                          AdminSelectRequestForWorkerCubit>(
                                                      context)
                                                  .playerIndex = i;
                                              BlocProvider.of<
                                                          AdminSelectRequestForWorkerCubit>(
                                                      context)
                                                  .emit(
                                                      AdminSelectRequestForWorkerPlayRecordButtonStateChange());
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
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Icon(
                                                      Icons.error,
                                                      color: myIconColor,
                                                      size: 34,
                                                    ),
                                                    elevation: 16,
                                                    onPressed: () {});
                                              } else if (value
                                                          .connectionState ==
                                                      ConnectionState.waiting ||
                                                  value.data
                                                      is DownloadProgress) {
                                                return Container(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else {
                                                var file =
                                                    value.data as FileInfo;
                                                print(file.file.path);
                                                BlocProvider.of<
                                                            AdminSelectRequestForWorkerCubit>(
                                                        context)
                                                    .player
                                                    .startPlayer(
                                                        fromURI:
                                                            'file://${file.file.path}',
                                                        whenFinished: () {
                                                          BlocProvider.of<
                                                                      AdminSelectRequestForWorkerCubit>(
                                                                  context)
                                                              .playerIndex = -1;
                                                          BlocProvider.of<
                                                                      AdminSelectRequestForWorkerCubit>(
                                                                  context)
                                                              .emit(
                                                                  AdminSelectRequestForWorkerPlayRecordButtonStateChange());
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
                                                            AdminSelectRequestForWorkerCubit>(
                                                        context);
                                                    if (cubit
                                                        .player.isPlaying) {
                                                      cubit.player.stopPlayer();
                                                    }
                                                    cubit.playerIndex = -1;
                                                    cubit.emit(
                                                        AdminSelectRequestForWorkerPlayRecordButtonStateChange());
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                  ),
                                ),
                              );
                            });
                      } else if (state is AdminSelectRequestForWorkerError) {
                        return Center(
                          child: Text("Error"),
                        );
                      }
                    });
              }),
            ),
          ],
        ),
      ),
    );
  }
}
