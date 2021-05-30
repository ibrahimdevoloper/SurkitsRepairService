import 'package:cloud_firestore/cloud_firestore.dart';

/// uid : "VsjbUxpjPbcwLhOtqkap63K3Ivl1"
/// phoneNumber : "959 504 146"
/// address : "mojtahed"
/// fullName : "Ibrahim"
/// email : "Ibrahimarc@outlook.com"

class UserData {
  String _uid;
  String _phoneNumber;
  String _address;
  String _fullName;
  String _email;
  String _category;
  String _role;
  String _password;
  Timestamp _startHour;
  Timestamp _endHour;

  String get uid => _uid;

  String get phoneNumber => _phoneNumber;

  String get address => _address;

  String get fullName => _fullName;

  String get email => _email;

  String get category => _category;

  String get role => _role;

  String get password => _password;

  Timestamp get startHour => _startHour;

  Timestamp get endHour => _endHour;

  UserData({
    String uid,
    String phoneNumber,
    String address,
    String fullName,
    String email,
    String category,
    String role,
    String password,
    Timestamp startHour,
    Timestamp endHour,
  }) {
    _uid = uid;
    _phoneNumber = phoneNumber;
    _address = address;
    _fullName = fullName;
    _email = email;
    _category = category;
    _role = role;
    _password = password;
    _startHour = startHour;
    _endHour = endHour;
  }

  UserData.fromJson(dynamic json) {
    _uid = json["uid"];
    _phoneNumber = json["phoneNumber"];
    _address = json["address"];
    _fullName = json["fullName"];
    _email = json["email"];
    _category = json["category"];
    _role = json["role"];
    _password = json["password"];
    _startHour = json["startHour"];
    _endHour = json["endHour"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = _uid;
    map["phoneNumber"] = _phoneNumber;
    map["address"] = _address;
    map["fullName"] = _fullName;
    map["email"] = _email;
    map["category"] = _category;
    map["role"] = _role;
    map["password"] = _password;
    map["startHour"] = _startHour;
    map["endHour"] = _endHour;
    return map;
  }

  static const String UID = "uid";

  static const String PHONE_NUMBER = "phoneNumber";

  static const String ADDRESS = "address";

  static const String FULL_NAME = "fullName";

  static const String EMAIL = "email";

  static const String CATEGORY = "category";

  static const String ROLE = "role";

  static const String PASSWORD = "password";

  static const String START_HOUR = "startHour";

  static const String END_HOUR = "endHour";
}
