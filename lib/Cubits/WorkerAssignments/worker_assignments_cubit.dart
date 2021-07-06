import 'package:an_app/Functions/sendNotificationMethod.dart';
import 'package:an_app/models/request.dart';
import 'package:an_app/models/user_data.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'worker_assignments_state.dart';

class WorkerAssignmentsCubit extends Cubit<WorkerAssignmentsState> {
  // WorkerAssignmentsCubit() : super(WorkerAssignmentsInitial());
  List<Request> _requests = [];
  FlutterSoundPlayer _player;
  int _playerIndex = -1;

  bool _isDescending = true;

  final SharedPreferences pref;

  // String _selectedCategory = "";

  // final DateTime _selectedDate;
  // final List<Request> _assignedRequests;
  // final UserData _worker;

  PagingController<int, Request> _pagingController;

  var _lastDoc;

  WorkerAssignmentsCubit(this.pref) : super(WorkerAssignmentsInitial()) {
    _player = FlutterSoundPlayer();
    _player.openAudioSession();
    // getRequests();
    _pagingController = PagingController<int, Request>(firstPageKey: 0);
    _pagingController.addPageRequestListener((pageKey) {
      print("addPageRequestListener :$pageKey");
      getRequestsPage(pageKey);
    });
  }

  @override
  Future<Function> close() {
    _player.closeAudioSession();
    _player = null;
    _pagingController.dispose();
  }

  assignRequest(String requestId) async {
    //TODO: check if available
    emit(WorkerAssignmentsLoading());
    var query =
        FirebaseFirestore.instance.collection('requests').doc(requestId);
    var map = await query.get();
    var request = Request.fromJson(map.data());
    request.status = Request.STATUS_COMPLETED;
    // request.assignedById=pref.get(UserData.UID);
    // request.assignedByName=pref.get(UserData.FULL_NAME);
    // request.workerName=_worker.fullName;
    // request.workerId = _worker.uid;
    // request.workerPhoneNumber=_worker.phoneNumber;
    // request.workerEmail = _worker.email;
    query.update(request.toJson());
    await sendNotificationMethod(
      text: "Press Here|أضغط هنا",
      title:
          "Assignment Done by ${request.workerName}\n${request.workerName} مهمة تم أنهاؤها من قبل ",
      usersId: [request.assignedById, request.workerId],
    );
    emit(WorkerAssignmentsPlayRecordButtonStateChange());
  }

  getRequestsPage(int pageNumber) async {
    print("_pagingController.nextPageKey${_pagingController.nextPageKey}");

    List<Request> requests = [];
    var elementNumberPerPage = 10;
    _lastDoc = null;
    try {
      if (pageNumber == 0) {
        // _pagingController.refresh();

        var query = FirebaseFirestore.instance
            .collection('requests')
            .orderBy(Request.APPOINTMENT_DATE, descending: _isDescending)
            .where(Request.WORKER_ID, isEqualTo: pref.get(UserData.UID))
            .limit(elementNumberPerPage);
        var mapList = await query.get();

        // requests= [];
        mapList.docs
          ..forEach((element) {
            requests.add(Request.fromJson(element.data(), element.id));
            // _lastDoc = element;
          });
        _lastDoc = mapList.docs.last;
        // emit(AdminDisplayRequestsLoaded(_requests));

        // var usersQuery =
        // await firestore.collection("users").limit(elementNumberPerPage).get();
        // usersQuery.docs.forEach((element) {
        //   print("element:$element");
        //   users.add(User.fromJson(element.data()));
        //   lastDoc = element;
        // });
        // lastDoc = usersQuery.docs.last;
        // return users;
        // print(
        //     "getRequestsPage pageNumber == 0 ${requests.length < elementNumberPerPage}");
        if (_pagingController.nextPageKey != null) {
          if (requests.length < elementNumberPerPage)
            _pagingController.appendLastPage(requests);
          else
            _pagingController.appendPage(
                requests, pageNumber + requests.length);
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

        var query = FirebaseFirestore.instance
            .collection('requests')
            .orderBy(Request.APPOINTMENT_DATE, descending: _isDescending)
            .where(Request.WORKER_ID, isEqualTo: pref.get(UserData.UID))
            .limit(elementNumberPerPage)
            .startAfterDocument(_lastDoc);
        var mapList = await query.get();

        // requests= [];
        mapList.docs
          ..forEach((element) {
            requests.add(Request.fromJson(element.data(), element.id));
            // _lastDoc = element;
          });
        if (mapList.docs.isNotEmpty)
          _lastDoc = mapList.docs.last;
        else
          _lastDoc = null;
        // emit(AdminDisplayRequestsLoaded(_requests));
      }
      if (_pagingController.nextPageKey != null) {
        if (requests.length < elementNumberPerPage)
          _pagingController.appendLastPage(requests);
        else
          _pagingController.appendPage(requests, pageNumber + requests.length);
      }
    } catch (e) {
      // TODO: handle Errors
      _pagingController.error = e;
    }
  }

  // getRequests() async {
  //   emit(WorkerAssignmentsLoading());
  //   try {
  //     // var query = FirebaseFirestore.instance
  //     //     .collection('requests')
  //     //     .orderBy(
  //     //       Request.Appointment_Date,
  //     //   descending: _isDescending
  //     //     ).where(Request.Category, isEqualTo: _selectedCategory,);
  //
  //     var query = FirebaseFirestore.instance
  //         .collection('requests')
  //         .orderBy(Request.APPOINTMENT_DATE, descending: _isDescending)
  //         .where(Request.WORKER_ID, isEqualTo: pref.get(UserData.UID));
  //     var mapList = await query.get();
  //
  //     _requests = [];
  //     mapList.docs
  //       ..forEach((element) {
  //         // print(element.data());
  //         _requests.add(Request.fromJson(element.data(), element.id));
  //       });
  //     emit(WorkerAssignmentsLoaded(_requests));
  //     // var mapList =await query.get();
  //     //
  //     //   _requests= [];
  //     //   mapList.docs
  //     //     ..forEach((element) {
  //     //       // print(element.data());
  //     //       _requests.add(Request.fromJson(element.data(), element.id));
  //     //     });
  //   } catch (e) {
  //     //TODO: handle errors
  //     print("error: $e");
  //     emit(WorkerAssignmentsError());
  //   }
  // }

  int get playerIndex => _playerIndex;

  set playerIndex(int value) {
    _playerIndex = value;
  }

  FlutterSoundPlayer get player => _player;

  set player(FlutterSoundPlayer value) {
    _player = value;
  }

  List<Request> get requests => _requests;

  set requests(List<Request> value) {
    _requests = value;
  }

  // String get selectedCategory => _selectedCategory;
  //
  // set selectedCategory(String value) {
  //   _selectedCategory = value;
  // }

  bool get isDescending => _isDescending;

  set isDescending(bool value) {
    _isDescending = value;
  }

  PagingController<int, Request> get pagingController => _pagingController;
}
