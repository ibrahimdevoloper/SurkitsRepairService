part of 'request_repair_cubit.dart';

@immutable
abstract class RequestRepairState {

  RequestRepairState();
}

class RequestRepairInitial extends RequestRepairState {
  RequestRepairInitial();
}

class RequestRepairDefaultPhoto extends RequestRepairState {
  RequestRepairDefaultPhoto();
}

class RequestRepairPreviewPhoto extends RequestRepairState {
  final String path;
  RequestRepairPreviewPhoto(this.path);
}

class RequestRepairDefaultRecord extends RequestRepairState {
  RequestRepairDefaultRecord();
}

class RequestRepairPlayRecord extends RequestRepairState {
  RequestRepairPlayRecord();
}

class RequestRepairPlayingRecord extends RequestRepairState {
  RequestRepairPlayingRecord();
}
class RequestRepairRecording extends RequestRepairState {
  RequestRepairRecording();
}

class RequestRepairLoading extends RequestRepairState {
  RequestRepairLoading();
}
class RequestRepairLoaded extends RequestRepairState {
  RequestRepairLoaded();
}
class RequestRepairError extends RequestRepairState {
  RequestRepairError();
}
class RequestRepairDateChosen extends RequestRepairState {
  final DateTime date;
  RequestRepairDateChosen(this.date);
}
class RequestRepairAppointmentError extends RequestRepairState {
  RequestRepairAppointmentError();
}
class RequestRepairFormError extends RequestRepairState {
  RequestRepairFormError();
}
class RequestRepairCategorySelected extends RequestRepairState {
  final String category;
  RequestRepairCategorySelected(this.category);
}
