import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'reset_password_request_state.dart';

class ResetPasswordRequestCubit extends Cubit<ResetPasswordRequestState> {
  String _email;

  ResetPasswordRequestCubit() : super(ResetPasswordRequestInitial());

  bool validator() {
    if (EmailValidator.validate(_email))
      emit(ResetPasswordRequestEmailError());
    else
      emit(ResetPasswordRequestEmailReset());
    return EmailValidator.validate(_email);
  }

  sendRequest() async {
    emit(ResetPasswordRequestLoading());
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
      emit(ResetPasswordRequestSent());
    } catch (e) {
      print(e);
      emit(ResetPasswordRequestError());
    }
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }
}
