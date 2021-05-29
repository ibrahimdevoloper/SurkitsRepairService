part of 'sign_up_cubit.dart';

@immutable
abstract class SignUpState {
  SignUpState();
}

class SignUpInitial extends SignUpState {
  SignUpInitial();
}

class SignUpLoading extends SignUpState {
  SignUpLoading();
}

class SignUpError extends SignUpState {
  final String messageEn;
  final String messageAr;

  SignUpError(this.messageEn, this.messageAr);
}

class SignUpSignedIn extends SignUpState {
  SignUpSignedIn();
}

class SignUpSignedOut extends SignUpState {
  SignUpSignedOut();
}

class SignUpEmailError extends SignUpState {
  SignUpEmailError();
}

class SignUpEmailReset extends SignUpState {
  SignUpEmailReset();
}

class SignUpPasswordReset extends SignUpState {
  SignUpPasswordReset();
}

class SignUpPasswordError extends SignUpState {
  SignUpPasswordError();
}

class SignUpConfirmPasswordReset extends SignUpState {
  SignUpConfirmPasswordReset();
}

class SignUpConfirmPasswordError extends SignUpState {
  SignUpConfirmPasswordError();
}

class SignUpFullNameReset extends SignUpState {
  SignUpFullNameReset();
}

class SignUpFullNameError extends SignUpState {
  SignUpFullNameError();
}

class SignUpAddressReset extends SignUpState {
  SignUpAddressReset();
}

class SignUpAddressError extends SignUpState {
  SignUpAddressError();
}

class SignUpPhoneNumberReset extends SignUpState {
  SignUpPhoneNumberReset();
}

class SignUpPhoneNumberError extends SignUpState {
  SignUpPhoneNumberError();
}
