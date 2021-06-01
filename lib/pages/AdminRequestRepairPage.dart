import 'dart:io';

import 'package:an_app/Cubits/RequestRepair/request_repair_cubit.dart';
import 'package:an_app/Functions/dateFormatter.dart';
import 'package:an_app/Functions/getLocation.dart';
import 'package:an_app/Functions/myImagePicker.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/Widgets/BlueGradientAppBar.dart';
import 'package:an_app/Widgets/CustomCardButton.dart';
import 'package:an_app/Widgets/GoBackButton.dart';
import 'package:an_app/Widgets/ImageBanner.dart';
import 'package:an_app/Widgets/RecordWidget.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:an_app/models/global.dart';
import 'package:an_app/models/request.dart';
import 'package:an_app/pages/AdminSelectWorkerForADisplayedRequestPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';

import '../Cubits/RequestRepair/request_repair_cubit.dart';
import '../Cubits/RequestRepair/request_repair_cubit.dart';
import '../Cubits/RequestRepair/request_repair_cubit.dart';
import '../Cubits/RequestRepair/request_repair_cubit.dart';
// import '../global.dart';

class AdminRequestRepairPage extends StatefulWidget {
  final String enTxt;

  AdminRequestRepairPage(this.enTxt);

  @override
  _AdminRequestRepairPageState createState() => _AdminRequestRepairPageState();
}

class _AdminRequestRepairPageState extends State<AdminRequestRepairPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RequestRepairCubit>(
      create: (context) => RequestRepairCubit(),
      child: BlocConsumer<RequestRepairCubit, RequestRepairState>(
          listenWhen: (previous, current) {
        return current is RequestRepairAppointmentError ||
            current is RequestRepairFormError;
      }, listener: (context, state) {
        if (state is RequestRepairAppointmentError) {
          var snackbar = SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text("Add A Request")),
                Expanded(child: Text("أضف طلباً")),
              ],
            ),
            duration: Duration(milliseconds: 1000),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
        if (state is RequestRepairFormError) {
          var snackbar = SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                      "Please Type or Record a Message or Take an Image of Your Problem"),
                ),
                Expanded(
                    child: Text(
                        "رجاءً أكتب المشكلة أو سجل رسالة صوتية أو صور مشكلتك")),
              ],
            ),
            duration: Duration(milliseconds: 1000),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      }, buildWhen: (previous, current) {
        return current is RequestRepairError ||
            current is RequestRepairLoaded ||
            current is RequestRepairInitial ||
            current is RequestRepairLoading;
      }, builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is RequestRepairLoading,
          child: Scaffold(
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Container(
                padding: EdgeInsets.all(0),
                constraints: BoxConstraints.expand(height: 40),
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [rightColor, leftColor],
                    begin: const FractionalOffset(1.0, 1.0),
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
                  onTap: () async {
                    var cubit = BlocProvider.of<RequestRepairCubit>(context);
                    if (cubit.validator()) {
                      // print(cubit.validator());
                      cubit.emit(RequestRepairLoading());
                      LocationData _locationData = await getLocation(context);
                      var request = await cubit.returnRequest(GeoPoint(
                          _locationData.latitude, _locationData.longitude));
                      cubit.emit(RequestRepairLoaded());
                      // cubit.submitRequest(GeoPoint(
                      //     _locationData.latitude, _locationData.longitude));
                      //   "requesterId": user.uid,
                      // //TODO: Change this when category needed
                      // "category": "Heating",
                      // "requesterName": userData.fullName,
                      // "requesterAddress": userData.address,
                      // "requestText": requestText,
                      // "appointmentDate": Timestamp.fromDate(_appointmentDate),
                      // "appointmentMicrosecondsSinceEpoch":
                      // _appointmentDate.microsecondsSinceEpoch,
                      // "appointmentTimeZoneName": _appointmentDate.timeZoneName,
                      // "location":geoPoint
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              AdminSelectWorkerForADisplayedRequestPage(
                                  request: request),
                        ),
                      );
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
            ),
            body: Column(
              children: <Widget>[
                // getTopContainer(TextPair(this.enTxt, jobCatToAr[this.enTxt])),
                Stack(
                  children: [
                    BlueGradientAppBar(TextPair("Electrical", "كهربائيات")),
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    )
                  ],
                ),
                Expanded(
                  child: ListView(
                    // mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(16),
                    children: <Widget>[
                      TextField(
                        keyboardType: TextInputType.multiline,
                        minLines: 4,
                        maxLines: 7,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 8, color: leftColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'What is the problem?',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        onChanged: (value) {
                          BlocProvider.of<RequestRepairCubit>(context)
                              .requestText = value;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ReserveAppointmentButtonWidget(),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       DatePicker.showDatePicker(context,
                      //           showTitleActions: true,
                      //           minTime: DateTime(2018, 3, 5),
                      //           maxTime: DateTime(2019, 6, 7),
                      //           onChanged: (date) {
                      //         print('change $date');
                      //       }, onConfirm: (date) {
                      //         print('confirm $date');
                      //       },
                      //           currentTime: DateTime.now(),
                      //           locale: LocaleType.zh);
                      //     },
                      //     child: Text(
                      //       'show date time picker (Chinese)',
                      //       style: TextStyle(color: Colors.blue),
                      //     )),
                      SizedBox(
                        height: 16,
                      ),
                      RecordWidget(),
                      SizedBox(height: 16.0),
                      CapturedImageWidget(),

                      // Container(
                      //   padding: EdgeInsets.all(0),
                      //   constraints: BoxConstraints.expand(height: 40),
                      //   decoration: BoxDecoration(
                      //     gradient: new LinearGradient(
                      //       colors: [rightColor, leftColor],
                      //       begin: const FractionalOffset(1.0, 1.0),
                      //       end: const FractionalOffset(0.2, 0.2),
                      //       stops: [0.0, 1.0],
                      //       tileMode: TileMode.clamp,
                      //     ),
                      //     borderRadius: BorderRadius.only(
                      //       topLeft: Radius.circular(10),
                      //       topRight: Radius.circular(10),
                      //       bottomLeft: Radius.circular(10),
                      //       bottomRight: Radius.circular(10),
                      //     ),
                      //     //borderRadius: BorderRadius.circular(20.0),
                      //   ),
                      //   child: GestureDetector(
                      //     onTap: () {},
                      //     child: Center(
                      //       child: Text(
                      //         'Submit',
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontWeight: FontWeight.bold,
                      //             fontFamily: 'Montserrat'),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: 20.0),
                      // GoBackButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class ReserveAppointmentButtonWidget extends StatelessWidget {
  const ReserveAppointmentButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestRepairCubit, RequestRepairState>(
        buildWhen: (previous, current) {
      return current is RequestRepairInitial ||
          current is RequestRepairDateChosen;
    }, builder: (context, state) {
      if (state is RequestRepairDateChosen) {
        return Container(
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints.expand(height: 72),
          decoration: BoxDecoration(
            gradient: new LinearGradient(
              colors: [rightColor, leftColor],
              begin: const FractionalOffset(1.0, 1.0),
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
              DatePicker.showDateTimePicker(
                context,
                showTitleActions: true,
                minTime: DateTime.now(),
                maxTime: DateTime(DateTime.now().year, DateTime.now().month + 1,
                    DateTime.now().day),
                onConfirm: (date) {
                  // print('confirm $date');
                  BlocProvider.of<RequestRepairCubit>(context)
                      .emit(RequestRepairDateChosen(date));
                  BlocProvider.of<RequestRepairCubit>(context).appointmentDate =
                      date;
                },
                currentTime: DateTime.now(),
                locale: LocaleType.ar,
              );
            },
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, left: 16, right: 16, bottom: 8),
                    child: Text(
                      'Your appointment at ${dateFormater(state.date)}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        'موعدك في ${dateFormater(state.date)}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
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
          constraints: BoxConstraints.expand(height: 72),
          decoration: BoxDecoration(
            gradient: new LinearGradient(
              colors: [rightColor, leftColor],
              begin: const FractionalOffset(1.0, 1.0),
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
              DatePicker.showDateTimePicker(
                context,
                showTitleActions: true,
                minTime: DateTime.now(),
                maxTime: DateTime(DateTime.now().year, DateTime.now().month + 1,
                    DateTime.now().day),
                onConfirm: (date) {
                  // print('confirm $date');
                  BlocProvider.of<RequestRepairCubit>(context)
                      .emit(RequestRepairDateChosen(date));
                  BlocProvider.of<RequestRepairCubit>(context).appointmentDate =
                      date;
                },
                currentTime: DateTime.now(),
                locale: LocaleType.ar,
              );
            },
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, left: 16, right: 16, bottom: 8),
                    child: Text(
                      'Reserve an appointment',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        'إحجز موعداً',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}

class CapturedImageWidget extends StatelessWidget {
  const CapturedImageWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestRepairCubit, RequestRepairState>(
      // bloc: BlocProvider.of<RequestRepairCubit>(context),
      buildWhen: (previous, current) {
        return current is RequestRepairDefaultPhoto ||
            current is RequestRepairPreviewPhoto ||
            current is RequestRepairInitial;
      },
      builder: (context, state) {
        if (state is RequestRepairDefaultPhoto) {
          return ImageBanner(
            topStringAr: "صور المشكلة",
            topStringEn: "Take an Image",
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.camera_alt,
                color: myIconColor,
                size: 50,
              ),
              elevation: 15,
              onPressed: () async {
                //TODO: add photo from gallery by choice
                BlocProvider.of<RequestRepairCubit>(context).imagePath =
                    await myImagePicker();
                BlocProvider.of<RequestRepairCubit>(context).emit(
                    RequestRepairPreviewPhoto(
                        BlocProvider.of<RequestRepairCubit>(context)
                            .imagePath));
              },
            ),
          );
        } else if (state is RequestRepairPreviewPhoto) {
          return ImageBanner(
              topStringAr: "صورة المشكلة",
              topStringEn: "Problem's photo",
              child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.elliptical(20, 40.0)),
                  ),
                  child: Image.file(File(state.path)))
              // FloatingActionButton(
              //   heroTag: null,
              //   backgroundColor: Colors.white,
              //   child: Icon(
              //     Icons.camera_alt,
              //     color: myIconColor,
              //     size: 50,
              //   ),
              //   elevation: 15,
              //   onPressed: () async {
              //     myImagePicker();
              //   },
              // ),
              );
        } else {
          return ImageBanner(
            topStringAr: "صور المشكلة",
            topStringEn: "Take an Image",
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.camera_alt,
                color: myIconColor,
                size: 50,
              ),
              elevation: 15,
              onPressed: () async {
                //TODO: add photo from gallery by choice
                BlocProvider.of<RequestRepairCubit>(context).imagePath =
                    await myImagePicker();
                BlocProvider.of<RequestRepairCubit>(context).emit(
                  RequestRepairPreviewPhoto(
                      BlocProvider.of<RequestRepairCubit>(context).imagePath),
                );
              },
            ),
          );
        }
      },
    );
  }
}
