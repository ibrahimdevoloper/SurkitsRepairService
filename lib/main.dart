import 'dart:async';

import 'package:an_app/models/request.dart';
import 'package:an_app/models/user_data.dart';
import 'package:an_app/pages/AdminHomePage.dart';
import 'package:an_app/pages/CustomerHomePage.dart';
import 'package:an_app/pages/IntroWithSignInPage.dart';
import 'package:an_app/providers/SharedPreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
              if(snapshot.hasData){ print(snapshot.data[1]);
              SharedPreferences myPref = snapshot.data[1];
              provider.pref = myPref;
              return MaterialApp(
                title: 'AN App',
                debugShowCheckedModeBanner: false,
                routes: <String, WidgetBuilder>{
                  // '/signupScreen': (BuildContext context) => new SignupPage(),
                  // '/firstScreen': (BuildContext context) => new HomePage(),
                  // '/calendarScreen': (BuildContext context) => new calendarPage(),
                  // '/repairmanScreen': (BuildContext context) => new repairmanPage()
                },
                home:  StreamBuilder<User>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      User user = snapshot.data;
                      if (user == null)
                        return IntroPage();
                      else if (provider.pref.containsKey(UserData.ROLE)) {
                        // print(provider.pref.get(UserData.ROLE));
                        switch (provider.pref.get(UserData.ROLE)) {
                          case UserData.ROLE_ADMIN:
                            return AdminHomePage();
                            break;
                          case UserData.ROLE_CUSTOMER:
                            return CustomerHomePage();
                            break;
                          case UserData.ROLE_WORKER:
                            return CustomerHomePage();
                            break;
                          default:
                            return Scaffold(
                              body: Center(
                                child: Text("error"),
                              ),
                            );
                            break;
                        }
                      } else if (!provider.pref
                          .containsKey(UserData.ROLE)) {
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
                                      UserData.FULL_NAME, userData.fullName);
                                  provider.pref.setString(
                                      UserData.UID, userData.uid);
                                  // print(provider.pref.get(userData.role));
                                  switch (userData.role) {
                                    case UserData.ROLE_ADMIN:
                                      return AdminHomePage();
                                      break;
                                    case UserData.ROLE_CUSTOMER:
                                      return CustomerHomePage();
                                      break;
                                    case UserData.ROLE_WORKER:
                                      return CustomerHomePage();
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
              );}
              else{
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
                  )
                );
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
