import 'package:an_app/Cubits/ResetPasswordRequest/reset_password_request_cubit.dart';
import 'package:an_app/Cubits/signUp/sign_up_cubit.dart';
import 'package:an_app/UIValuesFolder/TextStyles.dart';
import 'package:an_app/UIValuesFolder/blueColors.dart';
import 'package:an_app/Widgets/BlueGradientAppBar.dart';
import 'package:an_app/models/TextPair.dart';
import 'package:an_app/providers/SharedPreferences.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class ResetRequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ResetPasswordRequestCubit>(
      create: (context) => ResetPasswordRequestCubit(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body:
              BlocBuilder<ResetPasswordRequestCubit, ResetPasswordRequestState>(
                  builder: (context, state) {
            if (state is ResetPasswordRequestLoading)
              return Column(
                children: [
                  BlueGradientAppBar(
                      TextPair('Forgot Password', 'نسيت كلمة السر')),
                  Expanded(child: Center(child: CircularProgressIndicator())),
                ],
              );
            else if (state is ResetPasswordRequestError)
              return Column(
                children: [
                  BlueGradientAppBar(
                      TextPair('Forgot Password', 'نسيت كلمة السر')),
                  Expanded(child: Center(child: Text("Error"))),
                ],
              );
            else if (state is ResetPasswordRequestSent)
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // getTopContainer(TextPair('Sign up', 'تسجيل دخول')),
                    BlueGradientAppBar(
                        TextPair('Forgot Password', 'نسيت كلمة السر')),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(
                              top: 36.0, left: 16.0, right: 16.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Success, Please Check Your E-Mail",
                                style: titileStyleBlack,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "تمت العملية بنجاح، رجاءً تحقق من بريدك الالكتروني",
                                style: titileStyleBlack,
                                textAlign: TextAlign.center,
                              ),
                              Expanded(
                                child: Image.asset(
                                  "assets/resetSuccess.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                              // SizedBox(height: 16.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Container(
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
                              ),
                            ],
                          )),
                    ),
                  ]);
            else
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BlueGradientAppBar(
                        TextPair('Forgot Password', 'نسيت كلمة السر')),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(
                              top: 36.0, left: 16.0, right: 16.0),
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              Text(
                                "Please Type Your E-Mail to Send a Password Reset Request",
                                style: titileStyleBlack,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "رجاءً اكتب بريدك الالكتروني لإرسال طلب إعادة كلمة السر",
                                style: titileStyleBlack,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16,),
                              BlocBuilder<ResetPasswordRequestCubit,
                                      ResetPasswordRequestState>(
                                  buildWhen: (previous, current) {
                                return current is ResetPasswordRequestInitial ||
                                    current is ResetPasswordRequestEmailError ||
                                    current is ResetPasswordRequestEmailReset;
                              }, builder: (context, state) {
                                return TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    errorText:
                                        state is ResetPasswordRequestEmailError
                                            ? "please enter a correct e-mail"
                                            : null,
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: middleColor),
                                    ),
                                  ),
                                  onTap: () {
                                    var cubit = BlocProvider.of<
                                        ResetPasswordRequestCubit>(context);
                                    cubit
                                        .emit(ResetPasswordRequestEmailReset());
                                  },
                                  onChanged: (value) {
                                    var cubit = BlocProvider.of<
                                        ResetPasswordRequestCubit>(context);
                                    if (EmailValidator.validate(value)) {
                                      print("true");
                                      cubit.email = value;
                                      cubit.emit(
                                          ResetPasswordRequestEmailReset());
                                    } else {
                                      print("false");
                                      cubit.email = value;
                                      cubit.emit(
                                          ResetPasswordRequestEmailError());
                                    }
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
                                  builder: (_, provider, __) => GestureDetector(
                                    onTap: () {
                                      var cubit = BlocProvider.of<
                                          ResetPasswordRequestCubit>(context);
                                      if (cubit.validator()) {
                                        cubit.sendRequest();
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
                  ]);
          })),
    );
  }
}
