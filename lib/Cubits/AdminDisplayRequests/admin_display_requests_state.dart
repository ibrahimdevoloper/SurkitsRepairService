part of 'admin_display_requests_cubit.dart';

@immutable
abstract class AdminDisplayRequestsState {
  AdminDisplayRequestsState();
}
class AdminDisplayRequestsInitial extends AdminDisplayRequestsState {
  AdminDisplayRequestsInitial();
}
class AdminDisplayRequestsLoading extends AdminDisplayRequestsState {
  AdminDisplayRequestsLoading();
}
class AdminDisplayRequestsLoaded extends AdminDisplayRequestsState {
  final List<Request> requests;
  AdminDisplayRequestsLoaded(this.requests);
}
class AdminDisplayRequestsPlayRecordButtonStateChange extends AdminDisplayRequestsState {
  AdminDisplayRequestsPlayRecordButtonStateChange();
}
class AdminDisplayRequestsOrderBy extends AdminDisplayRequestsState {
  final String isDescending;
  AdminDisplayRequestsOrderBy(this.isDescending);
}
class AdminDisplayRequestsError extends AdminDisplayRequestsState {
  AdminDisplayRequestsError();
}
class AdminDisplayRequestsFilterStateChanged extends AdminDisplayRequestsState {
  AdminDisplayRequestsFilterStateChanged();
}