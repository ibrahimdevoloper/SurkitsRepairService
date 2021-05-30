import 'package:cloud_firestore/cloud_firestore.dart';

/// requestText : " بنىنغؤعطؤمفؤماؤكغؤفمؤمفؤماؤ"
/// requesterId : "HrMi9KbeanW3vGExTl0ya9FXuWi2"
/// requesterAddress : "London"
/// appointmentMicrosecondsSinceEpoch : "1623035100000000"
/// requesterName : "surkits admin"
/// imagePath : "https://firebasestorage.googleapis.com/v0/b/repair-service-test-project.appspot.com/o/requests%2F7DLLZHzBrbCE8DX4Asuy%2Fimage.jpeg?alt=media&token=92a7c24d-e347-4468-bb55-3c91f138bf90"
/// appointmentTimeZoneName : "EEST"
/// location : "GeoPoint"
/// category : "Electrical"
/// appointmentDate : "Timestamp(seconds=1623035100, nanoseconds=0)"
/// recordPath : "https://firebasestorage.googleapis.com/v0/b/repair-service-test-project.appspot.com/o/requests%2F7DLLZHzBrbCE8DX4Asuy%2Fnote.acc?alt=media&token=6b18c228-3284-40c3-bc19-c7ae0f14c9f6"

class Request {
  String _requestId;
  String _requestText;
  String _requesterId;
  String _requesterAddress;
  int _appointmentMicrosecondsSinceEpoch;
  String _requesterName;
  String _imagePath;
  String _appointmentTimeZoneName;
  GeoPoint _location;
  String _category;
  Timestamp _appointmentDate;
  String _recordPath;
  String _workerName;
  String _workerId;
  String _workerEmail;
  String _workerPhoneNumber;

  String get requestText => _requestText;

  String get requesterId => _requesterId;

  String get requesterAddress => _requesterAddress;

  int get appointmentMicrosecondsSinceEpoch =>
      _appointmentMicrosecondsSinceEpoch;

  String get requesterName => _requesterName;

  String get imagePath => _imagePath;

  String get appointmentTimeZoneName => _appointmentTimeZoneName;

  GeoPoint get location => _location;

  String get category => _category;

  Timestamp get appointmentDate => _appointmentDate;

  String get recordPath => _recordPath;

  String get workerName => _workerName;

  String get workerId => _workerId;

  String get workerEmail => _workerEmail;

  String get workerPhoneNumber => _workerPhoneNumber;

  Request({
    String requestText,
    String requesterId,
    String requesterAddress,
    int appointmentMicrosecondsSinceEpoch,
    String requesterName,
    String imagePath,
    String appointmentTimeZoneName,
    GeoPoint location,
    String category,
    Timestamp appointmentDate,
    String recordPath,
    String workerName,
    String workerId,
    String workerEmail,
    String workerPhoneNumber,
  }) {
    _requestText = requestText;
    _requesterId = requesterId;
    _requesterAddress = requesterAddress;
    _appointmentMicrosecondsSinceEpoch = appointmentMicrosecondsSinceEpoch;
    _requesterName = requesterName;
    _imagePath = imagePath;
    _appointmentTimeZoneName = appointmentTimeZoneName;
    _location = location;
    _category = category;
    _appointmentDate = appointmentDate;
    _recordPath = recordPath;
    _workerName = workerName;
    _workerId = workerId;
    _workerEmail = workerEmail;
    _workerPhoneNumber = workerPhoneNumber;
  }

  Request.fromJson(dynamic json, String requestId) {
    _requestId = requestId;
    _requestText = json["requestText"];
    _requesterId = json["requesterId"];
    _requesterAddress = json["requesterAddress"];
    _appointmentMicrosecondsSinceEpoch =
        json["appointmentMicrosecondsSinceEpoch"];
    _requesterName = json["requesterName"];
    _imagePath = json["imagePath"];
    _appointmentTimeZoneName = json["appointmentTimeZoneName"];
    _location = json["location"];
    _category = json["category"];
    _appointmentDate = json["appointmentDate"];
    _recordPath = json["recordPath"];
    _workerName = json["workerName"];
    _workerId = json["workerId"];
    _workerEmail = json["workerEmail"];
    _workerPhoneNumber = json["workerPhoneNumber"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["requestText"] = _requestText;
    map["requesterId"] = _requesterId;
    map["requesterAddress"] = _requesterAddress;
    map["appointmentMicrosecondsSinceEpoch"] =
        _appointmentMicrosecondsSinceEpoch;
    map["requesterName"] = _requesterName;
    map["imagePath"] = _imagePath;
    map["appointmentTimeZoneName"] = _appointmentTimeZoneName;
    map["location"] = _location;
    map["category"] = _category;
    map["appointmentDate"] = _appointmentDate;
    map["recordPath"] = _recordPath;
    map["workerName"] = _workerName;
    map["workerId"] = _workerId;
    map["workerEmail"] = _workerEmail;
    map["workerPhoneNumber"] = _workerPhoneNumber;
    return map;
  }

  static const String REQUEST_TEXT = "requestText";
  static const String REQUESTER_ID = "requesterId";
  static const String REQUEST_ADDRESS = "requesterAddress";
  static const String APPOINTMENT_MICROSECONDS_SINCE_EPOCH =
      "appointmentMicrosecondsSinceEpoch";
  static const String REQUEST_NAME = "requesterName";
  static const String IMAGE_PATH = "imagePath";
  static const String APPOINTMENT_TIME_ZONE_NAME = "appointmentTimeZoneName";
  static const String LOCATION = "location";
  static const String CATEGORY = "category";
  static const String APPOINTMENT_DATE = "appointmentDate";
  static const String RECORD_PATH = "recordPath";
  static const String WORKER_NAME = "workerName";
  static const String WORKER_ID = "workerId";
  static const String WORKER_EMAIL = "workerEmail";
  static const String WORKER_PHONE_NUMBER = "workerPhoneNumber";

}