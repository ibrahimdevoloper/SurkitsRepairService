import 'package:an_app/Services/SendNotificationService/SendNotificationService.dart';
import 'package:an_app/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future sendNotificationMethod(
    {String title, String text, usersId, String topic = ""}) async {
  // var notificationMap = {
  //   "notification": {
  //     "title": "New Assignment|طلب جديد",
  //     "text": "Press Here|أضغط هنا",
  //   },
  //   "priority": "high",
  //   "to": user.fcmToken
  // };
  assert(usersId is String || usersId is List<String>,
      "fcmToken type must be from String or List<String>");
  if (topic.isEmpty) {
    // var tokenDoc = await FirebaseFirestore.instance
    //     .collection("FirebaseTokens")
    //     .doc(usersId)
    //     .get();

    if (usersId is List<String>) {
      List<String> tokens = [];
      usersId.forEach((element) async {
        var tokenDoc = await FirebaseFirestore.instance
            .collection("FirebaseTokens")
            .doc(element)
            .get();
        tokens.add(UserData.fromJson(tokenDoc.data()).fcmToken);
      });
      var notificationMap = {
        "notification": {
          "title": title,
          "text": text,
        },
        "priority": "high",
        "to": tokens
      };
      var response = await SendNotificationService.create()
          .sendNotification(notificationMap);
      //TODO: handle Errors
      print(response.body);
    } else {
      var notificationMap = {
        "notification": {
          "title": title,
          "text": text,
        },
        "priority": "high",
        "to": usersId
      };
      var response = await SendNotificationService.create()
          .sendNotification(notificationMap);
      //TODO: handle Errors
      print(response.body);
    }
  } else {
    var notificationMap = {
      "notification": {
        "title": title,
        "text": text,
      },
      "priority": "high",
      "to": topic
    };
    var response = await SendNotificationService.create()
        .sendNotification(notificationMap);
    //TODO: handle Errors
    print(response.body);
  }
}
