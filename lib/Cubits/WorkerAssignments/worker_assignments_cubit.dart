import 'package:an_app/models/request.dart';
import 'package:an_app/models/user_data.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
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

  WorkerAssignmentsCubit(this.pref) : super(WorkerAssignmentsInitial()) {
    _player = FlutterSoundPlayer();
    _player.openAudioSession();
    getRequests();
  }

  @override
  Future<Function> close() {
    _player.closeAudioSession();
    _player = null;
  }

  assignRequest(String requestId) async {
    //TODO: check if available
    emit(WorkerAssignmentsLoading());
    var query =
        FirebaseFirestore.instance.collection('requests').doc(requestId);
    var map = await query.get();
    var request = Request.fromJson(map);
    request.status = Request.STATUS_COMPLETED;
    // request.assignedById=pref.get(UserData.UID);
    // request.assignedByName=pref.get(UserData.FULL_NAME);
    // request.workerName=_worker.fullName;
    // request.workerId = _worker.uid;
    // request.workerPhoneNumber=_worker.phoneNumber;
    // request.workerEmail = _worker.email;
    query.update(request.toJson());
    getRequests();
  }

  getRequests() async {
    emit(WorkerAssignmentsLoading());
    try {
      // var query = FirebaseFirestore.instance
      //     .collection('requests')
      //     .orderBy(
      //       Request.Appointment_Date,
      //   descending: _isDescending
      //     ).where(Request.Category, isEqualTo: _selectedCategory,);

      var query = FirebaseFirestore.instance
          .collection('requests')
          .orderBy(Request.APPOINTMENT_DATE, descending: _isDescending)
          .where(Request.WORKER_ID, isEqualTo: pref.get(UserData.UID));
      var mapList = await query.get();

      _requests = [];
      mapList.docs
        ..forEach((element) {
          // print(element.data());
          _requests.add(Request.fromJson(element.data(), element.id));
        });
      emit(WorkerAssignmentsLoaded(_requests));
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
      emit(WorkerAssignmentsError());
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

  // String get selectedCategory => _selectedCategory;
  //
  // set selectedCategory(String value) {
  //   _selectedCategory = value;
  // }

  bool get isDescending => _isDescending;

  set isDescending(bool value) {
    _isDescending = value;
  }
}
