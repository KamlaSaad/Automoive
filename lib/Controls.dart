import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'sideBar.dart';
import 'side.dart';
import 'joystick.dart';
import 'share.dart';
import 'Theme.dart';

Color fColor = textColor, kColor = textColor, wColor = textColor;

class Controls extends StatefulWidget {
  @override
  _ControlsState createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  bool parkLeftClicked = false,
      parkRightClicked = false,
      move = false,
      flash = false,
      wait = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  flashColorFun() {
    flashColor = flash ? mainColor1 : textColor;
    klaxonColor = textColor;
    waitColor = textColor;
  }

  waitColorFun() {
    waitColor = waitColor == mainColor1 ? textColor : mainColor1;
    flashColor = textColor;
    klaxonColor = textColor;
  }

  klaxonColorFun(bool on) {
    kColor = on == true ? mainColor1 : textColor;
    fColor = textColor;
    wColor = textColor;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    double w = MediaQuery.of(context).size.width,
        h = MediaQuery.of(context).size.height;
    getMood();
    theme();
    setting(media, w, h);
    //joystick method
    JoystickDirectionCallback onDirectionChanged(
        double degrees, double distance) {
      print('degree $degrees');
      print('distance $distance');
    }

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Txt("control".tr(), titleSize, textColor),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: textColor,
              size: iconSize,
            ),
            onPressed: () {
              setState(() {
                SideIcon = Icons.menu;
                opened = false;
              });
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: bodyColor,
        ),
        body: Stack(children: [
          Container(
              width: w,
              height: h,
              color: bodyColor,
              child: Portrait(media)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Spacer(),
                            Spacer(),
                            parkLeft(context),
                            Spacer(),
//                              FaIcon(
//                                FontAwesomeIcons.parking,
//                                color: textColor == Colors.black
//                                    ? Colors.black54
//                                    : textColor,
//                                size: parkIconSize * 1.2,
//                              ),
                            Text(
                              "parking".tr(),
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: largeFontSize * 0.9,
                                  fontWeight: FontWeight.w600),
                            ),
                            Spacer(),
                            parkRight(context),
                            Spacer(),
                            Spacer(),
                            Spacer(),
                          ],
                        ),
                        Spacer(),
                        //Joystick
//                        JoystickView(
//                          onDirectionChanged: onDirectionChanged,
//                        ),
                        Directions(context, w * 0.5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            myIcon(FontAwesomeIcons.flask, "flash", fColor, w,
                                () {
                              flashFun();
                            }),
                            Padding(
                                padding: EdgeInsets.only(top: h * 0.15),
                                child: myIcon(FontAwesomeIcons.bullhorn,
                                    "klaxon", kColor, w, () async {
                                  setState(() {
                                    klaxonColorFun(true);
                                  });
                                  Timer(Duration(seconds: 1), () {
                                    klaxonFun();
                                    setState(() {
                                      klaxonColorFun(false);
                                    });
                                  });
                                })),
                            myIcon(
                                FontAwesomeIcons.lightbulb, "wait", wColor, w,
                                () {
                              waitFun();
                            }),
                          ],
                        ),
                        Spacer(),
                        ButtonContainer(
                            buttonWidth,
                            buttonHeight,
                            "getCar".tr(),
                            false,
                            [boxColor, boxColor],
                            textColor,
                            false, () {
                          getCarFun();
                        }),
                        Spacer(),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                myIcon(
                                    FontAwesomeIcons.flask, "flash", fColor, w,
                                    () {
                                  flashFun();
                                }),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: h * 0.3,
                                      left: w * 0.03,
                                      right: w * 0.03),
                                  child: myIcon(FontAwesomeIcons.bullhorn,
                                      "klaxon", kColor, w, () {
                                    setState(() {
                                      klaxonColorFun(true);
                                    });
                                    Timer(Duration(seconds: 1), () {
                                      klaxonFun();
                                      setState(() {
                                        klaxonColorFun(false);
                                      });
                                    });
                                  }),
                                ),
                                myIcon(FontAwesomeIcons.lightbulb, "wait",
                                    wColor, w, () {
                                  waitFun();
                                }),
                              ],
                            ),
                            getCarButton()
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                parkLeft(context),
                                Text(
                                  "parking".tr(),
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: largeFontSize,
                                      fontWeight: FontWeight.w600),
                                ),
                                parkRight(context),
                              ],
                            ),
//                            JoystickView(
//                              onDirectionChanged: onDirectionChanged,
//                            ),
                            Directions(context, w * 0.3)
                          ],
                        )
                      ],
                    )),
          SideBar("control")
        ]));
  }

  //message
  Widget msg() {
    return SnackBar(
      content: Txt("carParked".tr(), 20, textColor),
      backgroundColor: boxColor,
    );
  }

  Widget getCarButton() {
    return ButtonContainer(buttonWidth * 0.85, buttonHeight * 1.1,
        "getCar".tr(), false, [boxColor, boxColor], textColor, false, () {
      getCarFun();
    });
  }

  //parking icon
  Widget parkIcon(IconData icon, Function press) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GestureDetector(
          child: FaIcon(
            icon,
            color: textColor == Colors.black ? Colors.black54 : textColor,
            size: parkIconSize,
          ),
          onTap: press),
    );
  }

  Widget parkLeft(BuildContext context) {
    if (!checkLang(context)) {
      return parkIcon(FontAwesomeIcons.solidArrowAltCircleRight, () {
        if (parkRightClicked == false) {
          parkRightFun();
        } else {
          scaffoldKey.currentState.showSnackBar(msg());
        }
      });
    } else {
      return parkIcon(FontAwesomeIcons.solidArrowAltCircleLeft, () {
        if (parkLeftClicked == false) {
          parkLeftFun();
        } else {
          scaffoldKey.currentState.showSnackBar(msg());
        }
      });
    }
  }

  Widget parkRight(BuildContext context) {
    if (!checkLang(context)) {
      return parkIcon(FontAwesomeIcons.solidArrowAltCircleLeft, () {
        if (parkLeftClicked == false) {
          parkLeftFun();
        } else {
          scaffoldKey.currentState.showSnackBar(msg());
        }
      });
    } else {
      return parkIcon(FontAwesomeIcons.solidArrowAltCircleRight, () {
        if (parkRightClicked == false) {
          parkRightFun();
        } else {
          scaffoldKey.currentState.showSnackBar(msg());
        }
      });
    }
  }

  Widget Arrow(IconData icon, Function press) {
    return IconButton(
      icon: Icon(
        icon,
        color: textColor,
        size: fontSize,
      ),
      onPressed: press,
    );
  }

  Widget Directions(BuildContext context, double w) {
    return Container(
        width: w,
        height: w,
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(w / 2),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
        ),
        child: Center(
            child: Column(children: [
          Arrow(Icons.arrow_upward, () {
            moveTopFun();
          }),
          Row(
            children: [
              checkLang(context)
                  ? Arrow(Icons.arrow_back_outlined, () {
                      moveLeftFun();
                    })
                  : Arrow(Icons.arrow_forward_sharp, () {
                      moveRightFun();
                    }),
              Container(
                width: w * 0.52,
                height: w * 0.52,
                decoration: BoxDecoration(
                  color: bodyColor,
                  borderRadius: BorderRadius.circular(w * 0.26),
                ),
                child: FlatButton(
                  child: null,
                  onPressed: () {
                    stopMovingFun();
                  },
                ),
              ),
              checkLang(context)
                  ? Arrow(Icons.arrow_forward_sharp, () {
                      moveLeftFun();
                    })
                  : Arrow(Icons.arrow_back_outlined, () {
                      moveRightFun();
                    }),
            ],
          ),
          Arrow(Icons.arrow_downward, () {
            moveDownFun();
          }),
        ])));
  }

  Widget myIcon(
      IconData icon, String txt, Color color, double w, Function press) {
    return Column(
      children: [
        Container(
            width: controlIconSize,
            height: controlIconSize,
            child: Center(
              child: IconButton(
                icon: FaIcon(
                  icon,
                  color: color,
                  size: iconSize * 0.8,
                ),
                onPressed: press,
              ),
            ),
            decoration: BoxDecoration(
              color: boxColor,
              borderRadius:
                  BorderRadius.all(Radius.circular(controlIconSize / 2)),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
            )),
        Txt(txt.tr(), inputTxt, textColor)
      ],
    );
  }

//========backend=============

  //parking methods
  void parkLeftFun() {
    //some backend code
    print("parking left");
    parkLeftClicked = true;
  }

  void parkRightFun() {
    //some backend code
    print("parking right");
    parkRightClicked = true;
  }

  //move methods
  void moveTopFun() {
    //some backend code
    print("move Up");
  }

  void moveDownFun() {
    //some backend code
    print("move Down");
  }

  void moveLeftFun() {
    //some backend code
    print("move left");
  }

  void moveRightFun() {
    //some backend code
    print("move right");
  }

  void stopMovingFun() {
    //some backend code
    print("cat has been stopped");
  }

  void flashFun() {
    flash = !flash;
    setState(() {
      fColor = (flash || fColor == textColor) ? mainColor1 : textColor;
      waitColor = textColor;
    });
    //flash on
    if (fColor == mainColor1) {
      print("flash on");
    }
    //flash on
    else {
      print("flash off");
    }
  }

  void klaxonFun() {
    print("klaxon");
  }

  void waitFun() {
    wait = !wait;
    setState(() {
      wColor = (wait || wColor == textColor) ? mainColor1 : textColor;
      fColor = textColor;
    });
    //backend code
    //wait on
    if (wColor == mainColor1) {
      print("wait on");
    }
    //wait off
    else {
      print("wait off");
    }
  }

  void getCarFun() {
    print("get car");
  }
}
