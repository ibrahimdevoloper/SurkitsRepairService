import 'package:an_app/Cubits/AdminDisplayRequests/admin_display_requests_cubit.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/Widgets/BlueGradientAppBar.dart';
import 'package:an_app/Widgets/EmptyListIndicator.dart';
import 'package:an_app/Widgets/ErrorIndicator.dart';
import 'package:an_app/Widgets/RequestListItem.dart';
import 'package:an_app/dialogs/AdminDisplayRequestFilterDialog.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:an_app/models/request.dart';
import 'package:an_app/pages/AdminRequestRepairPage.dart';
import 'package:an_app/pages/AdminSelectWorkerForADisplayedRequestPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AdminDisplayRequestsPage extends StatelessWidget {
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminRequestRepairPage(),
                ),
              );
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
                    if (state
                        is AdminDisplayRequestsPlayRecordButtonStateChange) {
                      return RefreshIndicator(
                        onRefresh: () =>
                            BlocProvider.of<AdminDisplayRequestsCubit>(context)
                                .getRequestsPage(0),
                        child: PagedListView<int, Request>(
                          pagingController:
                              BlocProvider.of<AdminDisplayRequestsCubit>(
                                      context)
                                  .pagingController,
                          builderDelegate: PagedChildBuilderDelegate<Request>(
                            itemBuilder: (context, item, i) => RequestListItem(
                              onItemClicked: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      AdminSelectWorkerForADisplayedRequestPage(
                                    requestId: item.requestId,
                                  ),
                                ));
                              },
                              request: item,
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
                                              .getFileStream(item.recordPath),
                                          builder: (context, value) {
                                            // var progress =
                                            //     value.data as DownloadProgress;
                                            // print(progress);
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
                                                  });
                                            } else if (value.connectionState ==
                                                    ConnectionState.waiting ||
                                                value.data
                                                    is DownloadProgress) {
                                              print(value.data);
                                              return Container(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                            // else if (value.connectionState ==
                                            //     ConnectionState.done) {
                                            //   return Container(
                                            //     child:
                                            //         CircularProgressIndicator(),
                                            //   );
                                            // }
                                            else {
                                              var file = value.data as FileInfo;
                                              print(file.file.path);
                                              BlocProvider.of<
                                                          AdminDisplayRequestsCubit>(
                                                      context)
                                                  .player
                                                  .startPlayer(
                                                      fromURI:
                                                          'file://${file.file.path}')
                                                  .whenComplete(() {
                                                var cubit = BlocProvider.of<
                                                        AdminDisplayRequestsCubit>(
                                                    context);
                                                cubit.playerIndex = -1;
                                                cubit.emit(
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
                                                    if (cubit
                                                        .player.isPlaying) {
                                                      cubit.player.stopPlayer();
                                                    }
                                                    cubit.playerIndex = -1;
                                                    cubit.emit(
                                                        AdminDisplayRequestsPlayRecordButtonStateChange());
                                                  });
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
                            BlocProvider.of<AdminDisplayRequestsCubit>(context)
                                .getRequestsPage(0),
                        child: PagedListView<int, Request>(
                          pagingController:
                              BlocProvider.of<AdminDisplayRequestsCubit>(
                                      context)
                                  .pagingController,
                          builderDelegate: PagedChildBuilderDelegate<Request>(
                            itemBuilder: (context, item, i) => RequestListItem(
                              onItemClicked: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      AdminSelectWorkerForADisplayedRequestPage(
                                    requestId: item.requestId,
                                  ),
                                ));
                              },
                              request: item,
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
                                            // print(progress);
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
                                                  });
                                            } else if (value.connectionState ==
                                                    ConnectionState.waiting ||
                                                value.data
                                                    is DownloadProgress) {
                                              print(value.data);
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
                                                          'file://${file.file.path}')
                                                  .whenComplete(() {
                                                var cubit = BlocProvider.of<
                                                        AdminDisplayRequestsCubit>(
                                                    context);
                                                cubit.playerIndex = -1;
                                                cubit.emit(
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
                                                    if (cubit
                                                        .player.isPlaying) {
                                                      cubit.player.stopPlayer();
                                                    }
                                                    cubit.playerIndex = -1;
                                                    cubit.emit(
                                                        AdminDisplayRequestsPlayRecordButtonStateChange());
                                                  });
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
                    //   else if (state is AdminDisplayRequestsError) {
                    //   //TODO: add ErrorIndicator
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
