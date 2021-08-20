import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sideBar.dart';
import 'share.dart';
import 'Theme.dart';

int langVal = 1;

class Language extends StatefulWidget {
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  SharedPreferences pfs;
  void saveLang(int lang) async {
    pfs = await SharedPreferences.getInstance();
    pfs.setInt("langVal", lang);
  }

  getLang() async {
    pfs = await SharedPreferences.getInstance();
    setState(() {
      langVal = pfs.getInt("langVal");
    });
    return langVal;
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width,
        h = MediaQuery.of(context).size.height;
    MediaQueryData media = MediaQuery.of(context);
    getMood();
    theme();
    getLang();
    setting(media, w, h);
    return Scaffold(
        backgroundColor: bodyColor,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: textColor,
              ),
              onPressed: () {
                setState(() {
                  SideIcon = Icons.menu;
                  opened = false;
                });
                Navigator.pop(context);
              }),
          title: Txt("lang".tr(), titleSize, textColor),
          backgroundColor: bodyColor,
        ),
        body: Padding(
            padding: EdgeInsets.only(
              top: Mobile0(media) == "tablet" ? h * 0.02 : 0,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      right: checkLang(context) ? 0 : w * 0.06,
                      left: checkLang(context) ? w * 0.06 : 0),
                  child: Column(
                    children: [
                      RadioIcon("English", 1, Locale('en', 'US')),
                      RadioIcon("Français", 3, Locale('fr', 'FR')),
                      RadioIcon("العربية", 2, Locale('ar', 'DZ')),
                    ],
                  ),
                ),
                SideBar("lang")
              ],
            )));
  }

  Widget RadioIcon(String txt, int val, Locale locale) {
    return ListTile(
      leading: Text(
        txt,
        style: TextStyle(color: textColor, fontSize: fontSize * 0.9),
      ),
      trailing: Radio(
          value: val,
          groupValue: langVal,
          onChanged: (value) {
            setState(() {
              langVal = value;
              EasyLocalization.of(context).locale = locale;
              saveLang(value);
            });
          }),
    );
  }
}
