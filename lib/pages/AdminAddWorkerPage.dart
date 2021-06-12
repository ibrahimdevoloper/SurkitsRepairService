import 'package:an_app/Cubits/AdminAddWorker/admin_add_worker_cubit.dart';
import 'package:an_app/Functions/dateFormatter.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/Widgets/BlueGradientAppBar.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:an_app/models/request.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AdminAddWorkerPage extends StatefulWidget {
  @override
  _AdminAddWorkerPageState createState() => _AdminAddWorkerPageState();
}

class _AdminAddWorkerPageState extends State<AdminAddWorkerPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminAddWorkerCubit>(
      create: (context) => AdminAddWorkerCubit(),
      child: Scaffold(
        // resizeToAvoidBottomPadding: false,
        body: BlocConsumer<AdminAddWorkerCubit, AdminAddWorkerState>(
          listenWhen: (previous, current) {
            return current is AdminAddWorkerLoaded ||
                current is AdminAddWorkerError;
          },
          listener: (context, state) {
            if (state is AdminAddWorkerLoaded) {
              Navigator.pop(context);
            } else
            if (state is AdminAddWorkerError) {
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
            return current is AdminAddWorkerInitial ||
                current is AdminAddWorkerLoading ||
                current is AdminAddWorkerError;
          },
          builder: (context, state) {
            return ModalProgressHUD(
              inAsyncCall: state is AdminAddWorkerLoading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // getTopContainer(TextPair('Sign up', 'تسجيل دخول')),
                  BlueGradientAppBar(TextPair('Add Worker', 'أضف عامل')),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.only(top: 36.0, left: 16.0, right: 16.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          BlocBuilder<AdminAddWorkerCubit, AdminAddWorkerState>(
                              buildWhen: (previous, current) {
                            return current is AdminAddWorkerInitial ||
                                current is AdminAddWorkerFullNameError ||
                                current is AdminAddWorkerFullNameReset;
                          }, builder: (context, state) {
                            return TextField(
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                errorText: state is AdminAddWorkerFullNameError
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
                                BlocProvider.of<AdminAddWorkerCubit>(context)
                                    .fullName = value;
                              },
                              onTap: () {
                                BlocProvider.of<AdminAddWorkerCubit>(context)
                                    .emit(AdminAddWorkerFullNameReset());
                              },
                            );
                          }),
                          SizedBox(height: 8.0),
                          BlocBuilder<AdminAddWorkerCubit, AdminAddWorkerState>(
                              buildWhen: (previous, current) {
                            return current is AdminAddWorkerInitial ||
                                current is AdminAddWorkerEmailError ||
                                current is AdminAddWorkerEmailReset;
                          }, builder: (context, state) {
                            return TextField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                errorText: state is AdminAddWorkerEmailError
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
                                    BlocProvider.of<AdminAddWorkerCubit>(
                                        context);
                                cubit.emit(AdminAddWorkerEmailReset());
                              },
                              onChanged: (value) {
                                var cubit =
                                    BlocProvider.of<AdminAddWorkerCubit>(
                                        context);
                                if (EmailValidator.validate(value)) {
                                  print("true");
                                  cubit.email = value;
                                  cubit.emit(AdminAddWorkerEmailReset());
                                } else {
                                  print("false");
                                  cubit.email = value;
                                  cubit.emit(AdminAddWorkerEmailError());
                                }
                              },
                            );
                          }),
                          SizedBox(height: 8.0),
                          BlocBuilder<AdminAddWorkerCubit, AdminAddWorkerState>(
                              buildWhen: (previous, current) {
                            return current is AdminAddWorkerInitial ||
                                current is AdminAddWorkerPasswordError ||
                                current is AdminAddWorkerPasswordReset;
                          }, builder: (context, state) {
                            return TextField(
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  errorText: state
                                          is AdminAddWorkerPasswordError
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
                                BlocProvider.of<AdminAddWorkerCubit>(context)
                                    .emit(AdminAddWorkerPasswordReset());
                              },
                              onChanged: (value) {
                                if (value.length >= 6) {
                                  BlocProvider.of<AdminAddWorkerCubit>(context)
                                      .emit(AdminAddWorkerPasswordReset());
                                  BlocProvider.of<AdminAddWorkerCubit>(context)
                                      .password = value;
                                } else {
                                  BlocProvider.of<AdminAddWorkerCubit>(context)
                                      .emit(AdminAddWorkerPasswordError());
                                  BlocProvider.of<AdminAddWorkerCubit>(context)
                                      .password = value;
                                }
                                // BlocProvider.of<AdminAddWorkerCubit>(context).emit(AdminAddWorkerPasswordReset());
                              },
                            );
                          }),
                          SizedBox(height: 8.0),
                          BlocBuilder<AdminAddWorkerCubit, AdminAddWorkerState>(
                              buildWhen: (previous, current) {
                            return current is AdminAddWorkerInitial ||
                                current is AdminAddWorkerConfirmPasswordError ||
                                current is AdminAddWorkerConfirmPasswordReset;
                          }, builder: (context, state) {
                            return TextField(
                              decoration: InputDecoration(
                                  errorText: state
                                          is AdminAddWorkerConfirmPasswordError
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
                                    BlocProvider.of<AdminAddWorkerCubit>(
                                        context);
                                if (cubit.password.compareTo(value) == 0) {
                                  BlocProvider.of<AdminAddWorkerCubit>(context)
                                      .emit(
                                          AdminAddWorkerConfirmPasswordReset());
                                  BlocProvider.of<AdminAddWorkerCubit>(context)
                                      .confirmPassword = value;
                                } else {
                                  BlocProvider.of<AdminAddWorkerCubit>(context)
                                      .emit(
                                          AdminAddWorkerConfirmPasswordError());
                                  BlocProvider.of<AdminAddWorkerCubit>(context)
                                      .confirmPassword = value;
                                }
                              },
                            );
                          }),
                          SizedBox(height: 8.0),
                          BlocBuilder<AdminAddWorkerCubit, AdminAddWorkerState>(
                              buildWhen: (previous, current) {
                            return current is AdminAddWorkerInitial ||
                                current is AdminAddWorkerPhoneNumberError ||
                                current is AdminAddWorkerPhoneNumberReset;
                          }, builder: (context, state) {
                            return TextField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                errorText:
                                    state is AdminAddWorkerPhoneNumberError
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
                                BlocProvider.of<AdminAddWorkerCubit>(context)
                                    .phoneNumber = value;
                              },
                              onTap: () {
                                BlocProvider.of<AdminAddWorkerCubit>(context)
                                    .emit(AdminAddWorkerPhoneNumberReset());
                              },
                            );
                          }),
                          BlocBuilder<AdminAddWorkerCubit, AdminAddWorkerState>(
                              buildWhen: (previous, current) {
                            return current is AdminAddWorkerInitial ||
                                current is AdminAddWorkerAddressError ||
                                current is AdminAddWorkerAddressReset;
                          }, builder: (context, state) {
                            return TextField(
                              decoration: InputDecoration(
                                errorText: state is AdminAddWorkerAddressError
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
                                BlocProvider.of<AdminAddWorkerCubit>(context)
                                    .address = value;
                              },
                              onTap: () {
                                BlocProvider.of<AdminAddWorkerCubit>(context)
                                    .emit(AdminAddWorkerAddressReset());
                              },
                            );
                          }),
                          BlocBuilder<AdminAddWorkerCubit, AdminAddWorkerState>(
                              buildWhen: (previous, current) {
                            return current is AdminAddWorkerInitial ||
                                current is AdminAddWorkerCategorySelected;
                          }, builder: (context, state) {
                            return IntrinsicHeight(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: Text("Electrical"),
                                      onChanged: (value) {
                                        BlocProvider.of<AdminAddWorkerCubit>(
                                                context)
                                            .category = value;
                                        BlocProvider.of<AdminAddWorkerCubit>(
                                                context)
                                            .emit(
                                                AdminAddWorkerCategorySelected(
                                                    value));
                                      },
                                      groupValue: BlocProvider.of<
                                                  AdminAddWorkerCubit>(context)
                                              .category,
                                      value: Request.CATEGORY_ELECTRICAL,
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: Text("Pluming"),
                                      onChanged: (value) {
                                        BlocProvider.of<AdminAddWorkerCubit>(
                                                context)
                                            .category = value;
                                        BlocProvider.of<AdminAddWorkerCubit>(
                                                context)
                                            .emit(
                                                AdminAddWorkerCategorySelected(
                                                    value));
                                      },
                                      groupValue: BlocProvider.of<
                                                  AdminAddWorkerCubit>(context)
                                              .category,
                                      value: Request.CATEGORY_PLUMING,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          BlocBuilder<AdminAddWorkerCubit, AdminAddWorkerState>(
                              buildWhen: (previous, current) {
                            return current is AdminAddWorkerInitial ||
                                current is AdminAddWorkerCategorySelected;
                          }, builder: (context, state) {
                            return IntrinsicHeight(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: Text("Heating"),
                                      onChanged: (value) {
                                        BlocProvider.of<AdminAddWorkerCubit>(
                                                context)
                                            .category = value;
                                        BlocProvider.of<AdminAddWorkerCubit>(
                                                context)
                                            .emit(
                                                AdminAddWorkerCategorySelected(
                                                    value));
                                      },
                                      groupValue: BlocProvider.of<
                                                  AdminAddWorkerCubit>(context)
                                              .category,
                                      value: Request.CATEGORY_HEATING,
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: Text("Electronics"),
                                      onChanged: (value) {
                                        print(value);
                                        BlocProvider.of<AdminAddWorkerCubit>(
                                                context)
                                            .category = value;
                                        BlocProvider.of<AdminAddWorkerCubit>(
                                                context)
                                            .emit(
                                                AdminAddWorkerCategorySelected(
                                                    value));
                                      },
                                      groupValue: BlocProvider.of<
                                                  AdminAddWorkerCubit>(context)
                                              .category,
                                      value: Request.CATEGORY_ELECTRONICS,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                    child: BlocBuilder<AdminAddWorkerCubit,
                                            AdminAddWorkerState>(
                                        buildWhen: (previous, current) {
                                  return current is AdminAddWorkerInitial ||
                                      current
                                          is AdminAddWorkerStartWorkHourSelected;
                                }, builder: (context, state) {
                                  if (state
                                      is AdminAddWorkerStartWorkHourSelected) {
                                    return Container(
                                      padding: EdgeInsets.all(0),
                                      constraints:
                                          BoxConstraints.expand(height: 72),
                                      decoration: BoxDecoration(
                                        gradient: new LinearGradient(
                                          colors: [rightColor, leftColor],
                                          begin:
                                              const FractionalOffset(1.0, 1.0),
                                          end: const FractionalOffset(0.2, 0.2),
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        //borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          DatePicker.showTimePicker(
                                            context,
                                            showTitleActions: true,
                                            showSecondsColumn: false,
                                            // minTime: DateTime.now(),
                                            // maxTime: DateTime(DateTime.now().year, DateTime.now().month + 1,
                                            //     DateTime.now().day),
                                            onConfirm: (date) {
                                              // date = DateTime(1,1,1,date.hour,date.minute,0,0);
                                              // print('start hour $date');
                                              BlocProvider.of<
                                                          AdminAddWorkerCubit>(
                                                      context)
                                                  .emit(
                                                      AdminAddWorkerStartWorkHourSelected(
                                                          date));
                                              BlocProvider.of<
                                                          AdminAddWorkerCubit>(
                                                      context)
                                                  .startHour = date;
                                            },
                                            currentTime: DateTime(1, 1, 1, 0, 0, ),
                                            locale: LocaleType.ar,
                                          );
                                        },
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8,
                                                    left: 16,
                                                    right: 16,
                                                    bottom: 8),
                                                child: Text(
                                                  'starts at ${dateFormater(state.hour, 'hh:mm a')}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Montserrat'),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    bottom: 8),
                                                child: Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: Text(
                                                    'يبدأ عند ${dateFormater(state.hour, 'hh:mm a')}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Montserrat'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      padding: EdgeInsets.all(0),
                                      constraints:
                                          BoxConstraints.expand(height: 72),
                                      decoration: BoxDecoration(
                                        gradient: new LinearGradient(
                                          colors: [rightColor, leftColor],
                                          begin:
                                              const FractionalOffset(1.0, 1.0),
                                          end: const FractionalOffset(0.2, 0.2),
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        //borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          DatePicker.showTimePicker(
                                            context,
                                            showTitleActions: true,
                                            showSecondsColumn: false,
                                            // minTime: DateTime.now(),
                                            // maxTime: DateTime(DateTime.now().year, DateTime.now().month + 1,
                                            //     DateTime.now().day),
                                            onConfirm: (date) {
                                              // date = DateTime(1,1,1,date.hour,date.minute,0,0);
                                              print('start hour $date');
                                              BlocProvider.of<
                                                          AdminAddWorkerCubit>(
                                                      context)
                                                  .emit(
                                                      AdminAddWorkerStartWorkHourSelected(
                                                          date));
                                              BlocProvider.of<
                                                          AdminAddWorkerCubit>(
                                                      context)
                                                  .startHour = date;
                                            },
                                            currentTime: DateTime(1, 1, 1, 0, 0, ),
                                            locale: LocaleType.ar,
                                          );
                                        },
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8,
                                                    left: 16,
                                                    right: 16,
                                                    bottom: 8),
                                                child: Text(
                                                  'Select Start hour',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Montserrat'),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    bottom: 8),
                                                child: Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: Text(
                                                    'اختر بداية الدوام',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Montserrat'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                })),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                    child: BlocBuilder<AdminAddWorkerCubit,
                                            AdminAddWorkerState>(
                                        buildWhen: (previous, current) {
                                  return current is AdminAddWorkerInitial ||
                                      current
                                          is AdminAddWorkerEndWorkHourSelected;
                                }, builder: (context, state) {
                                  if (state
                                      is AdminAddWorkerEndWorkHourSelected) {
                                    return Container(
                                      padding: EdgeInsets.all(0),
                                      constraints:
                                          BoxConstraints.expand(height: 72),
                                      decoration: BoxDecoration(
                                        gradient: new LinearGradient(
                                          colors: [rightColor, leftColor],
                                          begin:
                                              const FractionalOffset(1.0, 1.0),
                                          end: const FractionalOffset(0.2, 0.2),
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        //borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          DatePicker.showTimePicker(
                                            context,
                                            showTitleActions: true,
                                            showSecondsColumn: false,
                                            // minTime: DateTime.now(),
                                            // maxTime: DateTime(DateTime.now().year, DateTime.now().month + 1,
                                            //     DateTime.now().day),
                                            onConfirm: (date) {
                                              // date = DateTime(1,1,1,date.hour,date.minute,0,0);
                                              print('end hour $date');
                                              BlocProvider.of<
                                                          AdminAddWorkerCubit>(
                                                      context)
                                                  .emit(
                                                      AdminAddWorkerEndWorkHourSelected(
                                                          date));
                                              BlocProvider.of<
                                                          AdminAddWorkerCubit>(
                                                      context)
                                                  .endHour = date;
                                            },
                                            currentTime: DateTime(1, 1, 1, 0, 0, ),
                                            locale: LocaleType.ar,
                                          );
                                        },
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8,
                                                    left: 16,
                                                    right: 16,
                                                    bottom: 8),
                                                child: Text(
                                                  'Ends at ${dateFormater(state.hour, 'hh:mm a')}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Montserrat'),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    bottom: 8),
                                                child: Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: Text(
                                                    'ينتهي عند ${dateFormater(state.hour, 'hh:mm a')}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Montserrat'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      padding: EdgeInsets.all(0),
                                      constraints:
                                          BoxConstraints.expand(height: 72),
                                      decoration: BoxDecoration(
                                        gradient: new LinearGradient(
                                          colors: [rightColor, leftColor],
                                          begin:
                                              const FractionalOffset(1.0, 1.0),
                                          end: const FractionalOffset(0.2, 0.2),
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        //borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          DatePicker.showTimePicker(
                                            context,
                                            showTitleActions: true,
                                            showSecondsColumn: false,
                                            // minTime: DateTime.now(),
                                            // maxTime: DateTime(DateTime.now().year, DateTime.now().month + 1,
                                            //     DateTime.now().day),
                                            onConfirm: (date) {
                                              // date = DateTime(1,1,1,date.hour,date.minute,0,0);
                                              print('end hour $date');
                                              BlocProvider.of<
                                                          AdminAddWorkerCubit>(
                                                      context)
                                                  .emit(
                                                      AdminAddWorkerEndWorkHourSelected(
                                                          date));
                                              BlocProvider.of<
                                                          AdminAddWorkerCubit>(
                                                      context)
                                                  .endHour = date;
                                            },
                                            currentTime: DateTime(1, 1, 1, 0, 0, ),
                                            locale: LocaleType.ar,
                                          );
                                        },
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8,
                                                    left: 16,
                                                    right: 16,
                                                    bottom: 8),
                                                child: Text(
                                                  'Select end hour',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Montserrat'),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    bottom: 8),
                                                child: Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: Text(
                                                    'اختر نهاية الدوام',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Montserrat'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                })),
                              ],
                            ),
                          ),
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
                                    BlocProvider.of<AdminAddWorkerCubit>(
                                        context);
                                if (cubit.validator()) {
                                  cubit.AdminAddWorker();
                                } else {
                                  cubit.emit(AdminAddWorkerError(
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
