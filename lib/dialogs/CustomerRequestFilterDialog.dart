import 'package:an_app/Cubits/AdminDisplayRequests/admin_display_requests_cubit.dart';
import 'package:an_app/Cubits/CustomerRequests/customer_requests_cubit.dart';
import 'package:an_app/models/request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

AlertDialog customerRequestFilterDialog(BuildContext context) {
  // FirebaseAnalytics().setCurrentScreen(
  //     screenName: "aboutCompanyDialog",
  //     screenClassOverride: "aboutCompanyDialog");
  return AlertDialog(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Filter By"),
        Text("صنف عبر"),
      ],
    ),
    content: BlocBuilder<CustomerRequestsCubit,CustomerRequestsState>(
      bloc: BlocProvider.of<CustomerRequestsCubit>(context),
      buildWhen: (previous,current){
        return current is CustomerRequestsFilterStateChanged;
      },
      builder: (context, state) {
        var cubit =BlocProvider.of<CustomerRequestsCubit>(context);
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
            //       cubit.emit(CustomerRequestsFilterStateChanged());
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
                cubit.emit(CustomerRequestsFilterStateChanged());
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
                cubit.emit(CustomerRequestsFilterStateChanged());
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
                cubit.emit(CustomerRequestsFilterStateChanged());
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Heating"),
                  Text("تدفئة"),
                ],
              ), groupValue: cubit.selectedCategory,
            ),RadioListTile(
              value:Request.CATEGORY_PLUMING,
              onChanged: (value) {
                cubit.selectedCategory=value;
                cubit.emit(CustomerRequestsFilterStateChanged());
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
                cubit.emit(CustomerRequestsFilterStateChanged());
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
          BlocProvider.of<CustomerRequestsCubit>(context).getRequests();
          Navigator.pop(context);
        },
        child: Text("Ok"),
      ),
    ],
  );
}
