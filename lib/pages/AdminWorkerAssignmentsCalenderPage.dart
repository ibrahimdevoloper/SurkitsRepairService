import 'package:an_app/Cubits/AdminWorkerAssignmentsCalender/admin_worker_assignments_calender_cubit.dart';
import 'package:an_app/Widgets/BlueGradientAppBar.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:an_app/models/request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminWorkerAssignmentsCalenderPage extends StatelessWidget {
  final String _workerId;

  AdminWorkerAssignmentsCalenderPage(this._workerId);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminWorkerAssignmentsCalenderCubit>(
      create: (context) => AdminWorkerAssignmentsCalenderCubit(_workerId),
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
                      focusedDay:
                          BlocProvider.of<AdminWorkerAssignmentsCalenderCubit>(
                                  context)
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
                          AdminWorkerAssignmentsCalenderFocusedDayChanged(),
                        );
                      },
                      weekendDays: [
                        DateTime.friday,
                        DateTime.saturday,
                      ],
                      eventLoader:(date)=>BlocProvider.of<AdminWorkerAssignmentsCalenderCubit>(context).getEventList(date),
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
                        var cubit = BlocProvider.of<AdminWorkerAssignmentsCalenderCubit>(context);
                        cubit.focusedDay = focusedDay;
                        cubit.emit(AdminWorkerAssignmentsCalenderFocusedDayChanged());
                      },
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, requests) {
                          var cubit = BlocProvider.of<AdminWorkerAssignmentsCalenderCubit>(context);

                          if (date.month ==  cubit.focusedDay.month ) {
                            print("$date:${cubit.requests[date][
                            AdminWorkerAssignmentsCalenderCubit
                                .IS_LOADING]}");
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
                                  ): cubit
                                        .requests[date][
                                            AdminWorkerAssignmentsCalenderCubit
                                                .REQUESTS]
                                        .isNotEmpty
                                    ? Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
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
                          }
                          else return Container(
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
                    Expanded(
                        child: ListView.builder(itemBuilder: (context, index) {
                      return Text("Lord Help Me");
                    })),
                  ],
                );
              }),
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
