import 'package:an_app/models/request.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';

part 'admin_display_requests_state.dart';

class AdminDisplayRequestsCubit extends Cubit<AdminDisplayRequestsState> {
  List<Request> _requests = [];
  FlutterSoundPlayer _player;
  int _playerIndex = -1;

  bool _isDescending = true;
  String _selectedCategory = "";

  final PagingController<int, Request> _pagingController;

  var _lastDoc;

  AdminDisplayRequestsCubit(this._pagingController)
      : super(AdminDisplayRequestsInitial()) {
    _player = FlutterSoundPlayer();
    _player.openAudioSession();
    _pagingController.addPageRequestListener((pageKey) {
      getRequestsPage(pageKey);
    });
    // getRequests();
  }

  @override
  Future<Function> close() {
    _player.closeAudioSession();
    _player = null;
    _pagingController.dispose();
  }

  getRequestsPage(int pageNumber) async {
    // // print(pageNumber);
    List<Request> requests = [];
    var elementNumberPerPage = 10;
    try {
      if (pageNumber == 0) {
        // pagingController.refresh();
        if (_selectedCategory.isNotEmpty) {
          var query = FirebaseFirestore.instance
              .collection('requests')
              .orderBy(Request.APPOINTMENT_DATE, descending: _isDescending)
              .where(
                Request.CATEGORY,
                isEqualTo: _selectedCategory,
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
              .orderBy(Request.APPOINTMENT_DATE, descending: _isDescending)
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
              .orderBy(Request.APPOINTMENT_DATE, descending: _isDescending)
              .where(
                Request.CATEGORY,
                isEqualTo: _selectedCategory,
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
              .orderBy(Request.APPOINTMENT_DATE, descending: _isDescending)
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
      // TODO: handle Errors
      _pagingController.error = e;
    }
  }

  // getRequests() async {
  //   emit(AdminDisplayRequestsLoading());
  //   try {
  //   if(_selectedCategory.isNotEmpty)
  //     {
  //       var query = FirebaseFirestore.instance
  //           .collection('requests')
  //           .orderBy(
  //           Request.APPOINTMENT_DATE,
  //           descending: _isDescending
  //       ).where(Request.CATEGORY, isEqualTo: _selectedCategory,);
  //       var mapList =await query.get();
  //
  //       _requests= [];
  //       mapList.docs
  //         ..forEach((element) {
  //           // print(element.data());
  //           _requests.add(Request.fromJson(element.data(), element.id));
  //         });
  //       emit(AdminDisplayRequestsLoaded(_requests));
  //     }
  //   else{
  //     var query = FirebaseFirestore.instance
  //         .collection('requests')
  //         .orderBy(
  //         Request.APPOINTMENT_DATE,
  //         descending: _isDescending
  //     );
  //     var mapList =await query.get();
  //
  //     _requests= [];
  //     mapList.docs
  //       ..forEach((element) {
  //         // print(element.data());
  //         _requests.add(Request.fromJson(element.data(), element.id));
  //       });
  //     emit(AdminDisplayRequestsLoaded(_requests));
  //   }
  //   } catch (e) {
  //     //TODO: handle errors
  //     print("error: $e");
  //     emit(AdminDisplayRequestsError());
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
