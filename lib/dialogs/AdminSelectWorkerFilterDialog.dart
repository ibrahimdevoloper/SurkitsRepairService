import 'package:an_app/Cubits/AdminSelectWorkerForADisplayedRequest/admin_select_worker_for_adisplayed_request_cubit.dart';
import 'package:an_app/models/request.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

AlertDialog adminSelectWorkerFilterDialog(BuildContext context) {
  FirebaseAnalytics().setCurrentScreen(
      screenName: "adminSelectWorkerFilterDialog",
      screenClassOverride: "adminSelectWorkerFilterDialog");

  return AlertDialog(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Filter By"),
        Text("صنف عبر"),
      ],
    ),
    content: BlocBuilder<AdminSelectWorkerForAdisplayedRequestCubit,
            AdminSelectWorkerForAdisplayedRequestState>(
        bloc: BlocProvider.of<AdminSelectWorkerForAdisplayedRequestCubit>(
            context),
        buildWhen: (previous, current) {
          return current
              is AdminSelectWorkerForAdisplayedRequestFilterStateChanged;
        },
        builder: (context, state) {
          var cubit =
              BlocProvider.of<AdminSelectWorkerForAdisplayedRequestCubit>(
                  context);
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
                  cubit.selectedCategory = value;
                  cubit.emit(
                      AdminSelectWorkerForAdisplayedRequestFilterStateChanged());
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("All"),
                    Text("الكل"),
                  ],
                ),
                groupValue: cubit.selectedCategory,
              ),
              RadioListTile(
                value: Request.CATEGORY_ELECTRICAL,
                onChanged: (value) {
                  cubit.selectedCategory = value;
                  cubit.emit(
                      AdminSelectWorkerForAdisplayedRequestFilterStateChanged());
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Electrical"),
                    Text("كهربائيات"),
                  ],
                ),
                groupValue: cubit.selectedCategory,
              ),
              RadioListTile(
                value: Request.CATEGORY_HEATING,
                onChanged: (value) {
                  cubit.selectedCategory = value;
                  cubit.emit(
                      AdminSelectWorkerForAdisplayedRequestFilterStateChanged());
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Heating"),
                    Text("تدفئة"),
                  ],
                ),
                groupValue: cubit.selectedCategory,
              ),
              RadioListTile(
                value: Request.CATEGORY_PLUMING,
                onChanged: (value) {
                  cubit.selectedCategory = value;
                  cubit.emit(
                      AdminSelectWorkerForAdisplayedRequestFilterStateChanged());
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("pluming"),
                    Text("صحية"),
                  ],
                ),
                groupValue: cubit.selectedCategory,
              ),
              RadioListTile(
                value: Request.CATEGORY_ELECTRONICS,
                onChanged: (value) {
                  cubit.selectedCategory = value;
                  cubit.emit(
                      AdminSelectWorkerForAdisplayedRequestFilterStateChanged());
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Electronics"),
                    Text("الكترونيات"),
                  ],
                ),
                groupValue: cubit.selectedCategory,
              ),
            ],
          );
        }),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Cancel"),
      ),
      ElevatedButton(
        onPressed: () {
          // BlocProvider.of<AdminSelectWorkerForAdisplayedRequestCubit>(context).getWorkers();
          BlocProvider.of<AdminSelectWorkerForAdisplayedRequestCubit>(context)
              .pagingController
              .refresh();
          Navigator.pop(context);
        },
        child: Text("Ok"),
      ),
    ],
  );
}
