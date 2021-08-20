import 'package:app/Login.dart';
import 'package:app/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:app/language.dart';
import 'package:app/Theme.dart';
import 'package:app/resetpassword.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    getThemeH();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
          unselectedWidgetColor:
              switchVal.value == true ? Colors.white : Colors.black),
      routes: {
        'login': (context) => LoginBody(),
        'register': (context) => SignUp(),
        // 'home': (context) => Home(),
        // 'setting': (context) => Setting(),
        'language': (context) => Language(),
        // 'control': (context) => Controls(),
        // 'password': (context) => ChangePass(),
        'reset': (BuildContext context) => Reset(),
      },
      home: Login(),
    );
  }
}
