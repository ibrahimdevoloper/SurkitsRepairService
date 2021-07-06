import 'package:an_app/Cubits/CustomerRequests/customer_requests_cubit.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/Widgets/BlueGradientAppBar.dart';
import 'package:an_app/Widgets/EmptyListIndicator.dart';
import 'package:an_app/Widgets/ErrorIndicator.dart';
import 'package:an_app/Widgets/RequestListItem.dart';
import 'package:an_app/dialogs/CustomerRequestFilterDialog.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:an_app/models/request.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CustomerRequestsPage extends StatelessWidget {
  final customerId;
  // final PagingController<int, Request> _pagingController =
  //     PagingController<int, Request>(firstPageKey: 0);

  CustomerRequestsPage({Key key, this.customerId}) : super(key: key);

  // @override
  // void initState() {
  //   _pagingController = PagingController<int, Request>(firstPageKey: 0);
  //   super.initState();
  // }


  @override
  Widget build(BuildContext context) {

      FirebaseAnalytics().setCurrentScreen(
          screenName: "CustomerRequestsPage",
          screenClassOverride: "CustomerRequestsPage");


    return BlocProvider<CustomerRequestsCubit>(
      create: (context) => CustomerRequestsCubit(customerId),
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                BlueGradientAppBar(TextPair('Active Request', 'الطلب الحالي')),
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    BlocBuilder<CustomerRequestsCubit, CustomerRequestsState>(
                        builder: (context, state) {
                      if (state is! CustomerRequestsLoading) {
                        return IconButton(
                          icon: Icon(
                            Icons.filter_list_sharp,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context1) => BlocProvider.value(
                                  value: BlocProvider.of<CustomerRequestsCubit>(
                                      context),
                                  child: customerRequestFilterDialog(context)),
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
              child: BlocConsumer<CustomerRequestsCubit, CustomerRequestsState>(
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
                    // if (state is CustomerRequestsLoading) {
                    //   return Center(
                    //     child: CircularProgressIndicator(),
                    //   );
                    // }
                    // else if (state is CustomerRequestsLoaded) {
                    //   var list = state.requests;
                    //   return ListView.builder(
                    //       padding: EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                    //       itemCount: list.length,
                    //       itemBuilder: (context, i) {
                    //         var item = list[i];
                    //         return RequestListItem(
                    //           request: item,
                    //           // imagePath: item.imagePath,
                    //           // requestText: item.requestText,
                    //           // category: item.category,
                    //           // requesterName: item.requesterName,
                    //           // recordURL: item.recordPath,
                    //           // appointmentDate:
                    //           // dateFormater(item.appointmentDate.toDate()),
                    //           playIconButton: Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Center(
                    //               child: BlocProvider.of<CustomerRequestsCubit>(
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
                    //                                     CustomerRequestsCubit>(
                    //                                 context)
                    //                             .playerIndex = i;
                    //                         BlocProvider.of<
                    //                                     CustomerRequestsCubit>(
                    //                                 context)
                    //                             .emit(
                    //                                 CustomerRequestsPlayRecordButtonStateChange());
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
                    //                                       CustomerRequestsCubit>(
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
                    // } else
                    if (state is CustomerRequestsPlayRecordButtonStateChange) {
                      return RefreshIndicator(
                        onRefresh: () => Future.sync(
                          () => BlocProvider.of<CustomerRequestsCubit>(context)
                              .pagingController
                              .refresh(),
                        ),
                        child: PagedListView<int, Request>(
                          pagingController:
                              BlocProvider.of<CustomerRequestsCubit>(context)
                                  .pagingController,
                          builderDelegate: PagedChildBuilderDelegate<Request>(
                            itemBuilder: (context, item, i) => RequestListItem(
                              request: item,
                              playIconButton: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: BlocProvider.of<CustomerRequestsCubit>(
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
                                                                CustomerRequestsCubit>(
                                                            context)
                                                        .playerIndex = i;
                                                    BlocProvider.of<
                                                                CustomerRequestsCubit>(
                                                            context)
                                                        .emit(
                                                            CustomerRequestsPlayRecordButtonStateChange());
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
                                                          CustomerRequestsCubit>(
                                                      context)
                                                  .player
                                                  .startPlayer(
                                                      fromURI:
                                                          'file://${file.file.path}')
                                                  .whenComplete(() {
                                                var cubit = BlocProvider.of<
                                                        CustomerRequestsCubit>(
                                                    context);
                                                cubit.playerIndex = -1;
                                                cubit.emit(
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
                                                    if (cubit
                                                        .player.isPlaying) {
                                                      cubit.player.stopPlayer();
                                                    }
                                                    cubit.playerIndex = -1;
                                                    cubit.emit(
                                                        CustomerRequestsPlayRecordButtonStateChange());
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
                            BlocProvider.of<CustomerRequestsCubit>(context)
                                .getRequestsPage(0),
                        child: PagedListView<int, Request>(
                          pagingController:
                              BlocProvider.of<CustomerRequestsCubit>(context)
                                  .pagingController,
                          builderDelegate: PagedChildBuilderDelegate<Request>(
                            itemBuilder: (context, item, i) => RequestListItem(
                              request: item,
                              playIconButton: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: BlocProvider.of<CustomerRequestsCubit>(
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
                                                                CustomerRequestsCubit>(
                                                            context)
                                                        .playerIndex = i;
                                                    BlocProvider.of<
                                                                CustomerRequestsCubit>(
                                                            context)
                                                        .emit(
                                                            CustomerRequestsPlayRecordButtonStateChange());
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
                                                          CustomerRequestsCubit>(
                                                      context)
                                                  .player
                                                  .startPlayer(
                                                      fromURI:
                                                          'file://${file.file.path}')
                                                  .whenComplete(() {
                                                var cubit = BlocProvider.of<
                                                        CustomerRequestsCubit>(
                                                    context);
                                                cubit.playerIndex = -1;
                                                cubit.emit(
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
                                                    if (cubit
                                                        .player.isPlaying) {
                                                      cubit.player.stopPlayer();
                                                    }
                                                    cubit.playerIndex = -1;
                                                    cubit.emit(
                                                        CustomerRequestsPlayRecordButtonStateChange());
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
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
//
//
// class CustomerRequestsPage extends StatefulWidget {
//   final customerId;
//
//   CustomerRequestsPage(String this.customerId);
//
//   @override
//   _CustomerRequestsPageState createState() => _CustomerRequestsPageState();
// }
//
// class _CustomerRequestsPageState extends State<CustomerRequestsPage> {
//   PagingController<int, Request> _pagingController;
//   @override
//   void initState() {
//     _pagingController = PagingController<int, Request>(firstPageKey: 0);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<CustomerRequestsCubit>(
//       create: (context) =>
//           CustomerRequestsCubit(widget.customerId, _pagingController),
//       child: Scaffold(
//         body: Column(
//           children: [
//             Stack(
//               children: [
//                 BlueGradientAppBar(TextPair('Active Request', 'الطلب الحالي')),
//                 AppBar(
//                   backgroundColor: Colors.transparent,
//                   elevation: 0,
//                   actions: [
//                     BlocBuilder<CustomerRequestsCubit, CustomerRequestsState>(
//                         builder: (context, state) {
//                       if (state is! CustomerRequestsLoading) {
//                         return IconButton(
//                           icon: Icon(
//                             Icons.filter_list_sharp,
//                             color: Colors.white,
//                           ),
//                           onPressed: () {
//                             showDialog(
//                               context: context,
//                               builder: (context1) => BlocProvider.value(
//                                   value: BlocProvider.of<CustomerRequestsCubit>(
//                                       context),
//                                   child: customerRequestFilterDialog(context)),
//                             );
//                           },
//                         );
//                       } else {
//                         return Container(
//                           height: 0,
//                           width: 0,
//                         );
//                       }
//                     }),
//                   ],
//                 ),
//               ],
//             ),
//             Expanded(
//               child: BlocConsumer<CustomerRequestsCubit, CustomerRequestsState>(
//                   // listenWhen: (previous, current) {},
//                   listener: (context, state) {},
//                   buildWhen: (previous, current) {
//                     return current is CustomerRequestsLoaded ||
//                         current
//                             is CustomerRequestsPlayRecordButtonStateChange ||
//                         current is CustomerRequestsLoading ||
//                         current is CustomerRequestsError;
//                   },
//                   builder: (context, state) {
//                     // if (state is CustomerRequestsLoading) {
//                     //   return Center(
//                     //     child: CircularProgressIndicator(),
//                     //   );
//                     // }
//                     // else if (state is CustomerRequestsLoaded) {
//                     //   var list = state.requests;
//                     //   return ListView.builder(
//                     //       padding: EdgeInsets.fromLTRB(16.0, 8, 16, 8),
//                     //       itemCount: list.length,
//                     //       itemBuilder: (context, i) {
//                     //         var item = list[i];
//                     //         return RequestListItem(
//                     //           request: item,
//                     //           // imagePath: item.imagePath,
//                     //           // requestText: item.requestText,
//                     //           // category: item.category,
//                     //           // requesterName: item.requesterName,
//                     //           // recordURL: item.recordPath,
//                     //           // appointmentDate:
//                     //           // dateFormater(item.appointmentDate.toDate()),
//                     //           playIconButton: Padding(
//                     //             padding: const EdgeInsets.all(8.0),
//                     //             child: Center(
//                     //               child: BlocProvider.of<CustomerRequestsCubit>(
//                     //                               context)
//                     //                           .playerIndex !=
//                     //                       i
//                     //                   ? FloatingActionButton(
//                     //                       heroTag: null,
//                     //                       backgroundColor: Colors.white,
//                     //                       child: Icon(
//                     //                         Icons.play_arrow,
//                     //                         color: myIconColor,
//                     //                         size: 34,
//                     //                       ),
//                     //                       elevation: 16,
//                     //                       onPressed: () {
//                     //                         BlocProvider.of<
//                     //                                     CustomerRequestsCubit>(
//                     //                                 context)
//                     //                             .playerIndex = i;
//                     //                         BlocProvider.of<
//                     //                                     CustomerRequestsCubit>(
//                     //                                 context)
//                     //                             .emit(
//                     //                                 CustomerRequestsPlayRecordButtonStateChange());
//                     //                       })
//                     //                   : StreamBuilder<FileResponse>(
//                     //                       stream: DefaultCacheManager()
//                     //                           .getFileStream(item.recordPath,
//                     //                               withProgress: true),
//                     //                       builder: (context, value) {
//                     //                         // var progress =
//                     //                         //     value.data as DownloadProgress;
//                     //                         if (value.hasError) {
//                     //                           return FloatingActionButton(
//                     //                               heroTag: null,
//                     //                               backgroundColor: Colors.white,
//                     //                               child: Icon(
//                     //                                 Icons.error,
//                     //                                 color: myIconColor,
//                     //                                 size: 34,
//                     //                               ),
//                     //                               elevation: 16,
//                     //                               onPressed: () {});
//                     //                         } else if (value.connectionState ==
//                     //                             ConnectionState.waiting) {
//                     //                           var data = value.data
//                     //                               as DownloadProgress;
//                     //                           return Container(
//                     //                             height: 15,
//                     //                             width: 15,
//                     //                             child:
//                     //                                 CircularProgressIndicator(
//                     //                               value: data.progress,
//                     //                             ),
//                     //                           );
//                     //                         } else if (value.connectionState ==
//                     //                                 ConnectionState.done ||
//                     //                             value.data
//                     //                                 is DownloadProgress) {
//                     //                           return Container(
//                     //                             child:
//                     //                                 CircularProgressIndicator(),
//                     //                           );
//                     //                         } else {
//                     //                           var file = value.data as FileInfo;
//                     //                           print(file.file.path);
//                     //                           BlocProvider.of<
//                     //                                       CustomerRequestsCubit>(
//                     //                                   context)
//                     //                               .player
//                     //                               .startPlayer(
//                     //                                   fromURI:
//                     //                                       'file://${file.file.path}');
//                     //                           return FloatingActionButton(
//                     //                               heroTag: null,
//                     //                               backgroundColor: Colors.white,
//                     //                               child: Icon(
//                     //                                 Icons.stop,
//                     //                                 color: myIconColor,
//                     //                                 size: 34,
//                     //                               ),
//                     //                               elevation: 16,
//                     //                               onPressed: () {});
//                     //                         }
//                     //                       },
//                     //                     ),
//                     //             ),
//                     //           ),
//                     //         );
//                     //       });
//                     // } else
//                     if (state is CustomerRequestsPlayRecordButtonStateChange) {
//                       return RefreshIndicator(
//                         onRefresh: () => Future.sync(
//                           () => _pagingController.refresh(),
//                         ),
//                         child: PagedListView<int, Request>(
//                           pagingController:
//                               BlocProvider.of<CustomerRequestsCubit>(context)
//                                   .pagingController,
//                           builderDelegate: PagedChildBuilderDelegate<Request>(
//                             itemBuilder: (context, item, i) => RequestListItem(
//                               request: item,
//                               playIconButton: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Center(
//                                   child: BlocProvider.of<CustomerRequestsCubit>(
//                                                   context)
//                                               .playerIndex !=
//                                           i
//                                       ? FloatingActionButton(
//                                           heroTag: null,
//                                           backgroundColor: Colors.white,
//                                           child: Icon(
//                                             Icons.play_arrow,
//                                             color: myIconColor,
//                                             size: 34,
//                                           ),
//                                           elevation: 16,
//                                           onPressed: () {
//                                             BlocProvider.of<
//                                                         CustomerRequestsCubit>(
//                                                     context)
//                                                 .playerIndex = i;
//                                             BlocProvider.of<
//                                                         CustomerRequestsCubit>(
//                                                     context)
//                                                 .emit(
//                                                     CustomerRequestsPlayRecordButtonStateChange());
//                                           })
//                                       : StreamBuilder<FileResponse>(
//                                           stream: DefaultCacheManager()
//                                               .getFileStream(item.recordPath,
//                                                   withProgress: true),
//                                           builder: (context, value) {
//                                             // var progress =
//                                             //     value.data as DownloadProgress;
//                                             // print(progress);
//                                             if (value.hasError) {
//                                               return FloatingActionButton(
//                                                   heroTag: null,
//                                                   backgroundColor: Colors.white,
//                                                   child: Icon(
//                                                     Icons.error,
//                                                     color: myIconColor,
//                                                     size: 34,
//                                                   ),
//                                                   elevation: 16,
//                                                   onPressed: () {
//                                                     BlocProvider.of<
//                                                                 CustomerRequestsCubit>(
//                                                             context)
//                                                         .playerIndex = i;
//                                                     BlocProvider.of<
//                                                                 CustomerRequestsCubit>(
//                                                             context)
//                                                         .emit(
//                                                             CustomerRequestsPlayRecordButtonStateChange());
//                                                   });
//                                             } else if (value.connectionState ==
//                                                     ConnectionState.waiting ||
//                                                 value.data
//                                                     is DownloadProgress) {
//                                               print(value.data);
//                                               return Container(
//                                                 child:
//                                                     CircularProgressIndicator(),
//                                               );
//                                             } else {
//                                               var file = value.data as FileInfo;
//                                               print(file.file.path);
//                                               BlocProvider.of<
//                                                           CustomerRequestsCubit>(
//                                                       context)
//                                                   .player
//                                                   .startPlayer(
//                                                       fromURI:
//                                                           'file://${file.file.path}')
//                                                   .whenComplete(() {
//                                                 var cubit = BlocProvider.of<
//                                                         CustomerRequestsCubit>(
//                                                     context);
//                                                 cubit.playerIndex = -1;
//                                                 cubit.emit(
//                                                     CustomerRequestsPlayRecordButtonStateChange());
//                                               });
//                                               return FloatingActionButton(
//                                                   heroTag: null,
//                                                   backgroundColor: Colors.white,
//                                                   child: Icon(
//                                                     Icons.stop,
//                                                     color: myIconColor,
//                                                     size: 34,
//                                                   ),
//                                                   elevation: 16,
//                                                   onPressed: () {
//                                                     var cubit = BlocProvider.of<
//                                                             CustomerRequestsCubit>(
//                                                         context);
//                                                     if (cubit
//                                                         .player.isPlaying) {
//                                                       cubit.player.stopPlayer();
//                                                     }
//                                                     cubit.playerIndex = -1;
//                                                     cubit.emit(
//                                                         CustomerRequestsPlayRecordButtonStateChange());
//                                                   });
//                                             }
//                                           },
//                                         ),
//                                 ),
//                               ),
//                             ),
//                             firstPageErrorIndicatorBuilder: (context) =>
//                                 ErrorIndicator(),
//                             noItemsFoundIndicatorBuilder: (context) =>
//                                 EmptyListIndicator(),
//                           ),
//                         ),
//                       );
//                     } else {
//                       return RefreshIndicator(
//                         onRefresh: () =>
//                             BlocProvider.of<CustomerRequestsCubit>(context)
//                                 .getRequestsPage(0),
//                         child: PagedListView<int, Request>(
//                           pagingController:
//                               BlocProvider.of<CustomerRequestsCubit>(context)
//                                   .pagingController,
//                           builderDelegate: PagedChildBuilderDelegate<Request>(
//                             itemBuilder: (context, item, i) => RequestListItem(
//                               request: item,
//                               playIconButton: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Center(
//                                   child: BlocProvider.of<CustomerRequestsCubit>(
//                                                   context)
//                                               .playerIndex !=
//                                           i
//                                       ? FloatingActionButton(
//                                           heroTag: null,
//                                           backgroundColor: Colors.white,
//                                           child: Icon(
//                                             Icons.play_arrow,
//                                             color: myIconColor,
//                                             size: 34,
//                                           ),
//                                           elevation: 16,
//                                           onPressed: () {
//                                             BlocProvider.of<
//                                                         CustomerRequestsCubit>(
//                                                     context)
//                                                 .playerIndex = i;
//                                             BlocProvider.of<
//                                                         CustomerRequestsCubit>(
//                                                     context)
//                                                 .emit(
//                                                     CustomerRequestsPlayRecordButtonStateChange());
//                                           })
//                                       : StreamBuilder<FileResponse>(
//                                           stream: DefaultCacheManager()
//                                               .getFileStream(item.recordPath,
//                                                   withProgress: true),
//                                           builder: (context, value) {
//                                             // var progress =
//                                             //     value.data as DownloadProgress;
//                                             // print(progress);
//                                             if (value.hasError) {
//                                               return FloatingActionButton(
//                                                   heroTag: null,
//                                                   backgroundColor: Colors.white,
//                                                   child: Icon(
//                                                     Icons.error,
//                                                     color: myIconColor,
//                                                     size: 34,
//                                                   ),
//                                                   elevation: 16,
//                                                   onPressed: () {
//                                                     BlocProvider.of<
//                                                                 CustomerRequestsCubit>(
//                                                             context)
//                                                         .playerIndex = i;
//                                                     BlocProvider.of<
//                                                                 CustomerRequestsCubit>(
//                                                             context)
//                                                         .emit(
//                                                             CustomerRequestsPlayRecordButtonStateChange());
//                                                   });
//                                             } else if (value.connectionState ==
//                                                     ConnectionState.waiting ||
//                                                 value.data
//                                                     is DownloadProgress) {
//                                               print(value.data);
//                                               return Container(
//                                                 child:
//                                                     CircularProgressIndicator(),
//                                               );
//                                             } else {
//                                               var file = value.data as FileInfo;
//                                               print(file.file.path);
//                                               BlocProvider.of<
//                                                           CustomerRequestsCubit>(
//                                                       context)
//                                                   .player
//                                                   .startPlayer(
//                                                       fromURI:
//                                                           'file://${file.file.path}')
//                                                   .whenComplete(() {
//                                                 var cubit = BlocProvider.of<
//                                                         CustomerRequestsCubit>(
//                                                     context);
//                                                 cubit.playerIndex = -1;
//                                                 cubit.emit(
//                                                     CustomerRequestsPlayRecordButtonStateChange());
//                                               });
//                                               return FloatingActionButton(
//                                                   heroTag: null,
//                                                   backgroundColor: Colors.white,
//                                                   child: Icon(
//                                                     Icons.stop,
//                                                     color: myIconColor,
//                                                     size: 34,
//                                                   ),
//                                                   elevation: 16,
//                                                   onPressed: () {
//                                                     var cubit = BlocProvider.of<
//                                                             CustomerRequestsCubit>(
//                                                         context);
//                                                     if (cubit
//                                                         .player.isPlaying) {
//                                                       cubit.player.stopPlayer();
//                                                     }
//                                                     cubit.playerIndex = -1;
//                                                     cubit.emit(
//                                                         CustomerRequestsPlayRecordButtonStateChange());
//                                                   });
//                                             }
//                                           },
//                                         ),
//                                 ),
//                               ),
//                             ),
//                             firstPageErrorIndicatorBuilder: (context) =>
//                                 ErrorIndicator(),
//                             noItemsFoundIndicatorBuilder: (context) =>
//                                 EmptyListIndicator(),
//                           ),
//                         ),
//                       );
//                     }
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
