import 'package:an_app/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> registeringFCMTokenByUserData(String userUid) async {
  //TODO: handle Errors
  var fcmToken =await  FirebaseMessaging.instance.getToken();
  FirebaseFirestore.instance
      .collection('FirebaseTokens')
      .doc(userUid)
      .update({UserData.FCM_TOKEN: fcmToken}).then((value) {
    print('registeringFCMTokenByUserData:Fcm token Updated.');
  });
}