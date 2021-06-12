part of 'customer_requests_cubit.dart';

@immutable
abstract class CustomerRequestsState {
  CustomerRequestsState();
}

class CustomerRequestsInitial extends CustomerRequestsState {
  CustomerRequestsInitial();
}

class CustomerRequestsLoading extends CustomerRequestsState {
  CustomerRequestsLoading();
}

class CustomerRequestsFilterStateChanged extends CustomerRequestsState {
  CustomerRequestsFilterStateChanged();
}

class CustomerRequestsLoaded extends CustomerRequestsState {
  final List<Request> requests;
  CustomerRequestsLoaded(this.requests);
}

class CustomerRequestsError extends CustomerRequestsState {
  CustomerRequestsError();
}

class CustomerRequestsPlayRecordButtonStateChange extends CustomerRequestsState {
  CustomerRequestsPlayRecordButtonStateChange();
}

// class CustomerRequestsInitial extends CustomerRequestsState {
//   CustomerRequestsInitial();
// }
