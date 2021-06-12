import 'package:an_app/models/user_data.dart';
import 'package:an_app/providers/SharedPreferences.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'intro_with_sign_in_state.dart';

class IntroWithSignInCubit extends Cubit<IntroWithSignInState> {
  FirebaseAuth _firebaseAuth;

  // FirebaseFirestore _firebaseFirestore;
  String _email = "";
  String _password = "";

  IntroWithSignInCubit() : super(IntroWithSignInInitial()) {
    _firebaseAuth = FirebaseAuth.instance;
    // _firebaseFirestore = FirebaseFirestore.instance;
  }

  // userStream() {
  //   _firebaseAuth.authStateChanges().listen((user) {
  //     if (user != null)
  //       emit(IntroWithSignInSignedIn());
  //     else
  //       emit(IntroWithSignInSignedOut());
  //   });
  // }

  Future<String> SignIn(SharedPreferences pref) async {
    emit(IntroWithSignInLoading());
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: _email, password: _password);
      // print("email: $_email, password: $_password");
      User user = await _firebaseAuth.currentUser;

      var userDataMap = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      var userData = UserData.fromJson(userDataMap.data());
      pref.setString(UserData.ROLE, userData.role);
      pref.setString(UserData.UID, userData.uid);
      pref.setString(UserData.FULL_NAME, userData.fullName);
    } on FirebaseAuthException catch (e) {
      // print(e.toString().contains("There is no user record corresponding to this identifier"));
      print(e);
      if (e.toString().contains(
          "There is no user record corresponding to this identifier")) {
        emit(IntroWithSignInError(
            "Account isn't Available", "الحساب غير موجود"));
      } else if (e
          .toString()
          .contains("Password should be at least 6 characters")) {
        emit(IntroWithSignInError("Password should be at least 6 characters.",
            "تتكون كلمة السر من ستة أحرف على الأقل"));
      } else if (e.toString().contains(
          "The email address is already in use by another account.")) {
        emit(IntroWithSignInError("The email address is already EXISTS.",
            "هذا الإيميل مستخدم سابقاً"));
      } else if (e.toString().contains(
          "The password is invalid or the user does not have a password.")) {
        emit(IntroWithSignInError("Incorrect Password", "كلمة سر غير صحيحة"));
      } else if (e.toString().contains(
          "We have blocked all requests from this device due to unusual activity. Try again later.")) {
        emit(IntroWithSignInError("Try Again Later", "جرب التسجيل لاحقاً"));
      } else
        emit(IntroWithSignInError('error', 'خطأ'));
    }
  }

  bool validator() {
    if (_email.isEmpty || !EmailValidator.validate(_email)) {
      emit(IntroWithSignInEmailError());
    }
    if (_password.isEmpty) {
      emit(IntroWithSignInPasswordError());
    }
    return !(_email.isEmpty ||
        _password.isEmpty ||
        !EmailValidator.validate(_email));
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

// Future<String> Signup({String email, String password}) async {
//   try {
//     await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
//
//   }
//   on FirebaseAuthException catch (e) {
//     //TODO: State error
//   }
// }

}
