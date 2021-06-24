import 'dart:convert';

import 'package:an_app/models/user_data.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'admin_add_admin_state.dart';

class AdminAddAdminCubit extends Cubit<AdminAddAdminState> {


  FirebaseAuth _firebaseAuth;
  FirebaseFirestore _firebaseFirestore;
  String _fullName = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";
  String _phoneNumber = "";
  String _address = "";
  DateTime _startHour;
  DateTime _endHour;
  String _category = "";

  AdminAddAdminCubit() : super(AdminAddAdminInitial()) {
    _firebaseAuth = FirebaseAuth.instance;
    _firebaseFirestore = FirebaseFirestore.instance;
  }


  Future<String> AdminAddAdmin(// {String email, String password}
      ) async {
    emit(AdminAddAdminLoading());
    try {
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      User user = await _firebaseAuth.currentUser;
      // Map<String, dynamic> map = {
      //   "uid": user.uid,
      //   "fullName": _fullName,
      //   "password": stringToBase64.encode(_password),
      //   "email": _email,
      //   "phoneNumber": _phoneNumber,
      //   "address": _address,
      //   "role": "Admin",
      //   "category": _category,
      //   "endHour": Timestamp.fromDate(_endHour),
      //   "startHour": Timestamp.fromDate(_startHour)
      // };
      UserData userData=
      UserData(
        uid: user.uid,
        fullName: _fullName,
        email: _email,
        phoneNumber: _phoneNumber,
        address: _address,
        role: UserData.ROLE_ADMIN,
        password: stringToBase64.encode(_password),
        category: _category,
        startHour: Timestamp.now(),
        endHour: Timestamp.now(),
      );
      // print(Timestamp.fromDate(_startHour).toDate());
      // print(map);

      await _firebaseFirestore.collection("users").doc(user.uid).set(userData.toJson());
      print("email: $_email, password: $_password");
      emit(AdminAddAdminLoaded());
    } on FirebaseAuthException catch (e) {
      //TODO: State error
      // print(e.toString().contains("There is no user record corresponding to this identifier"));
      //Password should be at least 6 characters
      //The email address is already in use by another account.
      //We have blocked all requests from this device due to unusual activity. Try again later.
      print(e);
      if (e.toString().contains(
          "There is no user record corresponding to this identifier")) {
        emit(
            AdminAddAdminError("Account isn't Available", "الحساب غير موجود"));
      } else if (e
          .toString()
          .contains("Password should be at least 6 characters")) {
        emit(AdminAddAdminError("Password should be at least 6 characters.",
            "تتكون كلمة السر من ستة أحرف على الأقل"));
      } else if (e.toString().contains(
          "The email address is already in use by another account.")) {
        emit(AdminAddAdminError("The email address is already EXISTS.",
            "هذا الإيميل مستخدم سابقاً"));
      } else if (e.toString().contains(
          "We have blocked all requests from this device due to unusual activity. Try again later.")) {
        emit(AdminAddAdminError("Try Again Later", "جرب التسجيل لاحقاً"));
      } else
        emit(AdminAddAdminError('error', 'خطأ'));
    }
  }

  bool validator() {
    print("validator");
    if (_fullName.isEmpty) {
      emit(AdminAddAdminFullNameError());
    }
    if (_email.isEmpty || !EmailValidator.validate(_email)) {
      emit(AdminAddAdminEmailError());
    }
    if (_password.isEmpty) {
      emit(AdminAddAdminPasswordError());
    }
    if (_confirmPassword.compareTo(_password) != 0 ||
        _confirmPassword.isEmpty) {
      emit(AdminAddAdminConfirmPasswordError());
    }
    if (_phoneNumber.isEmpty) {
      emit(AdminAddAdminPhoneNumberError());
    }
    if (_address.isEmpty) {
      emit(AdminAddAdminAddressError());
    }
    if (_startHour == null) {
      emit(AdminAddAdminStartWorkHourError());
    }
    if (_endHour == null) {
      emit(AdminAddAdminEndWorkHourError());
    }
    return !(_fullName.isEmpty ||
        _email.isEmpty ||
        _password.isEmpty ||
        !EmailValidator.validate(_email) ||
        _confirmPassword.compareTo(_password) != 0 ||
        _confirmPassword.isEmpty ||
        _phoneNumber.isEmpty ||
        _address.isEmpty ||
        _startHour == null ||
        _endHour == null);
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

  String get category => _category;

  set category(String value) {
    _category = value;
  }

  DateTime get endHour => _endHour;

  set endHour(DateTime value) {
    _endHour = value;
  }

  DateTime get startHour => _startHour;

  set startHour(DateTime value) {
    _startHour = value;
  }
}
