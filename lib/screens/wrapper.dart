import 'package:app/models/custom_user.dart';
import 'package:app/screens/Authentication.dart';
import 'package:flutter/material.dart';
import 'package:app/home.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:app/language.dart';
import 'package:app/Controls.dart';
import 'package:app/changePass.dart';
import '../Theme.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);
    print('User : ' + user.toString());
    if (user == null) {
      return ();
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
            unselectedWidgetColor:
                switchVal.value == true ? Colors.white : Colors.black),
        routes: {
          // 'login': (context) => LoginBody(),
          // 'register': (context) => SignUp(),
          'home': (context) => Home(),
          'lang': (context) => Language(),
          'control': (context) => Controls(),
          'chPass': (context) => ChangePass(),
          // 'reset': (BuildContext context) => Reset(),
        },
        home: Home(),
      );
    }
  }
}
