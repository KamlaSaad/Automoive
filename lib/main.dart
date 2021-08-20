import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'screens/wrapper.dart';
import 'services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:app/models/custom_user.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'Theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(EasyLocalization(
    child: MyApp(),
    path: "translate",
    saveLocale: true,
    supportedLocales: [
      Locale('en', 'US'),
      Locale('ar', 'DZ'),
      Locale('fr', 'FR'),
    ],
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getThemeH();
    getMood();
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) {
          if (brightness == Brightness.light) {
            return ThemeData(accentColor: Colors.blue);
          } else {
            return ThemeData(accentColor: Colors.blue);
          }
        },
        themedWidgetBuilder: (context, theme) {
          return StreamProvider<CustomUser>.value(
              value: AuthService().user, child: Wrapper());
        });
  }
}
