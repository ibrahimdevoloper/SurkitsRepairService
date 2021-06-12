import 'package:an_app/models/request.dart';
import 'package:an_app/models/user_data.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:meta/meta.dart';

part 'customer_requests_state.dart';

class CustomerRequestsCubit extends Cubit<CustomerRequestsState> {
  List<Request> _requests = [];
  FlutterSoundPlayer _player;
  int _playerIndex = -1;

  bool _isDescending = true;
  String _selectedCategory = "";

  final String _customerId;

  CustomerRequestsCubit(this._customerId) : super(CustomerRequestsInitial()) {
    _player = FlutterSoundPlayer();
    _player.openAudioSession();
    getRequests();
  }

  @override
  Future<Function> close() {
    _player.closeAudioSession();
    _player = null;
  }

  getRequests() async {
    emit(CustomerRequestsLoading());
    try {
      print(_customerId);
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
            );
        var mapList = await query.get();

        _requests = [];
        mapList.docs
          ..forEach((element) {
            // print(element.data());
            _requests.add(Request.fromJson(element.data(), element.id));
          });
        emit(CustomerRequestsLoaded(_requests));
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
            );
        var mapList = await query.get();

        _requests = [];
        mapList.docs
          ..forEach((element) {
            // print(element.data());
            _requests.add(Request.fromJson(element.data(), element.id));
          });
        emit(CustomerRequestsLoaded(_requests));
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
      emit(CustomerRequestsError());
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
