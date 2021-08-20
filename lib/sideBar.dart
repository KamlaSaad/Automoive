import 'package:app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/services.dart';
import 'share.dart';
import 'Theme.dart';

AuthService _auth = AuthService();

class SideBar extends StatefulWidget {
  String title = "home";
  SideBar(this.title);
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    getMood();
    theme();
    MediaQueryData media = MediaQuery.of(context);
    double w = MediaQuery.of(context).size.width,
        h = MediaQuery.of(context).size.height;
    double width = Portrait(media) ? w * 0.84 : w * 0.55;
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      top: 0,
      bottom: 0,
      left: checkLang(context) ? (opened ? 0 : -width) : (opened ? 0 : width),
      right: checkLang(context) ? (opened ? 0 : width) : (opened ? 0 : -width),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: width,
            height: h,
            //padding: EdgeInsets.symmetric(horizontal: 15),
            color: boxColor,
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                SizedBox(
                  height: Portrait(media) ? 20 : 10,
                ),
                Portrait(media)
                    ? Container(
                        width: w * 0.65,
                        height: h * 0.15,
                        child: Transform.scale(
                          scale: carScale,
                          child: Image(
                            image: AssetImage('imgs/$car.png'),
                            width: w * 0.65,
                            height: h * 0.15,
                          ),
                        ))
                    : SizedBox(
                        height: 0,
                      ),
                Portrait(media)
                    ? Divider(
                        height: h * 0.1,
                        thickness: 0.5,
                        color: smallTxtColor,
                        indent: 32,
                        endIndent: 32,
                      )
                    : SizedBox(
                        height: 0,
                      ),
                ListItem(context, Icons.home, "home"),
                ListItem(context, Icons.directions_car, "control"),
                ListItem(context, Icons.language, "lang"),
                ListTile(
                  leading: Icon(Icons.brightness_3,
                      color: mainColor1, size: iconSize),
                  title: Text("mood".tr(),
                      style: TextStyle(
                          color: textColor,
                          fontSize: fontSize,
                          fontFamily: "Cairo")),
                  trailing: SizedBox(
                    width: switchSize,
                    child: Switch(
                      focusColor: mainColor2,
                      value: themeSwitch != null ? themeSwitch : false,
                      onChanged: (val) {
                        DynamicTheme.of(context).setBrightness(
                            val == true ? Brightness.dark : Brightness.light);
                        setState(() {
                          themeSwitch = val;
                          switchVal.value = val;
                        });
                        saveMood(val);
                        theme();
                        print(val);
                        print(themeSwitch);
                      },
                    ),
                  ),
                ),

                //change password
                ListItem(context, Icons.lock, "chPass"),
                //logout
                ListItem(context, Icons.exit_to_app, "logout")
              ],
            )),
          ),
          Align(
            alignment: Alignment(0, -0.9),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  opened = !opened;
                  SideIcon = opened ? Icons.close : Icons.menu;
                });
                //onIconPressed();
              },
              child: Transform.rotate(
                angle: checkLang(context) ? 0 : 3.12,
                child: ClipPath(
                  clipper: CustomMenuClipper(),
                  child: Container(
                    width: 35,
                    height: 110,
                    color: mainColor1,
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      SideIcon,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ListItem(BuildContext context, IconData icon, String txt) {
    return ListTile(
        selected: txt != widget.title ? false : true,
        selectedTileColor: bodyColor,
        leading: Icon(icon, color: mainColor1, size: iconSize * 1.1),
        title: Txt(txt.tr(), fontSize, textColor),
        onTap: () async {
          if (txt == "logout") {
            await _auth.signOut();
          } else if (txt != widget.title) {
            Navigator.of(context).pushNamed(txt);
          } else {}
          setState(() {
            SideIcon = Icons.menu;
            opened = false;
          });
        });
  }
}
//Widget SideBar(BuildContext context, MediaQueryData media, double w, double h) {
//  double width = w * 0.8;
//  bool opened = true;
//  IconData icon = Icons.menu;
//  ;
//  });
//}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;
    final width = size.width;
    final height = size.height;
    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
