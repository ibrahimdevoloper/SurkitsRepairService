part of 'admin_assign_request_cubit.dart';

@immutable
abstract class AdminAssignRequestState {
  AdminAssignRequestState();
}

class AdminAssignRequestInitial
    extends AdminAssignRequestState {
  AdminAssignRequestInitial();
}

class AdminAssignRequestLoading
    extends AdminAssignRequestState {
  AdminAssignRequestLoading();
}

class AdminAssignRequestLoaded
    extends AdminAssignRequestState {
  final List<UserData> usersData;
  AdminAssignRequestLoaded(this.usersData);
}

class AdminAssignRequestError
    extends AdminAssignRequestState {
  AdminAssignRequestError();
}

class AdminAssignRequestFilterStateChanged
    extends AdminAssignRequestState {
  AdminAssignRequestFilterStateChanged();
}
