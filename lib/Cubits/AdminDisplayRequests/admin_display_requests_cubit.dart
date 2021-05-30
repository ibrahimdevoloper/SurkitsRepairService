import 'package:an_app/models/request.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:meta/meta.dart';

part 'admin_display_requests_state.dart';

class AdminDisplayRequestsCubit extends Cubit<AdminDisplayRequestsState> {
  List<Request> _requests = [];
  FlutterSoundPlayer _player;
  int _playerIndex=-1;

  bool _isDescending=true;
  String _selectedCategory = "";

  AdminDisplayRequestsCubit() : super(AdminDisplayRequestsInitial()) {
    _player = FlutterSoundPlayer();
    _player.openAudioSession();
    getRequests();
  }

  getRequests() async {
    emit(AdminDisplayRequestsLoading());
    try {
    // var query = FirebaseFirestore.instance
    //     .collection('requests')
    //     .orderBy(
    //       Request.Appointment_Date,
    //   descending: _isDescending
    //     ).where(Request.Category, isEqualTo: _selectedCategory,);
    if(_selectedCategory.isNotEmpty)
      {
        var query = FirebaseFirestore.instance
            .collection('requests')
            .orderBy(
            Request.APPOINTMENT_DATE,
            descending: _isDescending
        ).where(Request.CATEGORY, isEqualTo: _selectedCategory,);
        var mapList =await query.get();

        _requests= [];
        mapList.docs
          ..forEach((element) {
            // print(element.data());
            _requests.add(Request.fromJson(element.data(), element.id));
          });
        emit(AdminDisplayRequestsLoaded(_requests));
      }
    else{
      var query = FirebaseFirestore.instance
          .collection('requests')
          .orderBy(
          Request.APPOINTMENT_DATE,
          descending: _isDescending
      );
      var mapList =await query.get();

      _requests= [];
      mapList.docs
        ..forEach((element) {
          // print(element.data());
          _requests.add(Request.fromJson(element.data(), element.id));
        });
      emit(AdminDisplayRequestsLoaded(_requests));
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
      emit(AdminDisplayRequestsError());
    }
  }

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
}
