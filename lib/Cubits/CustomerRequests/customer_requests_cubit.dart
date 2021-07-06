import 'package:an_app/Functions/FirebaseCrashlyticsLog.dart';
import 'package:an_app/models/request.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';

part 'customer_requests_state.dart';

class CustomerRequestsCubit extends Cubit<CustomerRequestsState> {
  // List<Request> _requests = [];
  FlutterSoundPlayer _player;
  int _playerIndex = -1;

  bool _isDescending = true;
  String _selectedCategory = "";

  final String _customerId;

  PagingController<int, Request> _pagingController;

  var _lastDoc;

  CustomerRequestsCubit(this._customerId) : super(CustomerRequestsInitial()) {
    _player = FlutterSoundPlayer();
    _player.openAudioSession();
    // getRequests()
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

  getRequestsPage(int pageNumber) async {
    print("_pagingController.nextPageKey${_pagingController.nextPageKey}");

    List<Request> requests = [];
    var elementNumberPerPage = 10;
    _lastDoc = null;
    try {
      if (pageNumber == 0) {
        // _pagingController.refresh();
        if (_selectedCategory.isNotEmpty) {
          var query = FirebaseFirestore.instance
              .collection('requests')
              .orderBy(
                Request.APPOINTMENT_DATE,
                descending: _isDescending,
              )
              .where(
                Request.CATEGORY,
                isEqualTo: _selectedCategory,
              )
              .where(
                Request.REQUESTER_ID,
                isEqualTo: _customerId,
              )
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
        } else {
          var query = FirebaseFirestore.instance
              .collection('requests')
              .orderBy(
                Request.APPOINTMENT_DATE,
                descending: _isDescending,
              )
              .where(
                Request.REQUESTER_ID,
                isEqualTo: _customerId,
              )
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
        if (_selectedCategory.isNotEmpty) {
          var query = FirebaseFirestore.instance
              .collection('requests')
              .orderBy(
                Request.APPOINTMENT_DATE,
                descending: _isDescending,
              )
              .where(
                Request.CATEGORY,
                isEqualTo: _selectedCategory,
              )
              .where(
                Request.REQUESTER_ID,
                isEqualTo: _customerId,
              )
              .limit(elementNumberPerPage)
              .startAfterDocument(_lastDoc);
          var mapList = await query.get();

          // requests= [];
          mapList.docs
            ..forEach((element) {
              requests.add(Request.fromJson(element.data(), element.id));
              // _lastDoc = element;
            });
          _lastDoc = mapList.docs.last;
          // emit(AdminDisplayRequestsLoaded(_requests));
        } else {
          var query = FirebaseFirestore.instance
              .collection('requests')
              .orderBy(
                Request.APPOINTMENT_DATE,
                descending: _isDescending,
              )
              .where(
                Request.REQUESTER_ID,
                isEqualTo: _customerId,
              )
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
            _pagingController.appendPage(
                requests, pageNumber + requests.length);
        }
      }
    } catch (e) {
      _pagingController.error = e;
      firebaseCrashLog(e, e.stackTrace,
          tag: "CustomerRequestsCubit.getRequestsPage", message: e.toString());
    }
  }

  // getRequests() async {
  //   emit(CustomerRequestsLoading());
  //   try {
  //     print(_customerId);
  //     if (_selectedCategory.isNotEmpty) {
  //       var query = FirebaseFirestore.instance
  //           .collection('requests')
  //           .orderBy(
  //             Request.APPOINTMENT_DATE,
  //             descending: _isDescending,
  //           )
  //           .where(
  //             Request.CATEGORY,
  //             isEqualTo: _selectedCategory,
  //           )
  //           .where(
  //             Request.REQUESTER_ID,
  //             isEqualTo: _customerId,
  //           );
  //       var mapList = await query.get();
  //
  //       _requests = [];
  //       mapList.docs
  //         ..forEach((element) {
  //           // print(element.data());
  //           _requests.add(Request.fromJson(element.data(), element.id));
  //         });
  //       emit(CustomerRequestsLoaded(_requests));
  //     } else {
  //       var query = FirebaseFirestore.instance
  //           .collection('requests')
  //           .orderBy(
  //             Request.APPOINTMENT_DATE,
  //             descending: _isDescending,
  //           )
  //           .where(
  //             Request.REQUESTER_ID,
  //             isEqualTo: _customerId,
  //           );
  //       var mapList = await query.get();
  //
  //       _requests = [];
  //       mapList.docs
  //         ..forEach((element) {
  //           // print(element.data());
  //           _requests.add(Request.fromJson(element.data(), element.id));
  //         });
  //       emit(CustomerRequestsLoaded(_requests));
  //     }
  //     // var mapList =await query.get();
  //     //
  //     //   _requests= [];
  //     //   mapList.docs
  //     //     ..forEach((element) {
  //     //       // print(element.data());
  //     //       _requests.add(Request.fromJson(element.data(), element.id));
  //     //     });
  //   } catch (e) {
  //     print("error: $e");
  //     emit(CustomerRequestsError());
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

  // List<Request> get requests => _requests;
  //
  // set requests(List<Request> value) {
  //   _requests = value;
  // }

  String get selectedCategory => _selectedCategory;

  set selectedCategory(String value) {
    _selectedCategory = value;
  }

  bool get isDescending => _isDescending;

  set isDescending(bool value) {
    _isDescending = value;
  }

  PagingController<int, Request> get pagingController => _pagingController;
}
