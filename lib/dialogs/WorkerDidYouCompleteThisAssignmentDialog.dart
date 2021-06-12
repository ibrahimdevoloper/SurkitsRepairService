import 'package:an_app/Cubits/AdminDisplayRequests/admin_display_requests_cubit.dart';
import 'package:an_app/Cubits/CustomerRequests/customer_requests_cubit.dart';
import 'package:an_app/Cubits/WorkerAssignments/worker_assignments_cubit.dart';
import 'package:an_app/models/request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

AlertDialog workerDidYouCompleteThisAssignmentDialog(BuildContext context, Request request) {
  // FirebaseAnalytics().setCurrentScreen(
  //     screenName: "aboutCompanyDialog",
  //     screenClassOverride: "aboutCompanyDialog");
  return AlertDialog(
    title: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Did You Complete This Assignments?"),
        Text("هل أنهيت هذه المهمة؟"),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Cancel"),
      ),ElevatedButton(
        onPressed: () {
          BlocProvider.of<WorkerAssignmentsCubit>(context).assignRequest(request.requestId);
          Navigator.pop(context);
        },
        child: Text("Ok"),
      ),
    ],
  );
}
