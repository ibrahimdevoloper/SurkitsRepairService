import 'package:an_app/Cubits/AdminAddAdmin/admin_add_admin_cubit.dart';
import 'package:an_app/Functions/dateFormatter.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/Widgets/BlueGradientAppBar.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:an_app/models/request.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AdminAddAdminPage extends StatefulWidget {
  @override
  _AdminAddAdminPageState createState() => _AdminAddAdminPageState();
}

class _AdminAddAdminPageState extends State<AdminAddAdminPage> {
  @override
  void initState() {
    FirebaseAnalytics().setCurrentScreen(
        screenName: "AdminAddAdminPage",
        screenClassOverride: "AdminAddAdminPage");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminAddAdminCubit>(
      create: (context) => AdminAddAdminCubit(),
      child: Scaffold(
        // resizeToAvoidBottomPadding: false,
        body: BlocConsumer<AdminAddAdminCubit, AdminAddAdminState>(
          listenWhen: (previous, current) {
            return current is AdminAddAdminLoaded ||
                current is AdminAddAdminError;
          },
          listener: (context, state) {
            if (state is AdminAddAdminLoaded) {
              Navigator.pop(context);
            } else
            if (state is AdminAddAdminError) {
              var snackBar = SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(state.messageEn)),
                    Expanded(child: Text(state.messageAr)),
                  ],
                ),
                duration: Duration(milliseconds: 1000),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          buildWhen: (previous, current) {
            return current is AdminAddAdminInitial ||
                current is AdminAddAdminLoading ||
                current is AdminAddAdminError;
          },
          builder: (context, state) {
            return ModalProgressHUD(
              inAsyncCall: state is AdminAddAdminLoading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // getTopContainer(TextPair('Sign up', 'تسجيل دخول')),
                  BlueGradientAppBar(TextPair('Add Admin', 'أضف عامل')),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.only(top: 36.0, left: 16.0, right: 16.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          BlocBuilder<AdminAddAdminCubit, AdminAddAdminState>(
                              buildWhen: (previous, current) {
                            return current is AdminAddAdminInitial ||
                                current is AdminAddAdminFullNameError ||
                                current is AdminAddAdminFullNameReset;
                          }, builder: (context, state) {
                            return TextField(
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                errorText: state is AdminAddAdminFullNameError
                                    ? "Check Your Full Name"
                                    : null,
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: middleColor),
                                ),
                              ),
                              onChanged: (value) {
                                BlocProvider.of<AdminAddAdminCubit>(context)
                                    .fullName = value;
                              },
                              onTap: () {
                                BlocProvider.of<AdminAddAdminCubit>(context)
                                    .emit(AdminAddAdminFullNameReset());
                              },
                            );
                          }),
                          SizedBox(height: 8.0),
                          BlocBuilder<AdminAddAdminCubit, AdminAddAdminState>(
                              buildWhen: (previous, current) {
                            return current is AdminAddAdminInitial ||
                                current is AdminAddAdminEmailError ||
                                current is AdminAddAdminEmailReset;
                          }, builder: (context, state) {
                            return TextField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                errorText: state is AdminAddAdminEmailError
                                    ? "please enter a correct e-mail"
                                    : null,
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: middleColor),
                                ),
                              ),
                              onTap: () {
                                var cubit =
                                    BlocProvider.of<AdminAddAdminCubit>(
                                        context);
                                cubit.emit(AdminAddAdminEmailReset());
                              },
                              onChanged: (value) {
                                var cubit =
                                    BlocProvider.of<AdminAddAdminCubit>(
                                        context);
                                if (EmailValidator.validate(value)) {
                                  print("true");
                                  cubit.email = value;
                                  cubit.emit(AdminAddAdminEmailReset());
                                } else {
                                  print("false");
                                  cubit.email = value;
                                  cubit.emit(AdminAddAdminEmailError());
                                }
                              },
                            );
                          }),
                          SizedBox(height: 8.0),
                          BlocBuilder<AdminAddAdminCubit, AdminAddAdminState>(
                              buildWhen: (previous, current) {
                            return current is AdminAddAdminInitial ||
                                current is AdminAddAdminPasswordError ||
                                current is AdminAddAdminPasswordReset;
                          }, builder: (context, state) {
                            return TextField(
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  errorText: state
                                          is AdminAddAdminPasswordError
                                      ? "Must Contain more than 6 Characters"
                                      : null,
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: middleColor))),
                              obscureText: true,
                              onTap: () {
                                BlocProvider.of<AdminAddAdminCubit>(context)
                                    .emit(AdminAddAdminPasswordReset());
                              },
                              onChanged: (value) {
                                if (value.length >= 6) {
                                  BlocProvider.of<AdminAddAdminCubit>(context)
                                      .emit(AdminAddAdminPasswordReset());
                                  BlocProvider.of<AdminAddAdminCubit>(context)
                                      .password = value;
                                } else {
                                  BlocProvider.of<AdminAddAdminCubit>(context)
                                      .emit(AdminAddAdminPasswordError());
                                  BlocProvider.of<AdminAddAdminCubit>(context)
                                      .password = value;
                                }
                                // BlocProvider.of<AdminAddAdminCubit>(context).emit(AdminAddAdminPasswordReset());
                              },
                            );
                          }),
                          SizedBox(height: 8.0),
                          BlocBuilder<AdminAddAdminCubit, AdminAddAdminState>(
                              buildWhen: (previous, current) {
                            return current is AdminAddAdminInitial ||
                                current is AdminAddAdminConfirmPasswordError ||
                                current is AdminAddAdminConfirmPasswordReset;
                          }, builder: (context, state) {
                            return TextField(
                              decoration: InputDecoration(
                                  errorText: state
                                          is AdminAddAdminConfirmPasswordError
                                      ? "the fields don't match"
                                      : null,
                                  labelText: 'Confirm Password',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: middleColor))),
                              obscureText: true,
                              onChanged: (value) {
                                var cubit =
                                    BlocProvider.of<AdminAddAdminCubit>(
                                        context);
                                if (cubit.password.compareTo(value) == 0) {
                                  BlocProvider.of<AdminAddAdminCubit>(context)
                                      .emit(
                                          AdminAddAdminConfirmPasswordReset());
                                  BlocProvider.of<AdminAddAdminCubit>(context)
                                      .confirmPassword = value;
                                } else {
                                  BlocProvider.of<AdminAddAdminCubit>(context)
                                      .emit(
                                          AdminAddAdminConfirmPasswordError());
                                  BlocProvider.of<AdminAddAdminCubit>(context)
                                      .confirmPassword = value;
                                }
                              },
                            );
                          }),
                          SizedBox(height: 8.0),
                          BlocBuilder<AdminAddAdminCubit, AdminAddAdminState>(
                              buildWhen: (previous, current) {
                            return current is AdminAddAdminInitial ||
                                current is AdminAddAdminPhoneNumberError ||
                                current is AdminAddAdminPhoneNumberReset;
                          }, builder: (context, state) {
                            return TextField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                errorText:
                                    state is AdminAddAdminPhoneNumberError
                                        ? "Check Phone Number Field"
                                        : null,
                                labelText: 'Phone Number',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: middleColor,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                BlocProvider.of<AdminAddAdminCubit>(context)
                                    .phoneNumber = value;
                              },
                              onTap: () {
                                BlocProvider.of<AdminAddAdminCubit>(context)
                                    .emit(AdminAddAdminPhoneNumberReset());
                              },
                            );
                          }),
                          BlocBuilder<AdminAddAdminCubit, AdminAddAdminState>(
                              buildWhen: (previous, current) {
                            return current is AdminAddAdminInitial ||
                                current is AdminAddAdminAddressError ||
                                current is AdminAddAdminAddressReset;
                          }, builder: (context, state) {
                            return TextField(
                              decoration: InputDecoration(
                                errorText: state is AdminAddAdminAddressError
                                    ? "Check Address Field"
                                    : null,
                                labelText: 'Address ',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: middleColor,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                BlocProvider.of<AdminAddAdminCubit>(context)
                                    .address = value;
                              },
                              onTap: () {
                                BlocProvider.of<AdminAddAdminCubit>(context)
                                    .emit(AdminAddAdminAddressReset());
                              },
                            );
                          }),
                          // BlocBuilder<AdminAddAdminCubit, AdminAddAdminState>(
                          //     buildWhen: (previous, current) {
                          //   return current is AdminAddAdminInitial ||
                          //       current is AdminAddAdminCategorySelected;
                          // }, builder: (context, state) {
                          //   return IntrinsicHeight(
                          //     child: Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //       crossAxisAlignment: CrossAxisAlignment.stretch,
                          //       children: [
                          //         Expanded(
                          //           child: RadioListTile<String>(
                          //             title: Text("Electrical"),
                          //             onChanged: (value) {
                          //               BlocProvider.of<AdminAddAdminCubit>(
                          //                       context)
                          //                   .category = value;
                          //               BlocProvider.of<AdminAddAdminCubit>(
                          //                       context)
                          //                   .emit(
                          //                       AdminAddAdminCategorySelected(
                          //                           value));
                          //             },
                          //             groupValue: BlocProvider.of<
                          //                         AdminAddAdminCubit>(context)
                          //                     .category,
                          //             value: Request.CATEGORY_ELECTRICAL,
                          //           ),
                          //         ),
                          //         Expanded(
                          //           child: RadioListTile<String>(
                          //             title: Text("Pluming"),
                          //             onChanged: (value) {
                          //               BlocProvider.of<AdminAddAdminCubit>(
                          //                       context)
                          //                   .category = value;
                          //               BlocProvider.of<AdminAddAdminCubit>(
                          //                       context)
                          //                   .emit(
                          //                       AdminAddAdminCategorySelected(
                          //                           value));
                          //             },
                          //             groupValue: BlocProvider.of<
                          //                         AdminAddAdminCubit>(context)
                          //                     .category,
                          //             value: Request.CATEGORY_PLUMING,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   );
                          // }),
                          // BlocBuilder<AdminAddAdminCubit, AdminAddAdminState>(
                          //     buildWhen: (previous, current) {
                          //   return current is AdminAddAdminInitial ||
                          //       current is AdminAddAdminCategorySelected;
                          // }, builder: (context, state) {
                          //   return IntrinsicHeight(
                          //     child: Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //       crossAxisAlignment: CrossAxisAlignment.stretch,
                          //       children: [
                          //         Expanded(
                          //           child: RadioListTile<String>(
                          //             title: Text("Heating"),
                          //             onChanged: (value) {
                          //               BlocProvider.of<AdminAddAdminCubit>(
                          //                       context)
                          //                   .category = value;
                          //               BlocProvider.of<AdminAddAdminCubit>(
                          //                       context)
                          //                   .emit(
                          //                       AdminAddAdminCategorySelected(
                          //                           value));
                          //             },
                          //             groupValue: BlocProvider.of<
                          //                         AdminAddAdminCubit>(context)
                          //                     .category,
                          //             value: Request.CATEGORY_HEATING,
                          //           ),
                          //         ),
                          //         Expanded(
                          //           child: RadioListTile<String>(
                          //             title: Text("Electronics"),
                          //             onChanged: (value) {
                          //               print(value);
                          //               BlocProvider.of<AdminAddAdminCubit>(
                          //                       context)
                          //                   .category = value;
                          //               BlocProvider.of<AdminAddAdminCubit>(
                          //                       context)
                          //                   .emit(
                          //                       AdminAddAdminCategorySelected(
                          //                           value));
                          //             },
                          //             groupValue: BlocProvider.of<
                          //                         AdminAddAdminCubit>(context)
                          //                     .category,
                          //             value: Request.CATEGORY_ELECTRONICS,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   );
                          // }),
                          // IntrinsicHeight(
                          //   child: Row(
                          //     mainAxisSize: MainAxisSize.min,
                          //     crossAxisAlignment: CrossAxisAlignment.stretch,
                          //     children: [
                          //       Expanded(
                          //           child: BlocBuilder<AdminAddAdminCubit,
                          //                   AdminAddAdminState>(
                          //               buildWhen: (previous, current) {
                          //         return current is AdminAddAdminInitial ||
                          //             current
                          //                 is AdminAddAdminStartWorkHourSelected;
                          //       }, builder: (context, state) {
                          //         if (state
                          //             is AdminAddAdminStartWorkHourSelected) {
                          //           return Container(
                          //             padding: EdgeInsets.all(0),
                          //             constraints:
                          //                 BoxConstraints.expand(height: 72),
                          //             decoration: BoxDecoration(
                          //               gradient: new LinearGradient(
                          //                 colors: [rightColor, leftColor],
                          //                 begin:
                          //                     const FractionalOffset(1.0, 1.0),
                          //                 end: const FractionalOffset(0.2, 0.2),
                          //                 stops: [0.0, 1.0],
                          //                 tileMode: TileMode.clamp,
                          //               ),
                          //               borderRadius: BorderRadius.only(
                          //                 topLeft: Radius.circular(10),
                          //                 topRight: Radius.circular(10),
                          //                 bottomLeft: Radius.circular(10),
                          //                 bottomRight: Radius.circular(10),
                          //               ),
                          //               //borderRadius: BorderRadius.circular(20.0),
                          //             ),
                          //             child: GestureDetector(
                          //               onTap: () {
                          //                 DatePicker.showTimePicker(
                          //                   context,
                          //                   showTitleActions: true,
                          //                   showSecondsColumn: false,
                          //                   // minTime: DateTime.now(),
                          //                   // maxTime: DateTime(DateTime.now().year, DateTime.now().month + 1,
                          //                   //     DateTime.now().day),
                          //                   onConfirm: (date) {
                          //                     // date = DateTime(1,1,1,date.hour,date.minute,0,0);
                          //                     // print('start hour $date');
                          //                     BlocProvider.of<
                          //                                 AdminAddAdminCubit>(
                          //                             context)
                          //                         .emit(
                          //                             AdminAddAdminStartWorkHourSelected(
                          //                                 date));
                          //                     BlocProvider.of<
                          //                                 AdminAddAdminCubit>(
                          //                             context)
                          //                         .startHour = date;
                          //                   },
                          //                   currentTime: DateTime(1, 1, 1, 0, 0, ),
                          //                   locale: LocaleType.ar,
                          //                 );
                          //               },
                          //               child: Center(
                          //                 child: Column(
                          //                   crossAxisAlignment:
                          //                       CrossAxisAlignment.stretch,
                          //                   children: [
                          //                     Padding(
                          //                       padding: const EdgeInsets.only(
                          //                           top: 8,
                          //                           left: 16,
                          //                           right: 16,
                          //                           bottom: 8),
                          //                       child: Text(
                          //                         'starts at ${dateFormater(state.hour, 'hh:mm a')}',
                          //                         style: TextStyle(
                          //                             color: Colors.white,
                          //                             fontWeight:
                          //                                 FontWeight.bold,
                          //                             fontFamily: 'Montserrat'),
                          //                       ),
                          //                     ),
                          //                     Padding(
                          //                       padding: const EdgeInsets.only(
                          //                           left: 16,
                          //                           right: 16,
                          //                           bottom: 8),
                          //                       child: Directionality(
                          //                         textDirection:
                          //                             TextDirection.rtl,
                          //                         child: Text(
                          //                           'يبدأ عند ${dateFormater(state.hour, 'hh:mm a')}',
                          //                           style: TextStyle(
                          //                               color: Colors.white,
                          //                               fontWeight:
                          //                                   FontWeight.bold,
                          //                               fontFamily:
                          //                                   'Montserrat'),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           );
                          //         } else {
                          //           return Container(
                          //             padding: EdgeInsets.all(0),
                          //             constraints:
                          //                 BoxConstraints.expand(height: 72),
                          //             decoration: BoxDecoration(
                          //               gradient: new LinearGradient(
                          //                 colors: [rightColor, leftColor],
                          //                 begin:
                          //                     const FractionalOffset(1.0, 1.0),
                          //                 end: const FractionalOffset(0.2, 0.2),
                          //                 stops: [0.0, 1.0],
                          //                 tileMode: TileMode.clamp,
                          //               ),
                          //               borderRadius: BorderRadius.only(
                          //                 topLeft: Radius.circular(10),
                          //                 topRight: Radius.circular(10),
                          //                 bottomLeft: Radius.circular(10),
                          //                 bottomRight: Radius.circular(10),
                          //               ),
                          //               //borderRadius: BorderRadius.circular(20.0),
                          //             ),
                          //             child: GestureDetector(
                          //               onTap: () {
                          //                 DatePicker.showTimePicker(
                          //                   context,
                          //                   showTitleActions: true,
                          //                   showSecondsColumn: false,
                          //                   // minTime: DateTime.now(),
                          //                   // maxTime: DateTime(DateTime.now().year, DateTime.now().month + 1,
                          //                   //     DateTime.now().day),
                          //                   onConfirm: (date) {
                          //                     // date = DateTime(1,1,1,date.hour,date.minute,0,0);
                          //                     print('start hour $date');
                          //                     BlocProvider.of<
                          //                                 AdminAddAdminCubit>(
                          //                             context)
                          //                         .emit(
                          //                             AdminAddAdminStartWorkHourSelected(
                          //                                 date));
                          //                     BlocProvider.of<
                          //                                 AdminAddAdminCubit>(
                          //                             context)
                          //                         .startHour = date;
                          //                   },
                          //                   currentTime: DateTime(1, 1, 1, 0, 0, ),
                          //                   locale: LocaleType.ar,
                          //                 );
                          //               },
                          //               child: Center(
                          //                 child: Column(
                          //                   crossAxisAlignment:
                          //                       CrossAxisAlignment.stretch,
                          //                   children: [
                          //                     Padding(
                          //                       padding: const EdgeInsets.only(
                          //                           top: 8,
                          //                           left: 16,
                          //                           right: 16,
                          //                           bottom: 8),
                          //                       child: Text(
                          //                         'Select Start hour',
                          //                         style: TextStyle(
                          //                             color: Colors.white,
                          //                             fontWeight:
                          //                                 FontWeight.bold,
                          //                             fontFamily: 'Montserrat'),
                          //                       ),
                          //                     ),
                          //                     Padding(
                          //                       padding: const EdgeInsets.only(
                          //                           left: 16,
                          //                           right: 16,
                          //                           bottom: 8),
                          //                       child: Directionality(
                          //                         textDirection:
                          //                             TextDirection.rtl,
                          //                         child: Text(
                          //                           'اختر بداية الدوام',
                          //                           style: TextStyle(
                          //                               color: Colors.white,
                          //                               fontWeight:
                          //                                   FontWeight.bold,
                          //                               fontFamily:
                          //                                   'Montserrat'),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           );
                          //         }
                          //       })),
                          //       SizedBox(
                          //         width: 8,
                          //       ),
                          //       Expanded(
                          //           child: BlocBuilder<AdminAddAdminCubit,
                          //                   AdminAddAdminState>(
                          //               buildWhen: (previous, current) {
                          //         return current is AdminAddAdminInitial ||
                          //             current
                          //                 is AdminAddAdminEndWorkHourSelected;
                          //       }, builder: (context, state) {
                          //         if (state
                          //             is AdminAddAdminEndWorkHourSelected) {
                          //           return Container(
                          //             padding: EdgeInsets.all(0),
                          //             constraints:
                          //                 BoxConstraints.expand(height: 72),
                          //             decoration: BoxDecoration(
                          //               gradient: new LinearGradient(
                          //                 colors: [rightColor, leftColor],
                          //                 begin:
                          //                     const FractionalOffset(1.0, 1.0),
                          //                 end: const FractionalOffset(0.2, 0.2),
                          //                 stops: [0.0, 1.0],
                          //                 tileMode: TileMode.clamp,
                          //               ),
                          //               borderRadius: BorderRadius.only(
                          //                 topLeft: Radius.circular(10),
                          //                 topRight: Radius.circular(10),
                          //                 bottomLeft: Radius.circular(10),
                          //                 bottomRight: Radius.circular(10),
                          //               ),
                          //               //borderRadius: BorderRadius.circular(20.0),
                          //             ),
                          //             child: GestureDetector(
                          //               onTap: () {
                          //                 DatePicker.showTimePicker(
                          //                   context,
                          //                   showTitleActions: true,
                          //                   showSecondsColumn: false,
                          //                   // minTime: DateTime.now(),
                          //                   // maxTime: DateTime(DateTime.now().year, DateTime.now().month + 1,
                          //                   //     DateTime.now().day),
                          //                   onConfirm: (date) {
                          //                     // date = DateTime(1,1,1,date.hour,date.minute,0,0);
                          //                     print('end hour $date');
                          //                     BlocProvider.of<
                          //                                 AdminAddAdminCubit>(
                          //                             context)
                          //                         .emit(
                          //                             AdminAddAdminEndWorkHourSelected(
                          //                                 date));
                          //                     BlocProvider.of<
                          //                                 AdminAddAdminCubit>(
                          //                             context)
                          //                         .endHour = date;
                          //                   },
                          //                   currentTime: DateTime(1, 1, 1, 0, 0, ),
                          //                   locale: LocaleType.ar,
                          //                 );
                          //               },
                          //               child: Center(
                          //                 child: Column(
                          //                   crossAxisAlignment:
                          //                       CrossAxisAlignment.stretch,
                          //                   children: [
                          //                     Padding(
                          //                       padding: const EdgeInsets.only(
                          //                           top: 8,
                          //                           left: 16,
                          //                           right: 16,
                          //                           bottom: 8),
                          //                       child: Text(
                          //                         'Ends at ${dateFormater(state.hour, 'hh:mm a')}',
                          //                         style: TextStyle(
                          //                             color: Colors.white,
                          //                             fontWeight:
                          //                                 FontWeight.bold,
                          //                             fontFamily: 'Montserrat'),
                          //                       ),
                          //                     ),
                          //                     Padding(
                          //                       padding: const EdgeInsets.only(
                          //                           left: 16,
                          //                           right: 16,
                          //                           bottom: 8),
                          //                       child: Directionality(
                          //                         textDirection:
                          //                             TextDirection.rtl,
                          //                         child: Text(
                          //                           'ينتهي عند ${dateFormater(state.hour, 'hh:mm a')}',
                          //                           style: TextStyle(
                          //                               color: Colors.white,
                          //                               fontWeight:
                          //                                   FontWeight.bold,
                          //                               fontFamily:
                          //                                   'Montserrat'),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           );
                          //         } else {
                          //           return Container(
                          //             padding: EdgeInsets.all(0),
                          //             constraints:
                          //                 BoxConstraints.expand(height: 72),
                          //             decoration: BoxDecoration(
                          //               gradient: new LinearGradient(
                          //                 colors: [rightColor, leftColor],
                          //                 begin:
                          //                     const FractionalOffset(1.0, 1.0),
                          //                 end: const FractionalOffset(0.2, 0.2),
                          //                 stops: [0.0, 1.0],
                          //                 tileMode: TileMode.clamp,
                          //               ),
                          //               borderRadius: BorderRadius.only(
                          //                 topLeft: Radius.circular(10),
                          //                 topRight: Radius.circular(10),
                          //                 bottomLeft: Radius.circular(10),
                          //                 bottomRight: Radius.circular(10),
                          //               ),
                          //               //borderRadius: BorderRadius.circular(20.0),
                          //             ),
                          //             child: GestureDetector(
                          //               onTap: () {
                          //                 DatePicker.showTimePicker(
                          //                   context,
                          //                   showTitleActions: true,
                          //                   showSecondsColumn: false,
                          //                   // minTime: DateTime.now(),
                          //                   // maxTime: DateTime(DateTime.now().year, DateTime.now().month + 1,
                          //                   //     DateTime.now().day),
                          //                   onConfirm: (date) {
                          //                     // date = DateTime(1,1,1,date.hour,date.minute,0,0);
                          //                     print('end hour $date');
                          //                     BlocProvider.of<
                          //                                 AdminAddAdminCubit>(
                          //                             context)
                          //                         .emit(
                          //                             AdminAddAdminEndWorkHourSelected(
                          //                                 date));
                          //                     BlocProvider.of<
                          //                                 AdminAddAdminCubit>(
                          //                             context)
                          //                         .endHour = date;
                          //                   },
                          //                   currentTime: DateTime(1, 1, 1, 0, 0, ),
                          //                   locale: LocaleType.ar,
                          //                 );
                          //               },
                          //               child: Center(
                          //                 child: Column(
                          //                   crossAxisAlignment:
                          //                       CrossAxisAlignment.stretch,
                          //                   children: [
                          //                     Padding(
                          //                       padding: const EdgeInsets.only(
                          //                           top: 8,
                          //                           left: 16,
                          //                           right: 16,
                          //                           bottom: 8),
                          //                       child: Text(
                          //                         'Select end hour',
                          //                         style: TextStyle(
                          //                             color: Colors.white,
                          //                             fontWeight:
                          //                                 FontWeight.bold,
                          //                             fontFamily: 'Montserrat'),
                          //                       ),
                          //                     ),
                          //                     Padding(
                          //                       padding: const EdgeInsets.only(
                          //                           left: 16,
                          //                           right: 16,
                          //                           bottom: 8),
                          //                       child: Directionality(
                          //                         textDirection:
                          //                             TextDirection.rtl,
                          //                         child: Text(
                          //                           'اختر نهاية الدوام',
                          //                           style: TextStyle(
                          //                               color: Colors.white,
                          //                               fontWeight:
                          //                                   FontWeight.bold,
                          //                               fontFamily:
                          //                                   'Montserrat'),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           );
                          //         }
                          //       })),
                          //     ],
                          //   ),
                          // ),
                          SizedBox(height: 52.0),
                          Container(
                            padding: EdgeInsets.all(0),
                            constraints: BoxConstraints.expand(height: 40),
                            decoration: BoxDecoration(
                                gradient: new LinearGradient(
                                    colors: [rightColor, leftColor],
                                    begin: const FractionalOffset(1.0, 1.0),
                                    end: const FractionalOffset(0.2, 0.2),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))
                                //borderRadius: BorderRadius.circular(20.0),
                                ),
                            child: GestureDetector(
                              onTap: () {
                                var cubit =
                                    BlocProvider.of<AdminAddAdminCubit>(
                                        context);
                                if (cubit.validator()) {
                                  cubit.AdminAddAdmin();
                                } else {
                                  cubit.emit(AdminAddAdminError(
                                      "Check Fields", "تحقق من الحقول"));
                                }
                              },
                              child: Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            height: 46.0,
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1.0),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                //borderRadius: BorderRadius.circular(20.0)
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Center(
                                  child: Text('Go Back',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat')),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
