import 'package:an_app/Cubits/AdminDisplayRequests/admin_display_requests_cubit.dart';
import 'package:an_app/UIValuesFolder/TextStyles.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/Widgets/BlueGradientAppBar.dart';
import 'package:an_app/dialogs/AdminDisplayRequestFilterDialog.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:an_app/models/request.dart';
import 'package:an_app/pages/AdminSelectWorkerForADisplayedRequestPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../Functions/dateFormatter.dart';

class AdminDisplayRequestsPage extends StatelessWidget {
  var _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminDisplayRequestsCubit>(
      create: (context) => AdminDisplayRequestsCubit(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.add,
              color: myIconColor,
              size: 34,
            ),
            elevation: 16,
            onPressed: () {
              // TODO: Add request
            }),
        body: Column(
          children: [
            Stack(
              children: [
                BlueGradientAppBar(TextPair("Select Request", "اختر طلبا")),
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    BlocBuilder<AdminDisplayRequestsCubit,
                        AdminDisplayRequestsState>(builder: (context, state) {
                      if (state is! AdminDisplayRequestsLoading) {
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
                                      AdminDisplayRequestsCubit>(context),
                                  child:
                                      adminDisplayRequestFilterDialog(context)),
                            );
                          },
                        );
                      }
                      else {
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
            // BlueGradientAppBar(TextPair('Add Worker', 'أضف عامل')),
            Expanded(
              child: BlocConsumer<AdminDisplayRequestsCubit,
                      AdminDisplayRequestsState>(
                  // listenWhen: (previous, current) {},
                  listener: (context, state) {},
                  buildWhen: (previous, current) {
                    return current is AdminDisplayRequestsLoaded ||
                        current
                            is AdminDisplayRequestsPlayRecordButtonStateChange ||
                        current is AdminDisplayRequestsLoading ||
                        current is AdminDisplayRequestsError;
                  },
                  builder: (context, state) {
                    if (state is AdminDisplayRequestsLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    else if (state is AdminDisplayRequestsLoaded) {
                      var list = state.requests;
                      return ListView.builder(
                          padding: EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                          itemCount: list.length,
                          itemBuilder: (context, i) {
                            var item = list[i];
                            return RequestListItem(
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
                                                      AdminDisplayRequestsCubit>(
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
                                                        AdminDisplayRequestsCubit>(
                                                    context)
                                                .playerIndex = i;
                                            BlocProvider.of<
                                                        AdminDisplayRequestsCubit>(
                                                    context)
                                                .emit(
                                                    AdminDisplayRequestsPlayRecordButtonStateChange());
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
                                            } else {
                                              var file = value.data as FileInfo;
                                              print(file.file.path);
                                              BlocProvider.of<
                                                          AdminDisplayRequestsCubit>(
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
                    }
                    else if (state
                        is AdminDisplayRequestsPlayRecordButtonStateChange) {
                      var cubit =
                          BlocProvider.of<AdminDisplayRequestsCubit>(context);
                      var list = cubit.requests;
                      return ListView.builder(
                          padding: EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                          itemCount: list.length,
                          itemBuilder: (context, i) {
                            var item = list[i];
                            return RequestListItem(
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
                                                      AdminDisplayRequestsCubit>(
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
                                                        AdminDisplayRequestsCubit>(
                                                    context)
                                                .playerIndex = i;
                                            BlocProvider.of<
                                                        AdminDisplayRequestsCubit>(
                                                    context)
                                                .emit(
                                                    AdminDisplayRequestsPlayRecordButtonStateChange());
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
                                                ConnectionState.waiting) {
                                              return Container(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else {
                                              var file = value.data as FileInfo;
                                              print(file.file.path);
                                              BlocProvider.of<
                                                          AdminDisplayRequestsCubit>(
                                                      context)
                                                  .player
                                                  .startPlayer(
                                                      fromURI:
                                                          'file://${file.file.path}',
                                                      whenFinished: () {
                                                        BlocProvider.of<
                                                                    AdminDisplayRequestsCubit>(
                                                                context)
                                                            .playerIndex = -1;
                                                        BlocProvider.of<
                                                                    AdminDisplayRequestsCubit>(
                                                                context)
                                                            .emit(
                                                                AdminDisplayRequestsPlayRecordButtonStateChange());
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
                                                          AdminDisplayRequestsCubit>(
                                                      context);
                                                  if (cubit.player.isPlaying) {
                                                    cubit.player.stopPlayer();
                                                  }
                                                  cubit.playerIndex = -1;
                                                  cubit.emit(
                                                      AdminDisplayRequestsPlayRecordButtonStateChange());
                                                },
                                              );
                                            }
                                          },
                                        ),
                                ),
                              ),
                              //TODO: control playing button
                              // isPlaying:
                              //     BlocProvider.of<AdminDisplayRequestsCubit>(
                              //                 context)
                              //             .playerIndex ==
                              //         i,
                              // onPlayButtonPressed: () {
                              //   // TODO: play using list upgrade right now using dialog
                              //   var cubit =
                              //       BlocProvider.of<AdminDisplayRequestsCubit>(
                              //           context);
                              //   // if(cubit.player.isOpen()){
                              //   //   cubit.player.stopPlayer();
                              //   // }
                              //   cubit.playerIndex = i;
                              //   cubit.emit(
                              //       AdminDisplayRequestsPlayRecordButtonStateChange());
                              // },
                            );
                          });
                    }
                    else if (state is AdminDisplayRequestsError) {
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

class RequestListItem extends StatelessWidget {
  String _requesterName;
  String _category;
  String _imagePath;
  String _requestText;
  String _recordURL;

  // bool _isPlaying;
  String _appointmentDate;

  // Function _onPlayButtonPressed;

  Widget _playIconButton;

  RequestListItem(
      {Key key,
      @required String requesterName,
      @required String category,
      @required String imagePath,
      @required String requestText,
      @required String recordURL,
      // @required bool isPlaying,
      @required String appointmentDate,
      // @required Function onPlayButtonPressed,
      @required Widget playIconButton})
      : this._requesterName = requesterName,
        this._category = category,
        this._imagePath = imagePath,
        this._requestText = requestText,
        this._recordURL = recordURL,
        // this._isPlaying = isPlaying,
        this._appointmentDate = appointmentDate,
        // this._onPlayButtonPressed = onPlayButtonPressed,
        this._playIconButton = playIconButton,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      onTap: () {
        //TODO: assign to repairman
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AdminSelectWorkerForADisplayedRequestPage(),
        ));
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Customer:$_requesterName",
                              style: titileStyleBlack,
                              textDirection: TextDirection.ltr,
                            ),
                            Text(
                              "Category: $_category",
                              style: TextStyle(
                                  fontFamily: 'Avenir',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              textDirection: TextDirection.ltr,
                            ),
                            Text(
                              "Appointment: $_appointmentDate",
                              style: TextStyle(
                                  fontFamily: 'Avenir',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              textDirection: TextDirection.ltr,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        //TODO : go to location
                      },
                    ),
                  ],
                ),
                _imagePath.isNotEmpty
                    ? AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          _imagePath,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: 0,
                        width: 0,
                      ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _recordURL.isNotEmpty
                        ? _playIconButton
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                    _requestText.isNotEmpty
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _requestText,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}