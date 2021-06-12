import 'dart:convert';

import 'package:an_app/models/user_data.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  FirebaseAuth _firebaseAuth;
  FirebaseFirestore _firebaseFirestore;
  String _fullName = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";
  String _phoneNumber = "";
  String _address = "";

  SignUpCubit() : super(SignUpInitial()) {
    _firebaseAuth = FirebaseAuth.instance;
    _firebaseFirestore = FirebaseFirestore.instance;
  }

  //TODO: Set up Validator

  Future<String> SignUp(SharedPreferences pref) async {
    emit(SignUpLoading());
    try {
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      User user = await _firebaseAuth.currentUser;
      UserData userData=
      UserData(
        uid: user.uid,
        fullName: _fullName,
        email: _email,
        phoneNumber: _phoneNumber,
        address: _address,
        role: UserData.ROLE_CUSTOMER,
        password: stringToBase64.encode(_password),
        category: UserData.ROLE_CUSTOMER,
        startHour: Timestamp.now(),
        endHour: Timestamp.now(),
      );
      await _firebaseFirestore.collection("users").doc(user.uid).set(userData.toJson());
      pref.setString(UserData.ROLE, userData.role);
      pref.setString(UserData.UID, userData.uid);
      pref.setString(UserData.FULL_NAME, userData.fullName);
      emit(SignUpSignedIn());
    } on FirebaseAuthException catch (e) {
      //TODO: State error
      // print(e.toString().contains("There is no user record corresponding to this identifier"));
      //Password should be at least 6 characters
      //The email address is already in use by another account.
      //We have blocked all requests from this device due to unusual activity. Try again later.
      print(e);
      if (e.toString().contains(
          "There is no user record corresponding to this identifier")) {
        emit(SignUpError("Account isn't Available", "الحساب غير موجود"));
      } else if (e
          .toString()
          .contains("Password should be at least 6 characters")) {
        emit(SignUpError("Password should be at least 6 characters.",
            "تتكون كلمة السر من ستة أحرف على الأقل"));
      }else if (e
          .toString()
          .contains("The email address is already in use by another account.")) {
        emit(SignUpError("The email address is already EXISTS.",
            "هذا الإيميل مستخدم سابقاً"));
      }else if (e
          .toString()
          .contains("We have blocked all requests from this device due to unusual activity. Try again later.")) {
        emit(SignUpError("Try Again Later",
            "جرب التسجيل لاحقاً"));
      } else
        emit(SignUpError('error', 'خطأ'));
    }
  }

  bool validator() {
    print("validator");
    if (_fullName.isEmpty) {
      emit(SignUpFullNameError());
    }
    if (_email.isEmpty || !EmailValidator.validate(_email)) {
      emit(SignUpEmailError());
    }
    if (_password.isEmpty) {
      emit(SignUpPasswordError());
    }
    if (_confirmPassword.compareTo(_password) != 0 ||
        _confirmPassword.isEmpty) {
      emit(SignUpConfirmPasswordError());
    }
    if (_phoneNumber.isEmpty) {
      emit(SignUpPhoneNumberError());
    }
    if (_address.isEmpty) {
      emit(SignUpAddressError());
    }
    return !(_fullName.isEmpty ||
        _email.isEmpty ||
        _password.isEmpty||
        !EmailValidator.validate(_email) ||
        _confirmPassword.compareTo(_password) != 0 ||
        _confirmPassword.isEmpty ||
        _phoneNumber.isEmpty ||
        _address.isEmpty);
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get confirmPassword => _confirmPassword;

  set confirmPassword(String value) {
    _confirmPassword = value;
  }

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get fullName => _fullName;

  set fullName(String value) {
    _fullName = value;
  }
}
