import 'package:an_app/Cubits/AdminDisplayRequests/admin_display_requests_cubit.dart';
import 'package:an_app/UIValuesFolder/TextStyles.dart';
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

import '../Functions/dateFormatter.dart';

class AdminDisplayRequestsPage extends StatelessWidget {
  var _pageController = PagingController<int, Request>(firstPageKey: 0);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminDisplayRequestsCubit>(
      create: (context) => AdminDisplayRequestsCubit(_pageController),
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
                    // if (state is AdminDisplayRequestsLoading) {
                    //   return Center(
                    //     child: CircularProgressIndicator(),
                    //   );
                    // } else
                    if (state
                        is AdminDisplayRequestsPlayRecordButtonStateChange) {
                      // var list = state.requests;
                      // return ListView.builder(
                      //     padding: EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                      //     itemCount: list.length,
                      //     itemBuilder: (context, i) {
                      //       var item = list[i];
                      //       return RequestListItem(
                      //         onItemClicked: () {
                      //           Navigator.of(context).push(MaterialPageRoute(
                      //             builder: (context) =>
                      //                 AdminSelectWorkerForADisplayedRequestPage(
                      //               requestId: item.requestId,
                      //             ),
                      //           ));
                      //         },
                      //         request: item,
                      //         playIconButton: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Center(
                      //             child: BlocProvider.of<
                      //                                 AdminDisplayRequestsCubit>(
                      //                             context)
                      //                         .playerIndex !=
                      //                     i
                      //                 ? FloatingActionButton(
                      //                     heroTag: null,
                      //                     backgroundColor: Colors.white,
                      //                     child: Icon(
                      //                       Icons.play_arrow,
                      //                       color: myIconColor,
                      //                       size: 34,
                      //                     ),
                      //                     elevation: 16,
                      //                     onPressed: () {
                      //                       BlocProvider.of<
                      //                                   AdminDisplayRequestsCubit>(
                      //                               context)
                      //                           .playerIndex = i;
                      //                       BlocProvider.of<
                      //                                   AdminDisplayRequestsCubit>(
                      //                               context)
                      //                           .emit(
                      //                               AdminDisplayRequestsPlayRecordButtonStateChange());
                      //                     })
                      //                 : StreamBuilder<FileResponse>(
                      //                     stream: DefaultCacheManager()
                      //                         .getFileStream(item.recordPath,
                      //                             withProgress: true),
                      //                     builder: (context, value) {
                      //                       // var progress =
                      //                       //     value.data as DownloadProgress;
                      //                       if (value.hasError) {
                      //                         return FloatingActionButton(
                      //                             heroTag: null,
                      //                             backgroundColor: Colors.white,
                      //                             child: Icon(
                      //                               Icons.error,
                      //                               color: myIconColor,
                      //                               size: 34,
                      //                             ),
                      //                             elevation: 16,
                      //                             onPressed: () {});
                      //                       } else if (value.connectionState ==
                      //                           ConnectionState.waiting) {
                      //                         var data = value.data
                      //                             as DownloadProgress;
                      //                         return Container(
                      //                           height: 15,
                      //                           width: 15,
                      //                           child:
                      //                               CircularProgressIndicator(
                      //                             value: data.progress,
                      //                           ),
                      //                         );
                      //                       } else if (value.connectionState ==
                      //                               ConnectionState.done ||
                      //                           value.data
                      //                               is DownloadProgress) {
                      //                         return Container(
                      //                           child:
                      //                               CircularProgressIndicator(),
                      //                         );
                      //                       } else {
                      //                         var file = value.data as FileInfo;
                      //                         print(file.file.path);
                      //                         BlocProvider.of<
                      //                                     AdminDisplayRequestsCubit>(
                      //                                 context)
                      //                             .player
                      //                             .startPlayer(
                      //                                 fromURI:
                      //                                     'file://${file.file.path}');
                      //                         return FloatingActionButton(
                      //                             heroTag: null,
                      //                             backgroundColor: Colors.white,
                      //                             child: Icon(
                      //                               Icons.stop,
                      //                               color: myIconColor,
                      //                               size: 34,
                      //                             ),
                      //                             elevation: 16,
                      //                             onPressed: () {});
                      //                       }
                      //                     },
                      //                   ),
                      //           ),
                      //         ),
                      //       );
                      //     });
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
                                              return Container(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else if (value.connectionState ==
                                                ConnectionState.done) {
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
                      // var cubit =
                      //     BlocProvider.of<AdminDisplayRequestsCubit>(context);
                      // var list = cubit.requests;
                      // return ListView.builder(
                      //     padding: EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                      //     itemCount: list.length,
                      //     itemBuilder: (context, i) {
                      //       var item = list[i];
                      //       return RequestListItem(
                      //         request: item,
                      //         playIconButton: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Center(
                      //             child: BlocProvider.of<
                      //                                 AdminDisplayRequestsCubit>(
                      //                             context)
                      //                         .playerIndex !=
                      //                     i
                      //                 ? FloatingActionButton(
                      //                     heroTag: null,
                      //                     backgroundColor: Colors.white,
                      //                     child: Icon(
                      //                       Icons.play_arrow,
                      //                       color: myIconColor,
                      //                       size: 34,
                      //                     ),
                      //                     elevation: 16,
                      //                     onPressed: () {
                      //                       BlocProvider.of<
                      //                                   AdminDisplayRequestsCubit>(
                      //                               context)
                      //                           .playerIndex = i;
                      //                       BlocProvider.of<
                      //                                   AdminDisplayRequestsCubit>(
                      //                               context)
                      //                           .emit(
                      //                               AdminDisplayRequestsPlayRecordButtonStateChange());
                      //                     })
                      //                 : StreamBuilder<FileResponse>(
                      //                     stream: DefaultCacheManager()
                      //                         .getFileStream(item.recordPath,
                      //                             withProgress: true),
                      //                     builder: (context, value) {
                      //                       // var progress =
                      //                       //     value.data as DownloadProgress;
                      //                       print(value.connectionState);
                      //                       print(value.data.toString());
                      //                       if (value.hasError) {
                      //                         return FloatingActionButton(
                      //                             heroTag: null,
                      //                             backgroundColor: Colors.white,
                      //                             child: Icon(
                      //                               Icons.error,
                      //                               color: myIconColor,
                      //                               size: 34,
                      //                             ),
                      //                             elevation: 16,
                      //                             onPressed: () {});
                      //                       } else if (value.connectionState ==
                      //                               ConnectionState.waiting ||
                      //                           value.data
                      //                               is DownloadProgress) {
                      //                         return Container(
                      //                           child:
                      //                               CircularProgressIndicator(),
                      //                         );
                      //                       } else {
                      //                         var file = value.data as FileInfo;
                      //                         print(file.file.path);
                      //                         BlocProvider.of<
                      //                                     AdminDisplayRequestsCubit>(
                      //                                 context)
                      //                             .player
                      //                             .startPlayer(
                      //                                 fromURI:
                      //                                     'file://${file.file.path}',
                      //                                 whenFinished: () {
                      //                                   BlocProvider.of<
                      //                                               AdminDisplayRequestsCubit>(
                      //                                           context)
                      //                                       .playerIndex = -1;
                      //                                   BlocProvider.of<
                      //                                               AdminDisplayRequestsCubit>(
                      //                                           context)
                      //                                       .emit(
                      //                                           AdminDisplayRequestsPlayRecordButtonStateChange());
                      //                                 });
                      //                         return FloatingActionButton(
                      //                           heroTag: null,
                      //                           backgroundColor: Colors.white,
                      //                           child: Icon(
                      //                             Icons.stop,
                      //                             color: myIconColor,
                      //                             size: 34,
                      //                           ),
                      //                           elevation: 16,
                      //                           onPressed: () {
                      //                             var cubit = BlocProvider.of<
                      //                                     AdminDisplayRequestsCubit>(
                      //                                 context);
                      //                             if (cubit.player.isPlaying) {
                      //                               cubit.player.stopPlayer();
                      //                             }
                      //                             cubit.playerIndex = -1;
                      //                             cubit.emit(
                      //                                 AdminDisplayRequestsPlayRecordButtonStateChange());
                      //                           },
                      //                         );
                      //                       }
                      //                     },
                      //                   ),
                      //           ),
                      //         ),
                      //       );
                      //     });
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
                                                ConnectionState.waiting||
                                                value.data
                                                is DownloadProgress) {
                                              return Container(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else if (value.connectionState ==
                                                    ConnectionState.done) {
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

// class RequestListItem extends StatelessWidget {
//   Request _request;
//   String _requesterName;
//   String _category;
//   String _imagePath;
//   String _requestText;
//   String _recordURL;
//
//   // bool _isPlaying;
//   String _appointmentDate;
//
//   // Function _onPlayButtonPressed;
//
//   Widget _playIconButton;
//
//   RequestListItem(
//       {Key key,
//       @required Request request,
//       @required String requesterName,
//       @required String category,
//       @required String imagePath,
//       @required String requestText,
//       @required String recordURL,
//       // @required bool isPlaying,
//       @required String appointmentDate,
//       // @required Function onPlayButtonPressed,
//       @required Widget playIconButton})
//       : this._requesterName = requesterName,
//         this._category = category,
//         this._imagePath = imagePath,
//         this._requestText = requestText,
//         this._recordURL = recordURL,
//         // this._isPlaying = isPlaying,
//         this._appointmentDate = appointmentDate,
//         // this._onPlayButtonPressed = onPlayButtonPressed,
//         this._playIconButton = playIconButton,this._request = request,
//         super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//         child: InkWell(
//       onTap: () {
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => AdminSelectWorkerForADisplayedRequestPage(
//             requestId: _request.requestId,
//           ),
//         ));
//       },
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Center(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Text(
//                               "Customer:$_requesterName",
//                               style: titileStyleBlack,
//                               textDirection: TextDirection.ltr,
//                             ),
//                             Text(
//                               "Category: $_category",
//                               style: TextStyle(
//                                   fontFamily: 'Avenir',
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16),
//                               textDirection: TextDirection.ltr,
//                             ),
//                             Text(
//                               "Appointment: $_appointmentDate",
//                               style: TextStyle(
//                                   fontFamily: 'Avenir',
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16),
//                               textDirection: TextDirection.ltr,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(
//                         Icons.location_on,
//                         color: Colors.red,
//                       ),
//                       onPressed: () {
//                         //TODO : go to location
//                       },
//                     ),
//                   ],
//                 ),
//                 _imagePath.isNotEmpty
//                     ? AspectRatio(
//                         aspectRatio: 16 / 9,
//                         child: Image.network(
//                           _imagePath,
//                           fit: BoxFit.cover,
//                         ),
//                       )
//                     : Container(
//                         height: 0,
//                         width: 0,
//                       ),
//                 Row(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     _recordURL.isNotEmpty
//                         ? _playIconButton
//                         : Container(
//                             height: 0,
//                             width: 0,
//                           ),
//                     _requestText.isNotEmpty
//                         ? Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 _requestText,
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 0,
//                             width: 0,
//                           ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     ));
//   }
// }
