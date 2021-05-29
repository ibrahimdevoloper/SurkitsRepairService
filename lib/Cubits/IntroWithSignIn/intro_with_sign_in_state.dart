part of 'intro_with_sign_in_cubit.dart';

@immutable
abstract class IntroWithSignInState {
  IntroWithSignInState();
}

class IntroWithSignInInitial extends IntroWithSignInState {
  IntroWithSignInInitial();
}
class IntroWithSignInLoading extends IntroWithSignInState {
  IntroWithSignInLoading();
}
class IntroWithSignInError extends IntroWithSignInState {
  final String massageAr;
  final String massageEn;
  IntroWithSignInError(this.massageEn, this.massageAr);
}
class IntroWithSignInSignedIn extends IntroWithSignInState {
  IntroWithSignInSignedIn();
}
class IntroWithSignInSignedOut extends IntroWithSignInState {
  IntroWithSignInSignedOut();
}
class IntroWithSignInEmailError extends IntroWithSignInState {
  IntroWithSignInEmailError();
}
class IntroWithSignInEmailReset extends IntroWithSignInState {
  IntroWithSignInEmailReset();
}

class IntroWithSignInPasswordError extends IntroWithSignInState {
  IntroWithSignInPasswordError();
}
class IntroWithSignInPasswordReset extends IntroWithSignInState {
  IntroWithSignInPasswordReset();
}
