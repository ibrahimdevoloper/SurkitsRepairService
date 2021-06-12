part of 'admin_worker_assignments_calender_cubit.dart';

@immutable
abstract class AdminWorkerAssignmentsCalenderState {
  AdminWorkerAssignmentsCalenderState();
}

class AdminWorkerAssignmentsCalenderInitial extends AdminWorkerAssignmentsCalenderState {
  AdminWorkerAssignmentsCalenderInitial();
}
class AdminWorkerAssignmentsCalenderFocusedDayChanged extends AdminWorkerAssignmentsCalenderState {
  AdminWorkerAssignmentsCalenderFocusedDayChanged();
}
class AdminWorkerAssignmentsCalenderSelectedDayChanged extends AdminWorkerAssignmentsCalenderState {
  AdminWorkerAssignmentsCalenderSelectedDayChanged();
}
class AdminWorkerAssignmentsCalenderLoading extends AdminWorkerAssignmentsCalenderState {
  AdminWorkerAssignmentsCalenderLoading();
}class AdminWorkerAssignmentsCalenderPlayRecordButtonStateChange extends AdminWorkerAssignmentsCalenderState {
  AdminWorkerAssignmentsCalenderPlayRecordButtonStateChange();
}
class AdminWorkerAssignmentsCalenderLoaded extends AdminWorkerAssignmentsCalenderState {
  final List<Request> requests;
  AdminWorkerAssignmentsCalenderLoaded(this.requests);
}

