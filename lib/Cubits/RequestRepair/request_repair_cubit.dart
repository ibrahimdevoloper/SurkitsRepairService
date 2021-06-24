import 'dart:io';

import 'package:an_app/Functions/sendNotificationMethod.dart';
import 'package:an_app/models/request.dart';
import 'package:an_app/models/user_data.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:meta/meta.dart';

part 'request_repair_state.dart';

class RequestRepairCubit extends Cubit<RequestRepairState> {
  FirebaseAuth _firebaseAuth;
  FirebaseStorage _firebaseStorage;
  FirebaseFirestore _firebaseFirestore;

  FlutterSoundPlayer _player = FlutterSoundPlayer();
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  String requestText = "";
  String recordPath = "";
  String imagePath = "";

  String _category = "Electrical";

  //TODO: set Appointment
  DateTime _appointmentDate;

  bool validator() {
    if (_appointmentDate == null) {
      emit(RequestRepairAppointmentError());
    } else if (!(requestText.isNotEmpty ||
        recordPath.isNotEmpty ||
        imagePath.isNotEmpty)) {
      emit(RequestRepairFormError());
    }

    return (_appointmentDate != null) &&
        (requestText.isNotEmpty ||
            recordPath.isNotEmpty ||
            imagePath.isNotEmpty);
  }

  RequestRepairCubit([String category = "Electrical"])
      : super(RequestRepairInitial()) {
    _player.openAudioSession();
    _recorder.openAudioSession();
    _firebaseFirestore = FirebaseFirestore.instance;
    _firebaseStorage = FirebaseStorage.instance;
    _firebaseAuth = FirebaseAuth.instance;
    _category = category;
  }

  submitRequest(GeoPoint geoPoint) async {
    // emit(RequestRepairLoading());
    User user = _firebaseAuth.currentUser;

    var userDoc =
        await _firebaseFirestore.collection("users").doc(user.uid).get();
    // print (userData.data());
    UserData userData = UserData.fromJson(userDoc.data());
    // Map<String, dynamic> map = {
    //   "requesterId": user.uid,
    //   //TODO: Change this when category needed
    //   "category": _category,
    //   "requesterName": userData.fullName,
    //   "requesterAddress": userData.address,
    //   "requestText": requestText,
    //   "appointmentDate": Timestamp.fromDate(_appointmentDate),
    //   "appointmentMicrosecondsSinceEpoch":
    //       _appointmentDate.microsecondsSinceEpoch,
    //   "appointmentTimeZoneName": _appointmentDate.timeZoneName,
    //   "location": geoPoint
    // };
    Request request = Request(
      category: _category,
      requestText: requestText,
      requesterId: user.uid,
      imagePath: "",
      recordPath: "",
      appointmentTimeZoneName: _appointmentDate.timeZoneName,
      appointmentMicrosecondsSinceEpoch:
          _appointmentDate.microsecondsSinceEpoch,
      appointmentDate: Timestamp.fromDate(_appointmentDate),
      requesterAddress: userData.address,
      requesterName: userData.fullName,
      location: geoPoint,
      workerEmail: "",
      workerId: "",
      workerName: "",
      workerPhoneNumber: "",
      assignedById: "",
      assignedByName: "",
      status: Request.STATUS_REQUESTED,
      fcmTokenForRequester: await FirebaseMessaging.instance.getToken(),
    );
    var submitRef = _firebaseFirestore.collection("requests");
    var requestRef = await submitRef.add(request.toJson());
    var storageRef =
        _firebaseStorage.ref().child("requests").child(requestRef.id);
    Map<String, dynamic> pathMap = {};
    if (recordPath.isNotEmpty) {
      File recordFile = File(recordPath);
      var recordRef = await storageRef.child("note.acc").putFile(recordFile);
      // pathMap.addAll({"recordPath": await recordRef.ref.getDownloadURL()});
      request.recordPath = await recordRef.ref.getDownloadURL();
    } else {
      // pathMap.addAll({"recordPath": recordPath});
      request.recordPath = recordPath;
    }

    if (imagePath.isNotEmpty) {
      File imageFile = File(imagePath);
      var imageRef = await storageRef.child("image.jpeg").putFile(imageFile);
      pathMap.addAll({
        "imagePath": await imageRef.ref.getDownloadURL(),
      });
      request.imagePath = await imageRef.ref.getDownloadURL();
    } else {
      pathMap.addAll({"imagePath": imagePath});
      request.imagePath = imagePath;
    }
    // print(pathMap);
    if (pathMap.isNotEmpty) await requestRef.update(request.toJson());

    //TODO: send Notifications
    await sendNotificationMethod(
      title: "New Request|طلب جديد",
      text: "Press Here|أضغط هنا",
      // fcmToken: "/topics/admin"
      topic: "/topics/admin"
    );
    emit(RequestRepairLoaded());
  }

  Future<Request> returnRequest(GeoPoint geoPoint) async {
    User user = _firebaseAuth.currentUser;

    var userDoc =
        await _firebaseFirestore.collection("users").doc(user.uid).get();
    // print (userData.data());
    UserData userData = UserData.fromJson(userDoc.data());
    // Map<String, dynamic> map = {
    //   "requesterId": user.uid,
    //   //TODO: Change this when category needed
    //   "category": _category,
    //   "requesterName": userData.fullName,
    //   "requesterAddress": userData.address,    //   "appointmentDate": Timestamp.fromDate(_appointmentDate),
    //   "requestText": requestText,
    //   "appointmentMicrosecondsSinceEpoch":
    //       _appointmentDate.microsecondsSinceEpoch,
    //   "appointmentTimeZoneName": _appointmentDate.timeZoneName,
    //   "location": geoPoint
    // };
    var request = Request(
      location: geoPoint,
      requesterId: user.uid,
      category: _category,
      requesterName: userData.fullName,
      requesterAddress: userData.address,
      requestText: requestText,
      appointmentDate: Timestamp.fromDate(_appointmentDate),
      appointmentMicrosecondsSinceEpoch:
          _appointmentDate.microsecondsSinceEpoch,
      appointmentTimeZoneName: _appointmentDate.timeZoneName,
      recordPath: recordPath,
      imagePath: imagePath,
      status: Request.STATUS_REQUESTED,
      assignedByName: "",
      assignedById: "",
      workerPhoneNumber: "",
      workerName: "",
      workerId: "",
      workerEmail: "",
      fcmTokenForRequester: await FirebaseMessaging.instance.getToken(),
    );
    return request;
    // var submitRef = _firebaseFirestore.collection("requests");
    // var requestRef = await submitRef.add(map);
    // var storageRef =
    // _firebaseStorage.ref().child("requests").child(requestRef.id);
    // Map<String,dynamic> pathMap = {};
    // if (recordPath.isNotEmpty) {
    // File recordFile = File(recordPath);
    // var recordRef = await storageRef.child("note.acc").putFile(recordFile);
    // pathMap.addAll({"recordPath": await recordRef.ref.getDownloadURL()});
    // }
    // else pathMap.addAll({"recordPath": recordPath});

    // if (imagePath.isNotEmpty) {
    //   File imageFile = File(imagePath);
    //   var imageRef = await storageRef.child("image.jpeg").putFile(imageFile);
    //   pathMap.addAll({
    //     "imagePath": await imageRef.ref.getDownloadURL(),
    //   });
    // }
    // else pathMap.addAll({"imagePath": imagePath});
    // print(pathMap);
    // if (pathMap.isNotEmpty) await requestRef.update(pathMap);
    // emit(RequestRepairLoaded());
  }

  @override
  Future<void> close() {
    _player.closeAudioSession();
    _recorder.closeAudioSession();
    return super.close();
  }

  FlutterSoundRecorder get recorder => _recorder;

  FlutterSoundPlayer get player => _player;

  DateTime get appointmentDate => _appointmentDate;

  set appointmentDate(DateTime value) {
    _appointmentDate = value;
  }

  String get category => _category;

  set category(String value) {
    _category = value;
  }
}
