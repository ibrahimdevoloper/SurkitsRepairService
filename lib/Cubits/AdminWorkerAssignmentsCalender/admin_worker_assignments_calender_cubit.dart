import 'package:an_app/models/request.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'admin_worker_assignments_calender_state.dart';

class AdminWorkerAssignmentsCalenderCubit
    extends Cubit<AdminWorkerAssignmentsCalenderState> {
  AdminWorkerAssignmentsCalenderCubit(this._workerId)
      : super(AdminWorkerAssignmentsCalenderInitial());

  final String _workerId;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  static const String IS_LOADING =  "isLoading";
  static const String REQUESTS =  "requests";

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
}
