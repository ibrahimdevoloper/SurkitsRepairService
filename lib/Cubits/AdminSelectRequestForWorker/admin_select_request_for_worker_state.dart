part of 'admin_select_request_for_worker_cubit.dart';

@immutable
abstract class AdminSelectRequestForWorkerState {

  AdminSelectRequestForWorkerState();
}

class AdminSelectRequestForWorkerInitial extends AdminSelectRequestForWorkerState {
  AdminSelectRequestForWorkerInitial();
}
class AdminSelectRequestForWorkerLoading extends AdminSelectRequestForWorkerState {
  AdminSelectRequestForWorkerLoading();
}
class AdminSelectRequestForWorkerLoaded extends AdminSelectRequestForWorkerState {
  final List<Request> requests;
  AdminSelectRequestForWorkerLoaded(this.requests);
}
class AdminSelectRequestForWorkerError extends AdminSelectRequestForWorkerState {
  AdminSelectRequestForWorkerError();
}
class AdminSelectRequestForWorkerPlayRecordButtonStateChange extends AdminSelectRequestForWorkerState {
  AdminSelectRequestForWorkerPlayRecordButtonStateChange();
}
