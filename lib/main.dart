import 'dart:async';

import 'package:an_app/Functions/registeringFCMTokenByPref.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/models/request.dart';
import 'package:an_app/models/user_data.dart';
import 'package:an_app/pages/AdminHomePage.dart';
import 'package:an_app/pages/CustomerHomePage.dart';
import 'package:an_app/pages/IntroWithSignInPage.dart';
import 'package:an_app/pages/WorkerHomePage.dart';
import 'package:an_app/providers/SharedPreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Functions/registeringFCMTokenByUserData.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SharedPreferencesProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SharedPreferencesProvider>(builder: (context, provider, _) {
      return FutureBuilder(
          future: Future.wait(
              [Firebase.initializeApp(), SharedPreferences.getInstance()]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                // TODO: check IOS Permission
                print(snapshot.data[1]);
                SharedPreferences myPref = snapshot.data[1];
                provider.pref = myPref;
                FirebaseCrashlytics.instance
                    .setCrashlyticsCollectionEnabled(true);
                return MaterialApp(
                  title: 'AN App',
                  debugShowCheckedModeBanner: false,
                  navigatorObservers: [
                    FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
                  ],
                  routes: <String, WidgetBuilder>{
                    // '/signupScreen': (BuildContext context) => new SignupPage(),
                    // '/firstScreen': (BuildContext context) => new HomePage(),
                    // '/calendarScreen': (BuildContext context) => new calendarPage(),
                    // '/repairmanScreen': (BuildContext context) => new repairmanPage()
                  },
                  home: StreamBuilder<User>(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        FirebaseMessaging.onMessage.listen((event) {
                          // Scaffold.of(context).showSnackBar(snackbar);
                          //Todo: test this code
                          showFlash(
                            context: context,
                            duration: const Duration(seconds: 6),
                            builder: (context, controller) {
                              return Flash.bar(
                                borderWidth: 4,
                                borderColor: leftColor,
                                controller: controller,
                                boxShadows: [
                                  BoxShadow(
                                      color: Colors.black87,
                                      blurRadius: 6,
                                      offset: Offset(1, 3))
                                ],
                                // backgroundGradient: LinearGradient(
                                //   colors: [leftColor, rightColor],
                                // ),
                                backgroundColor: Colors.lightBlueAccent,
                                // Position is only available for the "bar" named constructor and can be bottom/top.
                                position: FlashPosition.top,
                                // Allow dismissal by dragging down.
                                enableVerticalDrag: false,

                                // Allow dismissal by dragging to the side (and specify direction).
                                horizontalDismissDirection:
                                    HorizontalDismissDirection.startToEnd,
                                margin: const EdgeInsets.all(8),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                // Make the animation lively by experimenting with different curves.
                                forwardAnimationCurve: Curves.easeOutBack,
                                reverseAnimationCurve: Curves.slowMiddle,
                                // While it's possible to use any widget you like as the child,
                                // the FlashBar widget looks good without any effort on your side.
                                child: FlashBar(
                                  title: Row(
                                    children: [
                                      Text(
                                        "New Message",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      Text(
                                        "رسالة جديدة",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                    ],
                                  ),
                                  // content: Row(
                                  //   children: [
                                  //     Text(event.data["messageAr"]),
                                  //     Text(event.data["messageEn"]),
                                  //   ],
                                  // ),
                                  icon: Icon(
                                    Icons.notification_important_rounded,
                                    // This color is also pulled from the theme. Let's change it to black.
                                    color: Colors.white,
                                  ),
                                  shouldIconPulse: false,
                                  showProgressIndicator: false,
                                ),
                              );
                            },
                          );
                          print("onMessage:${event.messageId}");
                          // SnackBar snackBar = SnackBar(
                          //   );
                          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                        User user = snapshot.data;
                        if (user == null)
                          return IntroPage();
                        else if (provider.pref.containsKey(UserData.ROLE)) {
                          if (provider.pref
                              .getString(UserData.ROLE)
                              .isNotEmpty) {
                            registeringFCMTokenByPref(provider);
                            if (provider.pref
                                    .getString(UserData.ROLE)
                                    .compareTo(UserData.ROLE_ADMIN) ==
                                0) {
                              FirebaseMessaging.instance
                                  .subscribeToTopic("admin");
                            } else {
                              FirebaseMessaging.instance
                                  .unsubscribeFromTopic("admin");
                            }
                            print(provider.pref.get(UserData.ROLE));
                            switch (provider.pref.get(UserData.ROLE)) {
                              case UserData.ROLE_ADMIN:
                                return AdminHomePage();
                                break;
                              case UserData.ROLE_CUSTOMER:
                                return CustomerHomePage();
                                break;
                              case UserData.ROLE_WORKER:
                                return WorkerHomePage();
                                break;
                              default:
                                return Scaffold(
                                  body: Center(
                                    child: Text("error"),
                                  ),
                                );
                                break;
                            }
                          } else {
                            return FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      UserData userData = UserData.fromJson(
                                          snapshot.data.data());

                                      provider.pref.setString(
                                          UserData.ROLE, userData.role);
                                      provider.pref.setString(
                                          UserData.FULL_NAME,
                                          userData.fullName);
                                      provider.pref.setString(
                                          UserData.UID, userData.uid);
                                      // print(provider.pref.get(userData.role));
                                      registeringFCMTokenByUserData(
                                          userData.uid);
                                      if (userData.role
                                              .compareTo(UserData.ROLE_ADMIN) ==
                                          0) {
                                        FirebaseMessaging.instance
                                            .subscribeToTopic("admin");
                                      } else {
                                        FirebaseMessaging.instance
                                            .unsubscribeFromTopic("admin");
                                      }
                                      print(userData.role);
                                      switch (userData.role) {
                                        case UserData.ROLE_ADMIN:
                                          return AdminHomePage();
                                          break;
                                        case UserData.ROLE_CUSTOMER:
                                          return CustomerHomePage();
                                          break;
                                        case UserData.ROLE_WORKER:
                                          return WorkerHomePage();
                                          break;
                                        default:
                                          return Scaffold(
                                            body: Center(
                                              child: Text("error"),
                                            ),
                                          );
                                          break;
                                      }
                                    } else {
                                      return Scaffold(
                                        body: Center(
                                          child: Text("error"),
                                        ),
                                      );
                                    }
                                  } else {
                                    return Scaffold(
                                      body: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  }
                                });
                          }
                        } else if (!provider.pref.containsKey(UserData.ROLE)) {
                          return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasData) {
                                    UserData userData =
                                        UserData.fromJson(snapshot.data.data());

                                    provider.pref.setString(
                                        UserData.ROLE, userData.role);
                                    provider.pref.setString(
                                        UserData.FULL_NAME, userData.fullName);
                                    provider.pref
                                        .setString(UserData.UID, userData.uid);
                                    // print(provider.pref.get(userData.role));
                                    registeringFCMTokenByUserData(userData.uid);
                                    if (userData.role
                                            .compareTo(UserData.ROLE_ADMIN) ==
                                        0) {
                                      FirebaseMessaging.instance
                                          .subscribeToTopic("admin");
                                    } else {
                                      FirebaseMessaging.instance
                                          .unsubscribeFromTopic("admin");
                                    }
                                    print(userData.role);
                                    switch (userData.role) {
                                      case UserData.ROLE_ADMIN:
                                        return AdminHomePage();
                                        break;
                                      case UserData.ROLE_CUSTOMER:
                                        return CustomerHomePage();
                                        break;
                                      case UserData.ROLE_WORKER:
                                        return WorkerHomePage();
                                        break;
                                      default:
                                        return Scaffold(
                                          body: Center(
                                            child: Text("error"),
                                          ),
                                        );
                                        break;
                                    }
                                  } else {
                                    return Scaffold(
                                      body: Center(
                                        child: Text("error"),
                                      ),
                                    );
                                  }
                                } else {
                                  return Scaffold(
                                    body: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                }
                              });
                        } else {
                          return Scaffold(
                            body: Center(
                              child: Text("error"),
                            ),
                          );
                        }
                      }),
                );
              } else {
                print(snapshot.error.toString());
                // SharedPreferences myPref = snapshot.data[1];
                // provider.pref = myPref;
                return MaterialApp(
                    title: 'AN App',
                    debugShowCheckedModeBanner: false,
                    routes: <String, WidgetBuilder>{
                      // '/signupScreen': (BuildContext context) => new SignupPage(),
                      // '/firstScreen': (BuildContext context) => new HomePage(),
                      // '/calendarScreen': (BuildContext context) => new calendarPage(),
                      // '/repairmanScreen': (BuildContext context) => new repairmanPage()
                    },
                    home: Scaffold(
                      body: Center(
                        child: Text("error"),
                      ),
                    ));
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          });
    });
  }
}
//
// class MainPage extends StatefulWidget {
//   @override
//   _MainPageState createState() => _MainPageState();
// }
//
// class _MainPageState extends State<MainPage> {
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called
//     return Scaffold(
//       // resizeToAvoidBottomPadding: false,
//       body: Column(
//         // mainAxisAlignment: MainAxisAlignment.center,
//         // crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           getTopFirstContainer(TextPair('Hello', 'مرحبا')),
//           Container(
//               padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
//               child: Column(
//                 children: <Widget>[
//                   TextField(
//                     decoration: InputDecoration(
//                         labelText: 'EMAIL',
//                         labelStyle: textFillStyle,
//                         focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: middleColor))),
//                   ),
//                   SizedBox(height: 20.0),
//                   TextField(
//                     decoration: InputDecoration(
//                         labelText: 'PASSWORD',
//                         labelStyle: textFillStyle,
//                         focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: middleColor))),
//                     obscureText: true,
//                   ),
//                   SizedBox(height: 20.0),
//                   Container(
//                     // alignment: Alignment(1.0, 0.0), // same as centerRight
//                     alignment: Alignment.centerRight,
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.of(context).pushNamed('/repairmanScreen');
//                       },
//                       child: Text("Forgot password?", style: noteClickStyle),
//                     ),
//                   ),
//                   SizedBox(height: 40.0),
//                   Container(
//                       padding: EdgeInsets.all(0),
//                       constraints: BoxConstraints.expand(height: 40),
//                       decoration: BoxDecoration(
//                           gradient: new LinearGradient(
//                               colors: [rightColor, leftColor],
//                               begin: const FractionalOffset(1.0, 1.0),
//                               end: const FractionalOffset(0.2, 0.2),
//                               stops: [0.0, 1.0],
//                               tileMode: TileMode.clamp),
//                           borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(10),
//                               topRight: Radius.circular(10),
//                               bottomLeft: Radius.circular(10),
//                               bottomRight: Radius.circular(10))),
//                       //child: GestureDetector(
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.of(context).pushNamed('/firstScreen');
//                         },
//                         child: Center(
//                           child: Text(
//                             'LOGIN',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: 'Montserrat',
//                                 fontSize: 17),
//                           ),
//                         ),
//                       )),
//                   //),
//
//                   SizedBox(height: 20.0),
//                   Container(
//                     height: 40.0,
//                     color: Colors.transparent,
//                   )
//                 ],
//               )),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text('New to Business Name?', style: noteStyle),
//               SizedBox(width: 5.0),
//               InkWell(
//                 onTap: () {
//                   Navigator.of(context).pushNamed('/signupScreen');
//                 },
//                 child: Text("Create an account.", style: noteClickStyle),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
