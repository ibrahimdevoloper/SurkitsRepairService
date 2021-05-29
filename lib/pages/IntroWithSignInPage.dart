import 'package:an_app/Cubits/IntroWithSignIn/intro_with_sign_in_cubit.dart';
import 'package:an_app/UIValuesFolder/TextStyles.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/Widgets/IntroTopContainer.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:an_app/pages/SignupPage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<IntroWithSignInCubit>(
      create: (context) => IntroWithSignInCubit(),
      child: Scaffold(
        // resizeToAvoidBottomPadding: false,
        body: BlocConsumer<IntroWithSignInCubit, IntroWithSignInState>(
            // bloc: BlocProvider.of<IntroWithSignInCubit>(context),
            listenWhen: (previous, current) {
          return current is IntroWithSignInSignedIn ||
              current is IntroWithSignInError;
        }, listener: (context, state) {
          if (state is IntroWithSignInSignedIn) {
            Navigator.pop(context);
          } else if (state is IntroWithSignInError) {
            var snackBar = SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(state.massageEn)),
                  Expanded(child: Text(state.massageAr)),
                ],
              ),
              duration: Duration(milliseconds: 1000),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }, buildWhen: (previous, current) {
          return current is IntroWithSignInLoading ||
              current is IntroWithSignInError ||
              current is IntroWithSignInInitial;
        }, builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state is IntroWithSignInLoading,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // getTopFirstContainer(TextPair('Hello', 'مرحبا')),
                IntroTopAppBar(TextPair('Hello', 'مرحبا')),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: [
                            BlocBuilder<IntroWithSignInCubit,
                                    IntroWithSignInState>(
                                bloc: BlocProvider.of<IntroWithSignInCubit>(
                                    context),
                                buildWhen: (previous, current) {
                                  print(current);
                                  return current is IntroWithSignInEmailError ||
                                      current is IntroWithSignInEmailReset ||
                                      current is IntroWithSignInInitial;
                                },
                                builder: (context, state) {
                                  return TextField(
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'EMAIL',
                                      labelStyle: textFillStyle,
                                      errorText:
                                          state is IntroWithSignInEmailError
                                              ? "Please Type Correct E-mail"
                                              : null,
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: middleColor),
                                      ),
                                    ),
                                    onTap: () {
                                      var cubit =
                                          BlocProvider.of<IntroWithSignInCubit>(
                                              context);
                                      cubit.emit(IntroWithSignInEmailReset());
                                    },
                                    onChanged: (value) {
                                      var cubit =
                                          BlocProvider.of<IntroWithSignInCubit>(
                                              context);
                                      if (EmailValidator.validate(value)) {
                                        print("true");
                                        cubit.email = value;
                                        cubit.emit(IntroWithSignInEmailReset());
                                      } else {
                                        print("false");
                                        cubit.email = value;
                                        cubit.emit(IntroWithSignInEmailError());
                                      }
                                    },
                                  );
                                }),
                            BlocBuilder<IntroWithSignInCubit,
                                IntroWithSignInState>(
                                bloc: BlocProvider.of<IntroWithSignInCubit>(
                                    context),
                                buildWhen: (previous, current) {
                                  print(current);
                                  return current is IntroWithSignInPasswordError ||
                                      current is IntroWithSignInPasswordReset ||
                                      current is IntroWithSignInInitial;
                                },
                                builder: (context, state){
                                return TextField(
                                  decoration: InputDecoration(
                                      errorText:
                                      state is IntroWithSignInPasswordError
                                          ? "Please Type Correct Password"
                                          : null,
                                      labelText: 'PASSWORD',
                                      labelStyle: textFillStyle,
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: middleColor))),
                                  obscureText: true,
                                  onTap: () {
                                    var cubit =
                                    BlocProvider.of<IntroWithSignInCubit>(
                                        context);
                                    cubit.emit(IntroWithSignInPasswordReset());
                                  },
                                  onChanged: (value) {
                                    var cubit =
                                        BlocProvider.of<IntroWithSignInCubit>(
                                            context);
                                    cubit.password = value;
                                  },
                                );
                              }
                            ),
                            // SizedBox(height: 20.0),
                            Container(
                              // alignment: Alignment(1.0, 0.0), // same as centerRight
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  //TODO: send to repair man screen
                                  // Navigator.of(context).pushNamed('/repairmanScreen');
                                },
                                child: Text("Forgot password?",
                                    style: noteClickStyle),
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(height: 20.0),
                        // SizedBox(height: 40.0),
                        Container(
                            padding: EdgeInsets.all(0),
                            constraints: BoxConstraints.expand(height: 40),
                            decoration: BoxDecoration(
                                gradient: new LinearGradient(
                                    colors: [rightColor, leftColor],
                                    begin: const FractionalOffset(1.0, 1.0),
                                    end: const FractionalOffset(0.2, 0.2),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            //child: GestureDetector(
                            child: InkWell(
                              onTap: () {
                                // Navigator.of(context).pushNamed('/firstScreen');
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => HomePage()));
                                var cubit =
                                    BlocProvider.of<IntroWithSignInCubit>(
                                        context);
                                if (cubit.validator()) {
                                  cubit.SignIn();
                                } else {
                                  cubit.emit(IntroWithSignInError("Check Input Fields", "تحقق من حقول الإدخال"));
                                }
                              },
                              child: Center(
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                      fontSize: 17),
                                ),
                              ),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('New to Business Name?', style: noteStyle),
                            SizedBox(width: 5.0),
                            InkWell(
                              onTap: () {
                                // Navigator.of(context).pushNamed('/signupScreen');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupPage(),
                                  ),
                                );
                              },
                              child: Text("Create an account.",
                                  style: noteClickStyle),
                            )
                          ],
                        )

                        // SizedBox(height: 60.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
