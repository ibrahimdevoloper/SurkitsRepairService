part of 'reset_password_request_cubit.dart';

@immutable
abstract class ResetPasswordRequestState {
  ResetPasswordRequestState();
}

class ResetPasswordRequestInitial extends ResetPasswordRequestState {
  ResetPasswordRequestInitial();
}
class ResetPasswordRequestLoading extends ResetPasswordRequestState {
  ResetPasswordRequestLoading();
}
class ResetPasswordRequestSent extends ResetPasswordRequestState {
  ResetPasswordRequestSent();
}
class ResetPasswordRequestError extends ResetPasswordRequestState {
  ResetPasswordRequestError();
}
class ResetPasswordRequestEmailError extends ResetPasswordRequestState {
  ResetPasswordRequestEmailError();
}
class ResetPasswordRequestEmailReset extends ResetPasswordRequestState {
  ResetPasswordRequestEmailReset();
}
