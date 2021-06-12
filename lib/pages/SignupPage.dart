import 'package:an_app/Cubits/signUp/sign_up_cubit.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/Widgets/BlueGradientAppBar.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:an_app/models/global.dart';
import 'package:an_app/providers/SharedPreferences.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
// import '../global.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpCubit>(
      create: (context) => SignUpCubit(),
      child: Scaffold(
          // resizeToAvoidBottomPadding: false,
          body: BlocConsumer<SignUpCubit, SignUpState>(
              listenWhen: (previous, current) {
        return current is SignUpSignedIn || current is SignUpError;
      }, listener: (context, state) {
        if (state is SignUpSignedIn) {
          Navigator.pop(context);
        } else if (state is SignUpError) {
          var snackBar = SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(state.messageEn)),
                Expanded(child: Text(state.messageAr)),
              ],
            ),
            duration: Duration(milliseconds: 1000),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }, buildWhen: (previous, current) {
        return current is SignUpInitial ||
            current is SignUpLoading ||
            current is SignUpError;
      }, builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is SignUpLoading,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            // getTopContainer(TextPair('Sign up', 'تسجيل دخول')),
            BlueGradientAppBar(
                TextPair('How can we help?', 'كيف يمكننا مساعدتك؟')),
            Expanded(
              child: Container(
                  padding: EdgeInsets.only(top: 36.0, left: 16.0, right: 16.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      BlocBuilder<SignUpCubit, SignUpState>(
                          buildWhen: (previous, current) {
                        return current is SignUpInitial ||
                            current is SignUpFullNameError ||
                            current is SignUpFullNameReset;
                      }, builder: (context, state) {
                        return TextField(
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            errorText: state is SignUpFullNameError
                                ? "Check Your Full Name"
                                : null,
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: middleColor),
                            ),
                          ),
                          onChanged: (value) {
                            BlocProvider.of<SignUpCubit>(context).fullName =
                                value;
                          },
                          onTap: () {
                            BlocProvider.of<SignUpCubit>(context)
                                .emit(SignUpFullNameReset());
                          },
                        );
                      }),
                      SizedBox(height: 8.0),
                      BlocBuilder<SignUpCubit, SignUpState>(
                          buildWhen: (previous, current) {
                        return current is SignUpInitial ||
                            current is SignUpEmailError ||
                            current is SignUpEmailReset;
                      }, builder: (context, state) {
                        return TextField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            errorText: state is SignUpEmailError
                                ? "please enter a correct e-mail"
                                : null,
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: middleColor),
                            ),
                          ),
                          onTap: () {
                            var cubit = BlocProvider.of<SignUpCubit>(context);
                            cubit.emit(SignUpEmailReset());
                          },
                          onChanged: (value) {
                            var cubit = BlocProvider.of<SignUpCubit>(context);
                            if (EmailValidator.validate(value)) {
                              print("true");
                              cubit.email = value;
                              cubit.emit(SignUpEmailReset());
                            } else {
                              print("false");
                              cubit.email = value;
                              cubit.emit(SignUpEmailError());
                            }
                          },
                        );
                      }),
                      SizedBox(height: 8.0),
                      BlocBuilder<SignUpCubit, SignUpState>(
                          buildWhen: (previous, current) {
                        return current is SignUpInitial ||
                            current is SignUpPasswordError ||
                            current is SignUpPasswordReset;
                      }, builder: (context, state) {
                        return TextField(
                          decoration: InputDecoration(
                              labelText: 'Password',
                              errorText: state is SignUpPasswordError
                                  ? "Must Contain more than 6 Characters"
                                  : null,
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: middleColor))),
                          obscureText: true,
                          onTap: () {
                            BlocProvider.of<SignUpCubit>(context)
                                .emit(SignUpPasswordReset());
                          },
                          onChanged: (value) {
                            if(value.length>=6) {
                              BlocProvider.of<SignUpCubit>(context)
                                  .emit(SignUpPasswordReset());
                              BlocProvider.of<SignUpCubit>(context).password =
                                  value;
                            }else{
                              BlocProvider.of<SignUpCubit>(context)
                                  .emit(SignUpPasswordError());
                              BlocProvider.of<SignUpCubit>(context).password =
                                  value;
                            }
                            // BlocProvider.of<SignUpCubit>(context).emit(SignUpPasswordReset());
                          },
                        );
                      }),
                      SizedBox(height: 8.0),
                      BlocBuilder<SignUpCubit, SignUpState>(
                          buildWhen: (previous, current) {
                        return current is SignUpInitial ||
                            current is SignUpConfirmPasswordError ||
                            current is SignUpConfirmPasswordReset;
                      }, builder: (context, state) {
                        return TextField(
                          decoration: InputDecoration(
                              errorText: state is SignUpConfirmPasswordError
                                  ? "the fields don't match"
                                  : null,
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: middleColor))),
                          obscureText: true,
                          onChanged: (value) {
                            var cubit = BlocProvider.of<SignUpCubit>(context);
                            if (cubit.password.compareTo(value) == 0) {
                              BlocProvider.of<SignUpCubit>(context)
                                  .emit(SignUpConfirmPasswordReset());
                              BlocProvider.of<SignUpCubit>(context)
                                  .confirmPassword = value;
                            } else {
                              BlocProvider.of<SignUpCubit>(context)
                                  .emit(SignUpConfirmPasswordError());
                              BlocProvider.of<SignUpCubit>(context)
                                  .confirmPassword = value;
                            }
                          },
                        );
                      }),
                      SizedBox(height: 8.0),
                      BlocBuilder<SignUpCubit, SignUpState>(
                          buildWhen: (previous, current) {
                        return current is SignUpInitial ||
                            current is SignUpPhoneNumberError ||
                            current is SignUpPhoneNumberReset;
                      }, builder: (context, state) {
                        return TextField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            errorText: state is SignUpPhoneNumberError
                                ? "Check Phone Number Field"
                                : null,
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: middleColor,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            BlocProvider.of<SignUpCubit>(context).phoneNumber =
                                value;
                          },
                          onTap: () {
                            BlocProvider.of<SignUpCubit>(context)
                                .emit(SignUpPhoneNumberReset());
                          },
                        );
                      }),
                      BlocBuilder<SignUpCubit, SignUpState>(
                          buildWhen: (previous, current) {
                        return current is SignUpInitial ||
                            current is SignUpAddressError ||
                            current is SignUpAddressReset;
                      }, builder: (context, state) {
                        return TextField(
                          decoration: InputDecoration(
                            errorText: state is SignUpAddressError
                                ? "Check Address Field"
                                : null,
                            labelText: 'Address ',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: middleColor,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            BlocProvider.of<SignUpCubit>(context).address =
                                value;
                          },
                          onTap: () {
                            BlocProvider.of<SignUpCubit>(context)
                                .emit(SignUpAddressReset());
                          },
                        );
                      }),
                      SizedBox(height: 52.0),
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
                                bottomRight: Radius.circular(10))
                            //borderRadius: BorderRadius.circular(20.0),
                            ),
                        child: Consumer<SharedPreferencesProvider>(
                          builder: (_,provider,__)=>GestureDetector(
                            onTap: () {
                              var cubit = BlocProvider.of<SignUpCubit>(context);
                              if (cubit.validator()) {
                                cubit.SignUp(provider.pref);
                              } else {
                                cubit.emit(SignUpError(
                                    "Check Fields", "تحقق من الحقول"));
                              }
                            },
                            child: Center(
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        height: 46.0,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1.0),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            //borderRadius: BorderRadius.circular(20.0)
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Center(
                              child: Text('Go Back',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat')),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ]),
        );
      })),
    );
  }
}
