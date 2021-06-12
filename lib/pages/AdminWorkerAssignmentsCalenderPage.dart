import 'package:an_app/Cubits/AdminWorkerAssignmentsCalender/admin_worker_assignments_calender_cubit.dart';
import 'package:an_app/Functions/dateFormatter.dart';
import 'package:an_app/UIValuesFolder/TextStyles.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/Widgets/BlueGradientAppBar.dart';
import 'package:an_app/Widgets/RequestListItem.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:an_app/models/request.dart';
import 'package:an_app/models/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:table_calendar/table_calendar.dart';

import 'AdminSelectRequestForWorkerPage.dart';

class AdminWorkerAssignmentsCalenderPage extends StatelessWidget {
  final UserData _worker;

  AdminWorkerAssignmentsCalenderPage(this._worker);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminWorkerAssignmentsCalenderCubit>(
      create: (context) => AdminWorkerAssignmentsCalenderCubit(_worker.uid),
      child: Scaffold(
        floatingActionButton: BlocBuilder<AdminWorkerAssignmentsCalenderCubit,
          AdminWorkerAssignmentsCalenderState>(
          builder: (context, snapshot) {
            return FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.add,
                color: myIconColor,
                size: 34,
              ),
              elevation: 15,
              onPressed: () {
                //TODO: add assigments
                var cubit =
                    BlocProvider.of<AdminWorkerAssignmentsCalenderCubit>(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AdminSelectRequestForWorkerPage(
                      assignedRequests: cubit.requests[cubit.selectedDay]!=null?cubit.requests[cubit.selectedDay]
                          [AdminWorkerAssignmentsCalenderCubit.REQUESTS]:[],
                      selectedDate: cubit.selectedDay,
                      worker: _worker,
                    ),
                  ),
                );
              },
            );
          }
        ),
        body: Column(
          children: [
            Stack(
              children: [
                BlueGradientAppBar(
                    TextPair('Worker Calender', 'جدول العامل')),
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  // actions: [
                  //   BlocBuilder<AdminAssignRequestCubit,
                  //       AdminAssignRequestState>(builder: (context, state) {
                  //     if (state is! AdminAssignRequestLoading) {
                  //       return IconButton(
                  //         icon: Icon(
                  //           Icons.filter_list_sharp,
                  //           color: Colors.white,
                  //         ),
                  //         onPressed: () {
                  //           showDialog(
                  //             context: context,
                  //             builder: (context1) => BlocProvider.value(
                  //                 value:
                  //                 BlocProvider.of<AdminAssignRequestCubit>(
                  //                     context),
                  //                 child:
                  //                 adminAssignRequestFilterDialog(context)),
                  //           );
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
            Expanded(
              child: BlocBuilder<AdminWorkerAssignmentsCalenderCubit,
                  AdminWorkerAssignmentsCalenderState>(
                builder: (context, state) {
                  print(BlocProvider.of<AdminWorkerAssignmentsCalenderCubit>(
                          context)
                      .focusedDay
                      .toString());
                  return Column(
                    children: [
                      TableCalendar<Request>(
                        firstDay: DateTime(
                          DateTime.now().year - 10,
                        ),
                        lastDay: DateTime(
                          DateTime.now().year + 10,
                        ),
                        focusedDay: BlocProvider.of<
                                AdminWorkerAssignmentsCalenderCubit>(context)
                            .focusedDay,
                        selectedDayPredicate: (day) {
                          return isSameDay(
                              BlocProvider.of<
                                          AdminWorkerAssignmentsCalenderCubit>(
                                      context)
                                  .selectedDay,
                              day);
                        },
                        onDaySelected:
                            (DateTime selectedDay, DateTime focusedDay) {
                          var cubit = BlocProvider.of<
                              AdminWorkerAssignmentsCalenderCubit>(context);
                          cubit.focusedDay = focusedDay;
                          print(cubit.focusedDay.toString());
                          cubit.selectedDay = selectedDay;
                          cubit.emit(
                            AdminWorkerAssignmentsCalenderSelectedDayChanged(),
                          );
                        },
                        weekendDays: [
                          DateTime.friday,
                          DateTime.saturday,
                        ],
                        eventLoader: (date) => BlocProvider.of<
                                AdminWorkerAssignmentsCalenderCubit>(context)
                            .getEventList(date),
                        //     (date) {
                        //   if (date.weekday == DateTime.monday) {
                        //     return [
                        //       Request(
                        //         requestText: "hello",
                        //       )
                        //     ];
                        //   }
                        //
                        //   return [];
                        // },
                        onPageChanged: (focusedDay) {
                          print(focusedDay);
                          var cubit = BlocProvider.of<
                              AdminWorkerAssignmentsCalenderCubit>(context);
                          cubit.focusedDay = focusedDay;
                          cubit.emit(
                              AdminWorkerAssignmentsCalenderFocusedDayChanged());
                        },
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, date, requests) {
                            var cubit = BlocProvider.of<
                                AdminWorkerAssignmentsCalenderCubit>(context);

                            if (date.month == cubit.focusedDay.month) {
                              print(
                                  "$date:${cubit.requests[date][AdminWorkerAssignmentsCalenderCubit.IS_LOADING]}");
                              return cubit.requests[date][
                                      AdminWorkerAssignmentsCalenderCubit
                                          .IS_LOADING]
                                  ? Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          )),
                                    )
                                  : cubit
                                          .requests[date][
                                              AdminWorkerAssignmentsCalenderCubit
                                                  .REQUESTS]
                                          .isNotEmpty
                                      ? Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Text(
                                                cubit
                                                    .requests[date][
                                                        AdminWorkerAssignmentsCalenderCubit
                                                            .REQUESTS]
                                                    .length
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.indigo),
                                          ),
                                        )
                                      : Container(
                                          width: 0,
                                          height: 0,
                                        );
                            } else
                              return Container(
                                width: 0,
                                height: 0,
                              );
                            // return requests.length != 0
                            //     ? Align(
                            //         alignment: Alignment.topLeft,
                            //         child: Container(
                            //           child: Padding(
                            //             padding: const EdgeInsets.all(6.0),
                            //             child: Text(
                            //               requests.length.toString(),
                            //               style: TextStyle(color: Colors.white),
                            //             ),
                            //           ),
                            //           decoration: BoxDecoration(
                            //               shape: BoxShape.circle,
                            //               color: Colors.indigo),
                            //         ),
                            //       )
                            //     :
                          },
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                              child: Text(
                            "Assignments",
                            style: Theme.of(context).textTheme.headline5,
                            textAlign: TextAlign.center,
                          )),
                          Expanded(
                            child: Text(
                              "المهمات",
                              textDirection: TextDirection.rtl,
                              style: Theme.of(context).textTheme.headline5,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: BlocBuilder<AdminWorkerAssignmentsCalenderCubit,
                            AdminWorkerAssignmentsCalenderState>(
                          // stream: null,
                          buildWhen: (previous, current) {
                            return current
                                is! AdminWorkerAssignmentsCalenderFocusedDayChanged;
                          },
                          builder: (context, state) {
                            if (state
                                    is AdminWorkerAssignmentsCalenderLoading ||
                                state
                                    is AdminWorkerAssignmentsCalenderInitial) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state
                                is AdminWorkerAssignmentsCalenderLoaded) {
                              List<Request> items = state.requests;
                              if (items.isNotEmpty) {
                                return ListView.builder(
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    Request item = items[index];
                                    return RequestListItem(
                                      request: item,
                                      requesterName: item.requesterName,
                                      category: item.category,
                                      imagePath: item.imagePath,
                                      requestText: item.requestText,
                                      recordURL: item.recordPath,
                                      appointmentDate: dateFormater(
                                          item.appointmentDate.toDate()),
                                      playIconButton: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: BlocProvider.of<
                                                              AdminWorkerAssignmentsCalenderCubit>(
                                                          context)
                                                      .selectedPlayerId !=
                                                  index
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
                                                                AdminWorkerAssignmentsCalenderCubit>(
                                                            context)
                                                        .selectedPlayerId = index;
                                                    BlocProvider.of<
                                                                AdminWorkerAssignmentsCalenderCubit>(
                                                            context)
                                                        .emit(
                                                            AdminWorkerAssignmentsCalenderPlayRecordButtonStateChange());
                                                  })
                                              : StreamBuilder<FileResponse>(
                                                  stream: DefaultCacheManager()
                                                      .getFileStream(
                                                          item.recordPath,
                                                          withProgress: true),
                                                  builder: (context, value) {
                                                    // var progress =
                                                    //     value.data as DownloadProgress;
                                                    print(
                                                        value.connectionState);
                                                    print(
                                                        value.data.toString());
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
                                                        ConnectionState
                                                            .waiting|| value.data is DownloadProgress) {
                                                      return Container(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    } else {
                                                      var file = value.data
                                                          as FileInfo;
                                                      print(file.file.path);
                                                      BlocProvider.of<
                                                                  AdminWorkerAssignmentsCalenderCubit>(
                                                              context)
                                                          .player
                                                          .startPlayer(
                                                              fromURI:
                                                                  'file://${file.file.path}',
                                                              whenFinished: () {
                                                                BlocProvider.of<
                                                                            AdminWorkerAssignmentsCalenderCubit>(
                                                                        context)
                                                                    .selectedPlayerId = -1;
                                                                BlocProvider.of<
                                                                            AdminWorkerAssignmentsCalenderCubit>(
                                                                        context)
                                                                    .emit(
                                                                        AdminWorkerAssignmentsCalenderPlayRecordButtonStateChange());
                                                              });
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
                                                        onPressed: () {
                                                          var cubit = BlocProvider
                                                              .of<AdminWorkerAssignmentsCalenderCubit>(
                                                                  context);
                                                          if (cubit.player
                                                              .isPlaying) {
                                                            cubit.player
                                                                .stopPlayer();
                                                          }
                                                          cubit.selectedPlayerId =
                                                              -1;
                                                          cubit.emit(
                                                              AdminWorkerAssignmentsCalenderPlayRecordButtonStateChange());
                                                        },
                                                      );
                                                    }
                                                  },
                                                ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                    child: Text("add assignments using \n'+'",
                                      textAlign: TextAlign.center,));
                              }
                            } else if (state
                                    is AdminWorkerAssignmentsCalenderPlayRecordButtonStateChange ||
                                state
                                    is AdminWorkerAssignmentsCalenderSelectedDayChanged) {
                              var cubit = BlocProvider.of<
                                  AdminWorkerAssignmentsCalenderCubit>(context);
                              List<Request> items = cubit
                                      .requests[cubit.selectedDay][
                                  AdminWorkerAssignmentsCalenderCubit.REQUESTS];
                              if (items.isNotEmpty) {
                                return ListView.builder(
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    Request item = items[index];
                                    return RequestListItem(
                                      request: item,
                                      requesterName: item.requesterName,
                                      category: item.category,
                                      imagePath: item.imagePath,
                                      requestText: item.requestText,
                                      recordURL: item.recordPath,
                                      appointmentDate: dateFormater(
                                          item.appointmentDate.toDate()),
                                      playIconButton: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: BlocProvider.of<
                                                              AdminWorkerAssignmentsCalenderCubit>(
                                                          context)
                                                      .selectedPlayerId !=
                                                  index
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
                                                                AdminWorkerAssignmentsCalenderCubit>(
                                                            context)
                                                        .selectedPlayerId = index;
                                                    BlocProvider.of<
                                                                AdminWorkerAssignmentsCalenderCubit>(
                                                            context)
                                                        .emit(
                                                            AdminWorkerAssignmentsCalenderPlayRecordButtonStateChange());
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
                                                        ConnectionState
                                                            .waiting) {
                                                      return Container(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    } else if (value
                                                            .connectionState ==
                                                        ConnectionState.done|| value.data is DownloadProgress) {
                                                      return Container(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    } else {
                                                      var file = value.data
                                                          as FileInfo;
                                                      print(file.file.path);
                                                      BlocProvider.of<
                                                                  AdminWorkerAssignmentsCalenderCubit>(
                                                              context)
                                                          .player
                                                          .startPlayer(
                                                              fromURI:
                                                                  'file://${file.file.path}',
                                                              whenFinished: () {
                                                                BlocProvider.of<
                                                                            AdminWorkerAssignmentsCalenderCubit>(
                                                                        context)
                                                                    .selectedPlayerId = -1;
                                                                BlocProvider.of<
                                                                            AdminWorkerAssignmentsCalenderCubit>(
                                                                        context)
                                                                    .emit(
                                                                        AdminWorkerAssignmentsCalenderPlayRecordButtonStateChange());
                                                              });
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
                                                        onPressed: () {
                                                          var cubit = BlocProvider
                                                              .of<AdminWorkerAssignmentsCalenderCubit>(
                                                                  context);
                                                          if (cubit.player
                                                              .isPlaying) {
                                                            cubit.player
                                                                .stopPlayer();
                                                          }
                                                          cubit.selectedPlayerId =
                                                              -1;
                                                          cubit.emit(
                                                              AdminWorkerAssignmentsCalenderPlayRecordButtonStateChange());
                                                        },
                                                      );
                                                    }
                                                  },
                                                ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return  Center(
                                    child: Text("add assignments using \n'+'",
                                      textAlign: TextAlign.center,));
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   body: Column(
    //     children: [
    //
    //     ],
    //   ),
    // );
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
//         this._playIconButton = playIconButton,
//         this._request = request,
//         super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//         child: InkWell(
//       onTap: () {
//         // Navigator.of(context).push(MaterialPageRoute(
//         //   builder: (context) => AdminSelectWorkerForADisplayedRequestPage(
//         //     requestId: _request.requestId,
//         //   ),
//         // ));
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
