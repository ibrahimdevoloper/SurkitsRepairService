import 'dart:io';

import 'package:an_app/models/request.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../models/user_data.dart';

part 'admin_select_worker_for_adisplayed_request_state.dart';

class AdminSelectWorkerForAdisplayedRequestCubit
    extends Cubit<AdminSelectWorkerForAdisplayedRequestState> {
  AdminSelectWorkerForAdisplayedRequestCubit()
      : super(AdminSelectWorkerForAdisplayedRequestInitial()) {
    // print("AdminSelectWorkerForAdisplayedRequestCubit");
    getWorkers();
  }

  List<UserData> _usersData = [];
  var _selectedCategory = "sd";

  getWorkers() async {
    emit(AdminSelectWorkerForAdisplayedRequestLoading());

    try {
      // var query = FirebaseFirestore.instance
      //     .collection('requests')
      //     .orderBy(
      //       Request.Appointment_Date,
      //   descending: _isDescending
      //     ).where(Request.Category, isEqualTo: _selectedCategory,);
      var query = FirebaseFirestore.instance
          .collection('users')
          .where("role", isEqualTo: "worker");
      var mapList = await FirebaseFirestore.instance
          .collection('users')
          .where("role", isEqualTo: "worker")
          .get();

      _usersData = [];
      mapList.docs
        ..forEach((element) {
          print(element.data());
          _usersData.add(UserData.fromJson(element.data()));
        });
      emit(AdminSelectWorkerForAdisplayedRequestLoaded(_usersData));

      if (_selectedCategory.isNotEmpty) {
      } else {
        // var query = FirebaseFirestore.instance
        //     .collection('requests')
        //     .orderBy(
        //     Request.Appointment_Date,
        //     descending: _isDescending
        // );
        // var mapList =await query.get();
        //
        // _requests= [];
        // mapList.docs
        //   ..forEach((element) {
        //     // print(element.data());
        //     _requests.add(Request.fromJson(element.data(), element.id));
        //   });
        // emit(AdminDisplayRequestsLoaded(_requests));
      }
      // var mapList =await query.get();
      //
      //   _requests= [];
      //   mapList.docs
      //     ..forEach((element) {
      //       // print(element.data());
      //       _requests.add(Request.fromJson(element.data(), element.id));
      //     });
    } catch (e) {
      //TODO: handle errors
      print("error: $e");
      emit(AdminSelectWorkerForAdisplayedRequestError());
    }
  }

  assignRequest(String id, UserData user) async {
    emit(AdminSelectWorkerForAdisplayedRequestLoading());

    try {
      Map<String, dynamic> map = {
        Request.WORKER_ID: user.uid,
        Request.WORKER_NAME: user.fullName,
        Request.WORKER_EMAIL: user.email,
        Request.WORKER_PHONE_NUMBER: user.phoneNumber,
      };
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(id)
          .update(map);

      emit(AdminSelectWorkerForAdisplayedRequestLoaded(_usersData));
    } catch (e) {
      //TODO: handle errors
      print("error: $e");
      emit(AdminSelectWorkerForAdisplayedRequestError());
    }
  }

  addRequest(Request request, UserData worker) async {
    emit(AdminSelectWorkerForAdisplayedRequestLoading());

    try {
      request.workerId = worker.uid;
      request.workerName = worker.fullName;
      request.workerEmail = worker.email;
      request.workerPhoneNumber = worker.phoneNumber;

      var doc = await FirebaseFirestore.instance
          .collection('request')
          .add(request.toJson());

      var submitRef = await FirebaseFirestore.instance.collection("requests");
      // var requestRef = await submitRef.add(map);

      var storageRef =
          FirebaseStorage.instance.ref().child("requests").child(doc.id);
      Map<String, dynamic> pathMap = {};
      if (request.recordPath.isNotEmpty) {
        File recordFile = File(request.recordPath);
        var recordRef = await storageRef.child("note.acc").putFile(recordFile);
        pathMap.addAll({Request.RECORD_PATH: await recordRef.ref.getDownloadURL()});
      } else
        pathMap.addAll({"recordPath": ""});

      if (request.imagePath.isNotEmpty) {
        File imageFile = File(request.imagePath);
        var imageRef = await storageRef.child("image.jpeg").putFile(imageFile);
        pathMap.addAll({
          Request.IMAGE_PATH: await imageRef.ref.getDownloadURL(),
        });
      } else
        pathMap.addAll({"imagePath": ""});

      submitRef.doc(doc.id).update(pathMap);

      emit(AdminSelectWorkerForAdisplayedRequestLoaded(_usersData));
    } catch (e) {
      //TODO: handle errors
      print("error: $e");
      emit(AdminSelectWorkerForAdisplayedRequestError());
    }
  }

  get selectedCategory => _selectedCategory;

  set selectedCategory(value) {
    _selectedCategory = value;
  }

  List<UserData> get usersData => _usersData;

  set usersData(List<UserData> value) {
    _usersData = value;
  }
}
