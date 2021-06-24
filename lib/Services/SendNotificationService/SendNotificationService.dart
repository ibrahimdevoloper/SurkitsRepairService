import 'package:an_app/Constants/FirebaseKeys.dart';
import 'package:chopper/chopper.dart';

part 'SendNotificationService.chopper.dart';

@ChopperApi(baseUrl: '/send')
abstract class SendNotificationService extends ChopperService {
  //example of Notification
  //you can send in this class/function
  /*
  * var request = {
    "notification": {
      "title": title,
      "text": message,
    },
    "priority": "high",
    "to": "/topics/all", or "to": "fcmToken",
  };
  * */

  @Post(headers: {
    "Content-Type": "application/json",
    "Authorization": "key=${FirebaseKeys.serverKey}",
  })
  Future<Response> sendNotification(@Body() body,);

  static SendNotificationService create() {
    final client = ChopperClient(
      baseUrl: 'https://fcm.googleapis.com/fcm',
      services: [
        _$SendNotificationService(),
      ],
      converter: JsonConverter(),
    );

    return _$SendNotificationService(client);
  }
}
