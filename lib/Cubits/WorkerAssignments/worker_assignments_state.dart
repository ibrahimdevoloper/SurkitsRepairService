part of 'worker_assignments_cubit.dart';

@immutable
abstract class WorkerAssignmentsState {
  WorkerAssignmentsState();
}

class WorkerAssignmentsInitial extends WorkerAssignmentsState {
  WorkerAssignmentsInitial();
}

class WorkerAssignmentsLoading extends WorkerAssignmentsState {
  WorkerAssignmentsLoading();
}

class WorkerAssignmentsLoaded extends WorkerAssignmentsState {
  final List<Request> requests;

  WorkerAssignmentsLoaded(this.requests);
}

class WorkerAssignmentsError extends WorkerAssignmentsState {
  WorkerAssignmentsError();
}

class WorkerAssignmentsPlayRecordButtonStateChange
    extends WorkerAssignmentsState {
  WorkerAssignmentsPlayRecordButtonStateChange();
}
