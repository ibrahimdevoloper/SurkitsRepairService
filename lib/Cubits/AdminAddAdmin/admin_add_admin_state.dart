part of 'admin_add_admin_cubit.dart';

@immutable
abstract class AdminAddAdminState {
  AdminAddAdminState();
}

class AdminAddAdminInitial extends AdminAddAdminState {
  AdminAddAdminInitial();
}

class AdminAddAdminLoading extends AdminAddAdminState {
  AdminAddAdminLoading();
}

class AdminAddAdminError extends AdminAddAdminState {
  final String messageEn;
  final String messageAr;

  AdminAddAdminError(this.messageEn, this.messageAr);
}

class AdminAddAdminLoaded extends AdminAddAdminState {
  AdminAddAdminLoaded();
}

class AdminAddAdminEmailError extends AdminAddAdminState {
  AdminAddAdminEmailError();
}

class AdminAddAdminEmailReset extends AdminAddAdminState {
  AdminAddAdminEmailReset();
}

class AdminAddAdminPasswordReset extends AdminAddAdminState {
  AdminAddAdminPasswordReset();
}

class AdminAddAdminPasswordError extends AdminAddAdminState {
  AdminAddAdminPasswordError();
}

class AdminAddAdminConfirmPasswordReset extends AdminAddAdminState {
  AdminAddAdminConfirmPasswordReset();
}

class AdminAddAdminConfirmPasswordError extends AdminAddAdminState {
  AdminAddAdminConfirmPasswordError();
}

class AdminAddAdminFullNameReset extends AdminAddAdminState {
  AdminAddAdminFullNameReset();
}

class AdminAddAdminFullNameError extends AdminAddAdminState {
  AdminAddAdminFullNameError();
}

class AdminAddAdminAddressReset extends AdminAddAdminState {
  AdminAddAdminAddressReset();
}

class AdminAddAdminAddressError extends AdminAddAdminState {
  AdminAddAdminAddressError();
}

class AdminAddAdminPhoneNumberReset extends AdminAddAdminState {
  AdminAddAdminPhoneNumberReset();
}

class AdminAddAdminPhoneNumberError extends AdminAddAdminState {
  AdminAddAdminPhoneNumberError();
}

class AdminAddAdminCategorySelected extends AdminAddAdminState {
  final String category;

  AdminAddAdminCategorySelected(this.category);
}

class AdminAddAdminStartWorkHourSelected extends AdminAddAdminState {
  final DateTime hour;

  AdminAddAdminStartWorkHourSelected(this.hour);
}

class AdminAddAdminStartWorkHourError extends AdminAddAdminState {
  AdminAddAdminStartWorkHourError();
}

class AdminAddAdminEndWorkHourSelected extends AdminAddAdminState {
  final DateTime hour;

  AdminAddAdminEndWorkHourSelected(this.hour);
}

class AdminAddAdminEndWorkHourError extends AdminAddAdminState {
  AdminAddAdminEndWorkHourError();
}
