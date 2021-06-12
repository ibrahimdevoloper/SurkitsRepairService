import 'package:an_app/models/request.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:meta/meta.dart';
import 'package:table_calendar/table_calendar.dart';

part 'admin_worker_assignments_calender_state.dart';

class AdminWorkerAssignmentsCalenderCubit
    extends Cubit<AdminWorkerAssignmentsCalenderState> {
  AdminWorkerAssignmentsCalenderCubit(this._workerId)
      : super(AdminWorkerAssignmentsCalenderInitial()){
    _player = FlutterSoundPlayer();
    _player.openAudioSession();
  }

  @override
  Future<Function> close() {
    _player.closeAudioSession();
    _player = null;
  }

  final String _workerId;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  int _selectedPlayerId=-1;

  static const String IS_LOADING = "isLoading";
  static const String REQUESTS = "requests";

  FlutterSoundPlayer _player;

  Map<DateTime, Map<String, dynamic>> requests = {};

  List<Request> getEventList(DateTime date) {
    if (requests[date] == null) {
      getAssignments(date);
      return [];
    } else {
      if (!requests[date][IS_LOADING])
        return requests[date][REQUESTS];
      else
        return [];
    }
  }

  getAssignments(DateTime date) async {
    //TODO: handle Error
    if (requests[date] == null) {
      requests.addAll({
        date: {IS_LOADING: true, REQUESTS: []}
      });
      if (isSameDay(_selectedDay, date)) {
        emit(AdminWorkerAssignmentsCalenderLoading());
      }
      if (date.month == focusedDay.month) {
        var requestsMap = await FirebaseFirestore.instance
            .collection('requests')
            .where(
              Request.APPOINTMENT_DATE,
              isGreaterThan: Timestamp.fromDate(
                DateTime(date.year, date.month, date.day),
              ),
            )
            .where(
              Request.APPOINTMENT_DATE,
              isLessThan: Timestamp.fromDate(
                DateTime(date.year, date.month, date.day + 1),
              ),
            )
            .where(Request.WORKER_ID, isEqualTo: _workerId)
            .get();
        List<Request> requestsList = [];
        requestsMap.docs.forEach((element) {
          requestsList.add(
            Request.fromJson(
              element.data(),
            ),
          );
        });
        requests[date][IS_LOADING] = false;
        requests[date][REQUESTS] = requestsList;
        emit(AdminWorkerAssignmentsCalenderFocusedDayChanged());
        if (isSameDay(_selectedDay, date)) {
          emit(AdminWorkerAssignmentsCalenderLoaded(requestsList));
        }
      } else {
        requests[date] = null;
      }
    }
  }

  DateTime get focusedDay => _focusedDay;

  set focusedDay(DateTime value) {
    _focusedDay = value;
  }

  DateTime get selectedDay => _selectedDay;

  set selectedDay(DateTime value) {
    _selectedDay = value;
  }

  int get selectedPlayerId => _selectedPlayerId;

  set selectedPlayerId(int value) {
    _selectedPlayerId = value;
  }

  String get workerId => _workerId;

  FlutterSoundPlayer get player => _player;

// set workerId(String value) {
  //   _workerId = value;
  // }

}
