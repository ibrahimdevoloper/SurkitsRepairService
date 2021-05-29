part of 'admin_select_worker_for_adisplayed_request_cubit.dart';

@immutable
abstract class AdminSelectWorkerForAdisplayedRequestState {
  AdminSelectWorkerForAdisplayedRequestState();
}

class AdminSelectWorkerForAdisplayedRequestInitial
    extends AdminSelectWorkerForAdisplayedRequestState {
  AdminSelectWorkerForAdisplayedRequestInitial();
}

class AdminSelectWorkerForAdisplayedRequestLoading
    extends AdminSelectWorkerForAdisplayedRequestState {
  AdminSelectWorkerForAdisplayedRequestLoading();
}

class AdminSelectWorkerForAdisplayedRequestLoaded
    extends AdminSelectWorkerForAdisplayedRequestState {
  AdminSelectWorkerForAdisplayedRequestLoaded();
}

class AdminSelectWorkerForAdisplayedRequestError
    extends AdminSelectWorkerForAdisplayedRequestState {
  AdminSelectWorkerForAdisplayedRequestError();
}

class AdminSelectWorkerForAdisplayedRequestFilterStateChanged
    extends AdminSelectWorkerForAdisplayedRequestState {
  AdminSelectWorkerForAdisplayedRequestFilterStateChanged();
}
