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

  String get uid => _uid;
  String get phoneNumber => _phoneNumber;
  String get address => _address;
  String get fullName => _fullName;
  String get email => _email;

  UserData({
      String uid, 
      String phoneNumber, 
      String address, 
      String fullName, 
      String email}){
    _uid = uid;
    _phoneNumber = phoneNumber;
    _address = address;
    _fullName = fullName;
    _email = email;
}

  UserData.fromJson(dynamic json) {
    _uid = json["uid"];
    _phoneNumber = json["phoneNumber"];
    _address = json["address"];
    _fullName = json["fullName"];
    _email = json["email"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = _uid;
    map["phoneNumber"] = _phoneNumber;
    map["address"] = _address;
    map["fullName"] = _fullName;
    map["email"] = _email;
    return map;
  }

}