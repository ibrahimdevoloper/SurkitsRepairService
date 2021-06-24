import 'package:an_app/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void registeringFCMTokenByUserData(String userUid) {
  //TODO: handle Errors
  var fcmToken = FirebaseMessaging.instance.getToken();
  FirebaseFirestore.instance
      .collection('users')
      .doc(userUid)
      .update({UserData.FCM_TOKEN: fcmToken}).then((value) {
    print('registeringFCMTokenByUserData:Fcm token Updated.');
  });
}