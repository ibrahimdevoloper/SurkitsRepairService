import 'dart:io';

import 'package:an_app/Functions/FirebaseCrashlyticsLog.dart';
import 'package:an_app/Functions/sendNotificationMethod.dart';
import 'package:an_app/Services/SendNotificationService/SendNotificationService.dart';
import 'package:an_app/models/request.dart';
import 'package:an_app/models/user_data.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'admin_assign_request_state.dart';

class AdminAssignRequestCubit extends Cubit<AdminAssignRequestState> {
  QueryDocumentSnapshot<Map<String, dynamic>> _lastDoc;
  PagingController<int, UserData> _pagingController;

  AdminAssignRequestCubit() : super(AdminAssignRequestInitial()) {
    // getWorkers();
    _pagingController = PagingController<int, UserData>(firstPageKey: 0);
    _pagingController.addPageRequestListener((pageKey) {
      getWorkersPage(pageKey);
    });
  }

  var _selectedCategory = "";
  List<UserData> _usersData = [];

  getWorkersPage(int pageNumber) async {
    // // print(pageNumber);
    List<UserData> workers = [];
    var elementNumberPerPage = 10;
    try {
    if (pageNumber == 0) {
      // pagingController.refresh();
      if (_selectedCategory.isNotEmpty) {
        var query = FirebaseFirestore.instance
            .collection('users')
            .where(UserData.ROLE, isEqualTo: UserData.ROLE_WORKER)
            .where(UserData.CATEGORY, isEqualTo: _selectedCategory)
            .limit(elementNumberPerPage);
        var mapList = await query.get();

        // requests= [];
        mapList.docs
          ..forEach((element) {
            workers.add(UserData.fromJson(element.data()));
            // _lastDoc = element;
          });
        _lastDoc = mapList.docs.last;
        // emit(AdminDisplayRequestsLoaded(_requests));
      } else {
        var query = FirebaseFirestore.instance
            .collection('users')
            .where(UserData.ROLE, isEqualTo: UserData.ROLE_WORKER)
            .limit(elementNumberPerPage);
        var mapList = await query.get();

        // requests= [];
        mapList.docs
          ..forEach((element) {
            workers.add(UserData.fromJson(element.data()));
            // _lastDoc = element;
          });
        _lastDoc = mapList.docs.last;
        // emit(AdminDisplayRequestsLoaded(_requests));
      }

      // var usersQuery =
      // await firestore.collection("users").limit(elementNumberPerPage).get();
      // usersQuery.docs.forEach((element) {
      //   print("element:$element");
      //   users.add(User.fromJson(element.data()));
      //   lastDoc = element;
      // });
      // lastDoc = usersQuery.docs.last;
      // return users;

      if (_pagingController.nextPageKey != null) {
        if (workers.length < elementNumberPerPage)
          _pagingController.appendLastPage(workers);
        else
          _pagingController.appendPage(workers, pageNumber + workers.length);
      }
    } else {
      // var usersQuery = await firestore
      //     .collection("users")
      //     .startAfterDocument(lastDoc)
      //     .limit(elementNumberPerPage)
      //     .get();
      // usersQuery.docs.forEach((element) {
      //   print("element:$element");
      //   users.add(User.fromJson(element.data()));
      //   lastDoc = element;
      // });
      // // lastDoc = usersQuery.docs.last;
      // return users;
      if (_selectedCategory.isNotEmpty) {
        var query = FirebaseFirestore.instance
            .collection('users')
            .where(UserData.ROLE, isEqualTo: UserData.ROLE_WORKER)
            .where(UserData.CATEGORY, isEqualTo: _selectedCategory)
            .limit(elementNumberPerPage)
            .startAfterDocument(_lastDoc);
        var mapList = await query.get();

        // requests= [];
        mapList.docs
          ..forEach((element) {
            workers.add(UserData.fromJson(
              element.data(),
            ));
            // _lastDoc = element;
          });
        _lastDoc = mapList.docs.last;
        // emit(AdminDisplayRequestsLoaded(_requests));
      } else {
        var query = FirebaseFirestore.instance
            .collection('users')
            .where(UserData.ROLE, isEqualTo: UserData.ROLE_WORKER)
            .limit(elementNumberPerPage)
            .startAfterDocument(_lastDoc);
        var mapList = await query.get();

        // requests= [];
        mapList.docs
          ..forEach((element) {
            workers.add(UserData.fromJson(element.data()));
            // _lastDoc = element;
          });
        if (mapList.docs.isNotEmpty)
          _lastDoc = mapList.docs.last;
        else
          _lastDoc = null;
        // emit(AdminDisplayRequestsLoaded(_requests));
      }
      if (_pagingController.nextPageKey != null) {
        if (workers.length < elementNumberPerPage)
          _pagingController.appendLastPage(workers);
        else
          _pagingController.appendPage(workers, pageNumber + workers.length);
      }
    }
    } catch (e) {
      _pagingController.error = e;
      // print(e);
      firebaseCrashLog(e, e.stackTrace,
          tag: "AdminAssignRequestCubit.getWorkersPage", message: e.toString());
    }
  }

  // getWorkers() async {
  //   emit(AdminAssignRequestLoading());
  //
  //   try {
  //     if (_selectedCategory.isEmpty) {
  //       var mapList = await FirebaseFirestore.instance
  //           .collection('users')
  //           .where(UserData.ROLE, isEqualTo: UserData.ROLE_WORKER)
  //           .get();
  //
  //       _usersData = [];
  //       mapList.docs
  //         ..forEach((element) {
  //           print(element.data());
  //           _usersData.add(UserData.fromJson(element.data()));
  //         });
  //       emit(AdminAssignRequestLoaded(_usersData));
  //     } else {
  //       var mapList = await FirebaseFirestore.instance
  //           .collection('users')
  //           .where(UserData.ROLE, isEqualTo: UserData.ROLE_WORKER)
  //           .where(UserData.CATEGORY, isEqualTo: _selectedCategory)
  //           .get();
  //
  //       _usersData = [];
  //       mapList.docs
  //         ..forEach((element) {
  //           print(element.data());
  //           _usersData.add(UserData.fromJson(element.data()));
  //         });
  //       emit(AdminAssignRequestLoaded(_usersData));
  //     }
  //   } catch (e) {
  //     print("error: $e");
  //     emit(AdminAssignRequestError());
  //   }
  // }

  assignRequest(String id, UserData user, SharedPreferences pref) async {
    emit(AdminAssignRequestLoading());

    try {
      Map<String, dynamic> map = {
        Request.WORKER_ID: user.uid,
        Request.WORKER_NAME: user.fullName,
        Request.WORKER_EMAIL: user.email,
        Request.WORKER_PHONE_NUMBER: user.phoneNumber,
        Request.FCM_TOKEN_FOR_WORKER: user.fcmToken,
        Request.STATUS: Request.STATUS_ASSIGNED,
        Request.ASSIGNED_BY_NAME: pref.get(UserData.FULL_NAME),
        Request.ASSIGNED_BY_ID: pref.get(UserData.UID),
        Request.FCM_TOKEN_FOR_ADMIN: await FirebaseMessaging.instance.getToken()
      };
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(id)
          .update(map);

      //send to the worker a notification
      await sendNotificationMethod(text: "Press Here|أضغط هنا",title: "New Assignment|طلب جديد",
      usersId:  user.uid,);

      emit(AdminAssignRequestLoaded(_usersData));
    } catch (e) {
      // print("error: $e");
      emit(AdminAssignRequestError());
      firebaseCrashLog(e, e.stackTrace,
          tag: "AdminAssignRequestCubit.assignRequest", message: e.toString());
    }
  }
  //
  // Future sendNotificationMethod({String title, String text, fcmToken}) async {
  //   assert(fcmToken is String || fcmToken is List<String>,
  //       "fcmToken type must be from String or List<String>");
  //   var notificationMap = {
  //     "notification": {
  //       "title": title,
  //       "text": text,
  //     },
  //     "priority": "high",
  //     "to": fcmToken
  //   };
  //   var response =await SendNotificationService.create().sendNotification(notificationMap);
  //   print(response.body);
  // }

  addRequest(Request request, UserData worker, SharedPreferences pref) async {
    emit(AdminAssignRequestLoading());

    try {
      request.workerId = worker.uid;
      request.workerName = worker.fullName;
      request.workerEmail = worker.email;
      request.workerPhoneNumber = worker.phoneNumber;
      request.fcmTokenForWorker = worker.fcmToken;
      request.status = Request.STATUS_ASSIGNED;
      request.assignedByName = pref.get(UserData.FULL_NAME);
      request.assignedById = pref.get(UserData.UID);
      request.fcmTokenForAdmin = await FirebaseMessaging.instance.getToken();

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
      await sendNotificationMethod(text: "Press Here|أضغط هنا",title: "New Assignment|طلب جديد",
          usersId: worker.uid);
      emit(AdminAssignRequestLoaded(_usersData));
    } catch (e) {
      // print("error: $e");
      emit(AdminAssignRequestError());
      firebaseCrashLog(e, e.stackTrace,
          tag: "AdminAssignRequestCubit.addRequest", message: e.toString());
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

  PagingController<int, UserData> get pagingController => _pagingController;
}
