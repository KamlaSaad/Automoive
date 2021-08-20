import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:math';
import 'Theme.dart';

//side menu variables
IconData SideIcon = Icons.menu;
bool opened = false;
bool checkLang(BuildContext contxt) {
  if (EasyLocalization.of(contxt).locale == Locale('ar', 'DZ')) {
    return false;
  } else {
    return true;
  }
}

String Mobile0(MediaQueryData media) {
  Orientation orientation = media.orientation;
  double width = media.size.height;
  if (orientation == Orientation.landscape) {
    width = media.size.height;
  } else {
    width = media.size.width;
  }
  if (width >= 600) {
    return "tablet";
  }
  if (width >= 360) {
    return "mobile";
  } else {
    return "smallMobile";
  }
}

bool Mobile(MediaQueryData media) {
  Orientation orientation = media.orientation;
  double width = media.size.height;
  if (orientation == Orientation.landscape) {
    width = media.size.height;
  } else {
    width = media.size.width;
  }
  if (width >= 600) {
    return false;
  }
  return true;
}

bool Portrait(MediaQueryData media) {
  Orientation orientation = media.orientation;
  return orientation == Orientation.portrait ? true : false;
}

Widget Txt(String txt, double size, Color color) {
  return Text(txt,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontFamily: "Cairo",
          fontWeight: FontWeight.w500));
}

BoxDecoration BoxDec(BorderRadius border) {
  return BoxDecoration(
    color: boxColor,
    borderRadius: border == null ? BorderRadius.circular(10) : border,
    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
  );
}

BorderRadius sideBorder1() {
  return BorderRadius.only(
      topLeft: Radius.circular(30), bottomRight: Radius.circular(30));
}

BorderRadius sideBorder2() {
  return BorderRadius.only(
      topRight: Radius.circular(30), bottomLeft: Radius.circular(30));
}

Widget ButtonContainer(
    double width,
    double height,
    String buttonTxt,
    bool hasBorder,
    List<Color> colors,
    Color btnColor,
    bool loading,
    Function press) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
        border: hasBorder ? Border.all(color: greyColor, width: 1.7) : null,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
        gradient: LinearGradient(colors: colors)),
    child: FlatButton(
        focusColor: boxColor,
        child: loading
            ? CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 3,
              )
            : Text(
                buttonTxt,
                style: TextStyle(color: btnColor, fontSize: fontSize),
              ),
        onPressed: press),
  );
}

Widget showMsg(String txt) {
  return SnackBar(
      backgroundColor: boxColor, content: Txt(txt.tr(), fontSize, textColor));
}

double angle0 = 0,
    top0 = -160,
    topLanscape0 = -180,
    left0 = 0,
    leftLanscape0 = 0;
IconData menu0 = Icons.menu;
closeBtn(double h, double w, BuildContext context) {
  print("close");
  return StatefulBuilder(builder: (context, StateSetter setS) {
    setS(() {
      angle0 = 0;
      if (menu0 == Icons.close) {
        menu0 = Icons.menu;
        top0 = -h * 0.2;
        topLanscape0 = -h * 0.24;
        if (checkLang(context)) {
          left0 = 0;
          leftLanscape0 = 0;
        } else {
          left0 = w * 0.2;
          leftLanscape0 = w * 0.2;
        }
      }
    });
    return null;
  });
}

//responsive
double iconSize,
    fontSize,
    parkIconSize,
    largeFontSize,
    smallFontSize,
    switchSize,
    inputTxt,
    inputIconSize,
    controlIconSize,
    titleSize,
    carBlackScale,
    carWhiteScale,
    buttonWidth,
    buttonHeight,
    faceBoxHeight,
    passBoxHeight,
    passIcon,
    inputPadding,
    inputMargin,
    homeBoxHeight,
    homeBoxWidth,
    batterySize,
    batteryRatio,
    batteryTopH,
    batteryTopW,
    tempScale,
    tempSpacer,
    sideWidth,
    sideHeight,
    speedoSize,
    menuScale = 1,
    carScale;
void setting(MediaQueryData media, double w, double h) {
  if (Portrait(media)) {
    homeBoxWidth = w * 0.44;
    batteryTopH = h * 0.025;
    batteryTopW = w * 0.046;
    batterySize = w * 0.15;
    passIcon = w * 0.2;
    passBoxHeight = h * 0.4;
    faceBoxHeight = h * 0.6;
    inputMargin = w * 0.09;
    inputTxt = w * 0.045;
    buttonWidth = w * 0.82;
    tempScale = w * 0.01 / 2;
    tempSpacer = w * 0.07;
    speedoSize = w * 0.28;
    iconSize = w * 0.066;
    parkIconSize = w * 0.1;
    controlIconSize = w * 0.16;
    if (Mobile0(media) == "mobile") {
      //"mobile portrait"
      sideWidth = w * 0.65;
      sideHeight = h * 0.13;
      homeBoxWidth = w * 0.455;
      homeBoxHeight = h * 0.28;
      batteryTopH = h * 0.023;
      batteryRatio = h * 0.005 / 2.4;
      tempScale = w * 0.01 / 1.8;
      inputIconSize = w * 0.06;
      fontSize = w * 0.055;
      smallFontSize = w * 0.044;
      largeFontSize = w * 0.11;
      switchSize = w * 0.15;
      titleSize = w * 0.055;
      buttonHeight = h * 0.065;
      inputPadding = h * 0.01;
      passBoxHeight = h * 0.4;
      parkIconSize = w * 0.11;
      passIcon = w * 0.22;
      speedoSize = w * 0.3;
      carScale = w * 0.0025;
    } else if (Mobile0(media) == "smallMobile") {
      //"small mobile portrait"
      menuScale = 0.68;
      homeBoxWidth = w * 0.45;
      homeBoxHeight = h * 0.26;
      sideWidth = w * 0.9;
      sideHeight = h * 0.2;
      batteryRatio = h * 0.005 / 1.7;
      inputIconSize = w * 0.065;
      fontSize = w * 0.054;
      smallFontSize = w * 0.052;
      largeFontSize = w * 0.11;
      switchSize = w * 0.18;
      titleSize = w * 0.06;
      speedoSize = w * 0.32;
      buttonHeight = h * 0.08;
      faceBoxHeight = h * 0.6;
      inputPadding = 0;
      carScale = w * 0.0035;
      passIcon = w * 0.25;
      passBoxHeight = h * 0.6;
      tempScale = w * 0.01 / 1.5;
    } else if (Mobile0(media) == "tablet") {
      //tablet portrait"
      menuScale = 1.06;
      sideWidth = w * 0.4;
      sideHeight = h * 0.1;
      homeBoxWidth = w * 0.42;
      homeBoxHeight = h * 0.3;
      batteryTopH = h * 0.028;
      batteryTopW = w * 0.05;
      batterySize = w * 0.14;
      batteryRatio = h * 0.00115;
      tempScale = h * 0.0021;
      tempSpacer = w * 0.06;
      speedoSize = w * 0.26;
      iconSize = w * 0.045;
      parkIconSize = w * 0.09;
      controlIconSize = w * 0.11;
      inputIconSize = w * 0.04;
      fontSize = w * 0.04;
      smallFontSize = w * 0.032;
      largeFontSize = w * 0.076;
      inputTxt = w * 0.03;
      switchSize = w * 0.09;
      titleSize = w * 0.04;
      buttonWidth = w * 0.8;
      buttonHeight = h * 0.065;
      passIcon = w * 0.15;
      passBoxHeight = h * 0.35;
      faceBoxHeight = h * 0.75;
      inputMargin = w * 0.095;
      inputPadding = h * 0.013;
      carScale = w * 0.001;
    }
  } else {
    homeBoxHeight = h * 0.42;
    batteryTopH = h * 0.045;
    batteryTopW = w * 0.028;
    batterySize = w * 0.08;
    tempScale = h * 0.01 / 2.1;
    tempSpacer = w * 0.022;
    iconSize = w * 0.045;
    parkIconSize = w * 0.06;
    controlIconSize = w * 0.08;
    inputIconSize = w * 0.035;
    fontSize = w * 0.03;
    smallFontSize = w * 0.02;
    largeFontSize = w * 0.05;
    inputTxt = w * 0.03;
    switchSize = w * 0.09;
    titleSize = w * 0.035;
    passIcon = w * 0.15;
    passBoxHeight = h * 0.75;
    faceBoxHeight = h * 0.75;
    inputMargin = w * 0.185;
    inputPadding = h * 0.01;
    carScale = w * 0.002;
    if (Mobile0(media) == "mobile") {
      //mobile landscape"
      sideWidth = w * 0.4;
      sideHeight = h * 0.24;
      batteryRatio = h * 0.005 / 1.44;
      homeBoxHeight = h * 0.45;
      homeBoxWidth = w * 0.22;
      speedoSize = w * 0.15;
      buttonWidth = w * 0.63;
      buttonHeight = h * 0.11;
      parkIconSize = w * 0.07;
      passIcon = w * 0.13;
      smallFontSize = w * 0.025;
      carScale = w * 0.0016;
      controlIconSize = w * 0.1;
    }
    if (Mobile0(media) == "smallMobile") {
      //small mobile landscape"
      menuScale = 0.8;
      sideWidth = w * 0.5;
      sideHeight = h * 0.26;
      homeBoxWidth = w * 0.23;
      batteryRatio = h * 0.005 / 1.1;
      speedoSize = w * 0.18;
      smallFontSize = w * 0.03;
      buttonWidth = w * 0.62;
      buttonHeight = h * 0.13;
      switchSize = w * 0.11;
      passBoxHeight = h * 0.9;
      controlIconSize = w * 0.1;
      carScale = w * 0.0023;
      tempScale = h * 0.01 / 1.6;
    } else if (Mobile0(media) == "tablet") {
      //tablet landscape"
      sideWidth = w * 0.31;
      sideHeight = h * 0.18;
      homeBoxWidth = w * 0.23;
      batteryTopH = h * 0.038;
      batteryTopW = w * 0.034;
      batteryRatio = h * 0.005 / 2.8;
      tempScale = w * 0.00165;
      tempSpacer = w * 0.026;
      speedoSize = w * 0.16;
      iconSize = w * 0.035;
      parkIconSize = w * 0.065;
      controlIconSize = w * 0.1;
      inputIconSize = w * 0.03;
      fontSize = w * 0.025;
      smallFontSize = w * 0.025;
      largeFontSize = w * 0.076;
      inputTxt = w * 0.022;
      switchSize = w * 0.06;
      titleSize = w * 0.03;
      buttonWidth = w * 0.62;
      buttonHeight = h * 0.09;
      passIcon = w * 0.13;
      passBoxHeight = h * 0.6;
      faceBoxHeight = h * 0.6;
      inputMargin = w * 0.19;
      inputPadding = h * 0.022;
      carScale = w * 0.0008;
    }
  }
}
