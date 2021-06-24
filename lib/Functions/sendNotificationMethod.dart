import 'package:an_app/Services/SendNotificationService/SendNotificationService.dart';

Future sendNotificationMethod({String title, String text, fcmToken}) async {
  // var notificationMap = {
  //   "notification": {
  //     "title": "New Assignment|طلب جديد",
  //     "text": "Press Here|أضغط هنا",
  //   },
  //   "priority": "high",
  //   "to": user.fcmToken
  // };
  assert(fcmToken is String || fcmToken is List<String>,
  "fcmToken type must be from String or List<String>");
  var notificationMap = {
    "notification": {
      "title": title,
      "text": text,
    },
    "priority": "high",
    "to": fcmToken
  };
  var response =await SendNotificationService.create().sendNotification(notificationMap);
  //TODO: handle Errors
  print(response.body);
}