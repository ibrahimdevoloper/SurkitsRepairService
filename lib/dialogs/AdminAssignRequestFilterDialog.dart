import 'package:an_app/Cubits/AdminAssignRequest/admin_assign_request_cubit.dart';
import 'package:an_app/Cubits/AdminDisplayRequests/admin_display_requests_cubit.dart';
import 'package:an_app/Cubits/AdminSelectWorkerForADisplayedRequest/admin_select_worker_for_adisplayed_request_cubit.dart';
import 'package:an_app/models/request.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

AlertDialog adminAssignRequestFilterDialog(BuildContext context) {

  FirebaseAnalytics().setCurrentScreen(
      screenName: "adminAssignRequestFilterDialog",
      screenClassOverride: "adminAssignRequestFilterDialog");
  return AlertDialog(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Filter By"),
        Text("صنف عبر"),
      ],
    ),
    content: BlocBuilder<AdminAssignRequestCubit,AdminAssignRequestState>(
      bloc: BlocProvider.of<AdminAssignRequestCubit>(context),
      buildWhen: (previous,current){
        return current is AdminAssignRequestFilterStateChanged;
      },
      builder: (context, state) {
        var cubit =BlocProvider.of<AdminAssignRequestCubit>(context);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Directionality(
            //   textDirection: TextDirection.rtl,
            //   child: SwitchListTile(
            //     value: cubit.isDescending,
            //     onChanged: (value) {
            //       print(value);
            //       cubit.isDescending=value;
            //       cubit.emit(AdminDisplayRequestsFilterStateChanged());
            //     },
            //     title: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text("تنازلي"),
            //         Text("Descending"),
            //       ],
            //     ),
            //   ),
            // ),
            RadioListTile(
              value: "",
              onChanged: (value) {
                cubit.selectedCategory=value;
                cubit.emit(AdminAssignRequestFilterStateChanged());
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("All"),
                  Text("الكل"),
                ],
              ), groupValue: cubit.selectedCategory,
            ),RadioListTile(
              value: Request.CATEGORY_ELECTRICAL,
              onChanged: (value) {
                cubit.selectedCategory=value;
                cubit.emit(AdminAssignRequestFilterStateChanged());
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Electrical"),
                  Text("كهربائيات"),
                ],
              ), groupValue: cubit.selectedCategory,
            ),RadioListTile(
              value: Request.CATEGORY_HEATING,
              onChanged: (value) {
                cubit.selectedCategory=value;
                cubit.emit(AdminAssignRequestFilterStateChanged());
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Heating"),
                  Text("تدفئة"),
                ],
              ), groupValue: cubit.selectedCategory,
            ),RadioListTile(
              value: Request.CATEGORY_PLUMING,
              onChanged: (value) {
                cubit.selectedCategory=value;
                cubit.emit(AdminAssignRequestFilterStateChanged());
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("pluming"),
                  Text("صحية"),
                ],
              ), groupValue: cubit.selectedCategory,
            ),RadioListTile(
              value: Request.CATEGORY_ELECTRONICS,
              onChanged: (value) {
                cubit.selectedCategory=value;
                cubit.emit(AdminAssignRequestFilterStateChanged());
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Electronics"),
                  Text("الكترونيات"),
                ],
              ), groupValue: cubit.selectedCategory,
            ),
          ],
        );
      }
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Cancel"),
      ),ElevatedButton(
        onPressed: () {
          // BlocProvider.of<AdminAssignRequestCubit>(context).getWorkers();
          BlocProvider.of<AdminAssignRequestCubit>(context).pagingController.refresh();
          Navigator.pop(context);
        },
        child: Text("Ok"),
      ),
    ],
  );
}
