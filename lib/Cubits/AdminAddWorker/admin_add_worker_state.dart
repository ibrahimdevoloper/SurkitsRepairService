part of 'admin_add_worker_cubit.dart';

@immutable
abstract class AdminAddWorkerState {
  AdminAddWorkerState();
}

class AdminAddWorkerInitial extends AdminAddWorkerState {
  AdminAddWorkerInitial();
}

class AdminAddWorkerLoading extends AdminAddWorkerState {
  AdminAddWorkerLoading();
}

class AdminAddWorkerError extends AdminAddWorkerState {
  final String messageEn;
  final String messageAr;

  AdminAddWorkerError(this.messageEn, this.messageAr);
}

class AdminAddWorkerLoaded extends AdminAddWorkerState {
  AdminAddWorkerLoaded();
}

class AdminAddWorkerEmailError extends AdminAddWorkerState {
  AdminAddWorkerEmailError();
}

class AdminAddWorkerEmailReset extends AdminAddWorkerState {
  AdminAddWorkerEmailReset();
}

class AdminAddWorkerPasswordReset extends AdminAddWorkerState {
  AdminAddWorkerPasswordReset();
}

class AdminAddWorkerPasswordError extends AdminAddWorkerState {
  AdminAddWorkerPasswordError();
}

class AdminAddWorkerConfirmPasswordReset extends AdminAddWorkerState {
  AdminAddWorkerConfirmPasswordReset();
}

class AdminAddWorkerConfirmPasswordError extends AdminAddWorkerState {
  AdminAddWorkerConfirmPasswordError();
}

class AdminAddWorkerFullNameReset extends AdminAddWorkerState {
  AdminAddWorkerFullNameReset();
}

class AdminAddWorkerFullNameError extends AdminAddWorkerState {
  AdminAddWorkerFullNameError();
}

class AdminAddWorkerAddressReset extends AdminAddWorkerState {
  AdminAddWorkerAddressReset();
}

class AdminAddWorkerAddressError extends AdminAddWorkerState {
  AdminAddWorkerAddressError();
}

class AdminAddWorkerPhoneNumberReset extends AdminAddWorkerState {
  AdminAddWorkerPhoneNumberReset();
}

class AdminAddWorkerPhoneNumberError extends AdminAddWorkerState {
  AdminAddWorkerPhoneNumberError();
}

class AdminAddWorkerCategorySelected extends AdminAddWorkerState {
  final String category;

  AdminAddWorkerCategorySelected(this.category);
}

class AdminAddWorkerStartWorkHourSelected extends AdminAddWorkerState {
  final DateTime hour;

  AdminAddWorkerStartWorkHourSelected(this.hour);
}

class AdminAddWorkerStartWorkHourError extends AdminAddWorkerState {
  AdminAddWorkerStartWorkHourError();
}

class AdminAddWorkerEndWorkHourSelected extends AdminAddWorkerState {
  final DateTime hour;

  AdminAddWorkerEndWorkHourSelected(this.hour);
}

class AdminAddWorkerEndWorkHourError extends AdminAddWorkerState {
  AdminAddWorkerEndWorkHourError();
}
