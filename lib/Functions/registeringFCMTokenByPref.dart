import 'package:an_app/models/user_data.dart';
import 'package:an_app/providers/SharedPreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future registeringFCMTokenByPref(SharedPreferencesProvider provider) async {
  //TODO: handle Errors
  var fcmToken = await FirebaseMessaging.instance.getToken();
  FirebaseFirestore.instance
      .collection('users')
      .doc(provider.pref.getString(UserData.UID))
      .update({UserData.FCM_TOKEN: fcmToken}).then((value) {
    print('registeringFCMTokenByPref:Fcm token Updated.');
  });
}