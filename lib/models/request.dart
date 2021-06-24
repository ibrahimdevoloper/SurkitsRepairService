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
  String _status;
  String _assignedByName;
  String _assignedById;
  String _fcmTokenForRequester;
  String _fcmTokenForAdmin;
  String _fcmTokenForWorker;

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

  String get requestId => _requestId;

  String get status => _status;

  String get assignedByName => _assignedByName;

  String get assignedById => _assignedById;

  String get fcmTokenForAdmin => _fcmTokenForAdmin;

  String get fcmTokenForWorker => _fcmTokenForWorker;

  String get fcmTokenForRequester => _fcmTokenForRequester;

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
    String status,
    String assignedByName,
    String assignedById,
    String fcmTokenForAdmin,
    String fcmTokenForWorker,
    String fcmTokenForRequester,
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
    _status = status;
    _assignedById = assignedById;
    _assignedByName = assignedByName;
    _fcmTokenForAdmin = fcmTokenForAdmin;
    _fcmTokenForWorker = fcmTokenForWorker;
    _fcmTokenForRequester = fcmTokenForRequester;
  }

  Request.fromJson(dynamic json, [String requestId]) {
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
    _status = json["status"];
    _assignedByName = json["assignedByName"];
    _assignedById = json["assignedById"];
    _fcmTokenForAdmin=json["fcmTokenForAdmin"];
    _fcmTokenForWorker=json["fcmTokenForWorker"];
    _fcmTokenForRequester=json["fcmTokenForRequester"];
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
    map["status"] = _status;
    map["assignedByName"] = _assignedByName;
    map["assignedById"] = _assignedById;
    map["fcmTokenForAdmin"]=_fcmTokenForAdmin;
    map["fcmTokenForWorker"]=_fcmTokenForWorker;
    map["fcmTokenForRequester"]=_fcmTokenForRequester;
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
  static const String CATEGORY_ELECTRICAL = "Electrical";
  static const String CATEGORY_HEATING = "Heating";
  static const String CATEGORY_PLUMING = "Pluming";
  static const String CATEGORY_ELECTRONICS = "Electronics";
  static const String APPOINTMENT_DATE = "appointmentDate";
  static const String RECORD_PATH = "recordPath";
  static const String WORKER_NAME = "workerName";
  static const String WORKER_ID = "workerId";
  static const String WORKER_EMAIL = "workerEmail";
  static const String WORKER_PHONE_NUMBER = "workerPhoneNumber";
  static const String STATUS = "status";
  static const String STATUS_REQUESTED = "requested";
  static const String STATUS_ASSIGNED = "assigned";
  static const String STATUS_COMPLETED = "completed";
  static const String ASSIGNED_BY_NAME = "assignedByName";
  static const String ASSIGNED_BY_ID = "assignedById";
  static const String FCM_TOKEN_FOR_ADMIN = "fcmTokenForAdmin";
  static const String FCM_TOKEN_FOR_WORKER = "fcmTokenForWorker";
  static const String FCM_TOKEN_FOR_REQUESTER = "fcmTokenForRequester";

  set requestText(String value) {
    _requestText = value;
  }

  set requesterId(String value) {
    _requesterId = value;
  }

  set requesterAddress(String value) {
    _requesterAddress = value;
  }

  set appointmentMicrosecondsSinceEpoch(int value) {
    _appointmentMicrosecondsSinceEpoch = value;
  }

  set requesterName(String value) {
    _requesterName = value;
  }

  set imagePath(String value) {
    _imagePath = value;
  }

  set appointmentTimeZoneName(String value) {
    _appointmentTimeZoneName = value;
  }

  set location(GeoPoint value) {
    _location = value;
  }

  set category(String value) {
    _category = value;
  }

  set appointmentDate(Timestamp value) {
    _appointmentDate = value;
  }

  set recordPath(String value) {
    _recordPath = value;
  }

  set workerName(String value) {
    _workerName = value;
  }

  set workerId(String value) {
    _workerId = value;
  }

  set workerEmail(String value) {
    _workerEmail = value;
  }

  set workerPhoneNumber(String value) {
    _workerPhoneNumber = value;
  }

  set status(String value) {
    _status = value;
  }

  set assignedById(String value) {
    _assignedById = value;
  }

  set assignedByName(String value) {
    _assignedByName = value;
  }

  set requestId(String value) {
    _requestId = value;
  }

  set fcmTokenForWorker(String value) {
    _fcmTokenForWorker = value;
  }

  set fcmTokenForAdmin(String value) {
    _fcmTokenForAdmin = value;
  }

  set fcmTokenForRequester(String value) {
    _fcmTokenForRequester = value;
  }
}
