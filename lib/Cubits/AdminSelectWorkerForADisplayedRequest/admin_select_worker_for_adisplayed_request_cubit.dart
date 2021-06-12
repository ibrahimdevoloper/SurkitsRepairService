import 'dart:io';

import 'package:an_app/models/request.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_data.dart';

part 'admin_select_worker_for_adisplayed_request_state.dart';

class AdminSelectWorkerForAdisplayedRequestCubit
    extends Cubit<AdminSelectWorkerForAdisplayedRequestState> {
  AdminSelectWorkerForAdisplayedRequestCubit()
      : super(AdminSelectWorkerForAdisplayedRequestInitial()) {
    // print("AdminSelectWorkerForAdisplayedRequestCubit");
    getWorkers();
  }

  var _selectedCategory = "";
  List<UserData> _usersData = [];

  getWorkers() async {
    emit(AdminSelectWorkerForAdisplayedRequestLoading());

    try {
      if (_selectedCategory.isEmpty) {
        var mapList = await FirebaseFirestore.instance
            .collection('users')
            .where(UserData.ROLE, isEqualTo: UserData.ROLE_WORKER)
            .get();

        _usersData = [];
        mapList.docs
          ..forEach((element) {
            print(element.data());
            _usersData.add(UserData.fromJson(element.data()));
          });
        emit(AdminSelectWorkerForAdisplayedRequestLoaded(_usersData));
      } else {
        var mapList = await FirebaseFirestore.instance
            .collection('users')
            .where(UserData.ROLE, isEqualTo: UserData.ROLE_WORKER)
            .where(UserData.CATEGORY, isEqualTo: _selectedCategory)
            .get();

        _usersData = [];
        mapList.docs
          ..forEach((element) {
            print(element.data());
            _usersData.add(UserData.fromJson(element.data()));
          });
        emit(AdminSelectWorkerForAdisplayedRequestLoaded(_usersData));
      }
    } catch (e) {
      //TODO: handle errors
      print("error: $e");
      emit(AdminSelectWorkerForAdisplayedRequestError());
    }
  }

  assignRequest(String documentId, UserData worker,
      SharedPreferences pref) async {
    emit(AdminSelectWorkerForAdisplayedRequestLoading());

    try {
      Map<String, dynamic> map = {
      Request.WORKER_ID: worker.uid,
      Request.WORKER_NAME: worker.fullName,
      Request.WORKER_EMAIL: worker.email,
      Request.WORKER_PHONE_NUMBER: worker.phoneNumber,
      Request.STATUS:Request.STATUS_ASSIGNED,
      Request.ASSIGNED_BY_NAME : pref.get(UserData.FULL_NAME),
      Request.ASSIGNED_BY_ID: pref.get(UserData.UID),
    };
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(documentId)
        .update(map);

    emit(AdminSelectWorkerForAdisplayedRequestLoaded(_usersData));
  } catch (e) {
    //TODO: handle errors
    print("error: $e");
    emit(AdminSelectWorkerForAdisplayedRequestError());
    }
  }

  addRequest(Request request, UserData worker, SharedPreferences pref) async {
    emit(AdminSelectWorkerForAdisplayedRequestLoading());

    try {
      request.workerId = worker.uid;
      request.workerName = worker.fullName;
      request.workerEmail = worker.email;
      request.workerPhoneNumber = worker.phoneNumber;
      request.status = Request.STATUS_ASSIGNED;
      request.assignedByName = pref.get(UserData.FULL_NAME);
      request.assignedById = pref.get(UserData.UID);


      print(request.recordPath);

      var doc = await FirebaseFirestore.instance
          .collection('requests')
          .add(request.toJson());

      var submitRef = await FirebaseFirestore.instance.collection("requests");
      // var requestRef = await submitRef.add(map);

      var storageRef =
      FirebaseStorage.instance.ref().child("requests").child(doc.id);
      Map<String, dynamic> pathMap = {};
      if (request.recordPath.isNotEmpty) {
        File recordFile = File(request.recordPath);
        var recordRef = await storageRef.child("note.acc").putFile(recordFile);
        pathMap.addAll(
            {Request.RECORD_PATH: await recordRef.ref.getDownloadURL()});
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
