import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:app/paint.dart';
import 'package:app/BatteryInd.dart';
import 'sideBar.dart';
import 'package:app/battery.dart';
import 'package:app/share.dart';
import 'package:app/Theme.dart';
import 'dart:async';

String translateNum(arVal, enVal, BuildContext contxt) {
  if (EasyLocalization.of(contxt).locale == Locale('ar', 'DZ')) {
    return arVal;
  } else {
    return enVal;
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var appBar;
  int batteryLv = 60, temperature = 21, speed = 230, consumption = 7;

  final battery = Battery();
  Timer timer;

  @override
  void initState() {
    super.initState();
    listenBatteryLevel();
  }

  void listenBatteryLevel() {
    updateBatteryLevel();
    Timer(Duration(seconds: 15), () async => updateBatteryLevel());
  }

  Future updateBatteryLevel() async {
    final batteryLevel = await battery.batteryLevel;
    setState(() => batteryLv = batteryLevel);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    double w = MediaQuery.of(context).size.width,
        h = MediaQuery.of(context).size.height;
    getMood();
    theme();
    setting(media, w, h);
    return Scaffold(
        //backgroundColor: bodyColor,
        appBar: AppBar(
            backgroundColor: bodyColor,
            leading: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Image(image: AssetImage('imgs/logo.png')),
            ),
            title: Txt(
              "logo".tr(),
              titleSize,
              textColor,
            )),
        body: Container(
          width: w,
          height: h,
          color: bodyColor,
          child: Stack(children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Center(
                    child: Container(
                        //padding: EdgeInsets.only(top: w * 0.01),
                        width: w * 0.8,
                        height: h * 0.2,
                        child: Transform.scale(
                          scale: carScale,
                          child: Image(
                            image: AssetImage('imgs/$car.png'),
                            width: w * 0.8,
                            height: h * 0.2,
                          ),
                        )),
                  ),
                  //Spacer(),
                  Portrait(media)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //battery
                                BatteryBox(context, media, w, h),
                                //temperature
                                TempBox(media, context, w),
                              ],
                            ),
                            SizedBox(
                              height: h * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //consumption
                                Speedometer(
                                    "consum",
                                    translateNum(
                                        "$consumption".toPersianDigit(),
                                        "$consumption",
                                        context),
                                    "km".tr(),
                                    100,
                                    Mobile(media) ? 12 : 25,
                                    homeBoxWidth * 0.75,
                                    BoxDec(sideBorder1())),
                                //speed
                                Speedometer(
                                    "speed",
                                    translateNum("$speed".toPersianDigit(),
                                        "$speed", context),
                                    "km/h".tr(),
                                    60,
                                    Mobile(media) ? 12 : 25,
                                    homeBoxWidth * 0.75,
                                    BoxDec(sideBorder2())),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //battery
                            BatteryBox(context, media, w, h),
                            //temperature
                            TempBox(media, context, w),
                            //consumption
                            Speedometer(
                                "consum",
                                translateNum("$consumption".toPersianDigit(),
                                    "$consumption", context),
                                "km".tr(),
                                100,
                                Mobile(media) ? 12 : 25,
                                homeBoxWidth * 0.8,
                                BoxDec(sideBorder1())),
                            //speed
                            Speedometer(
                                "speed",
                                translateNum("$speed".toPersianDigit(),
                                    "$speed", context),
                                "km/h".tr(),
                                60,
                                Mobile(media) ? 12 : 25,
                                homeBoxWidth * 0.8,
                                BoxDec(sideBorder2())),
                          ],
                        ),
                ]),
            SideBar("home")
          ]),
        ));
  }

  Widget BatteryBox(
      BuildContext contxt, MediaQueryData media, double w, double h) {
    return Container(
        width: homeBoxWidth,
        height: homeBoxHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Txt("battery".tr(), fontSize * 0.93, textColor),
            Padding(
              padding: EdgeInsets.only(
                  top: Portrait(media) ? w * 0.05 : 0,
                  left: checkLang(contxt) ? 0 : w * 0.04,
                  right: checkLang(contxt) ? w * 0.011 : 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            bottom: h * 0.02, right: w * 0.01 / 2),
                        width: batteryTopW,
                        height: batteryTopH,
                        decoration: BoxDecoration(
                          color: batteryLv == 100
                              ? mainColor1
                              : Colors.transparent,
                          border:
                              Border.all(width: 1.4, color: Color(0xaaaaaaaa)),
                        ),
                      ),
                      Transform.rotate(
                          angle: 300.01,
                          child: Container(
                            child: BatteryIndicator(
                              batteryLv: batteryLv,
                              style: BatteryIndicatorStyle.values[0],
                              colorful: false,
                              showPercentNum: true,
                              mainColor: mainColor1,
                              size: batterySize,
                              ratio: batteryRatio,
                              showPercentSlide: true,
                            ),
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      Txt(
                          translateNum("%$batteryLv".toPersianDigit(),
                              "$batteryLv%", context),
                          fontSize,
                          textColor),
                      SizedBox(
                        height: 10,
                      ),
                      Txt("charge".tr(), smallFontSize * 0.9, smallTxtColor),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
        decoration: BoxDec(sideBorder2()));
  }

  Widget TempBox(MediaQueryData media, BuildContext contxt, double w) {
    return Container(
        width: homeBoxWidth,
        height: homeBoxHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Txt("temp".tr(), fontSize * 0.93, textColor),
            Padding(
              padding: EdgeInsets.only(
                  left: checkLang(contxt) ? w * 0.045 : 0,
                  right: checkLang(contxt) ? 0 : w * 0.025),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: tempScale,
                    child: GradientText(
                        translateNum("$temperature".toPersianDigit(),
                            "$temperature", context),
                        gradient: LinearGradient(colors: [
                          mainColor2,
                          mainColor1,
                        ]),
                        style: TextStyle(
                            fontSize:
                                Mobile(media) ? fontSize * 2.5 : fontSize * 3.3,
                            fontFamily: "Cairo",
                            fontWeight: FontWeight.w600,
                            letterSpacing: Mobile(media) ? -5 : -10)),
                  ),
                  SizedBox(
                    width: tempSpacer / 1.2,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.scale(
                          scale: tempScale / 1.6,
                          child: Txt(
                              "°".tr(),
                              Mobile(media) ? fontSize * 2.4 : fontSize * 3,
                              checkLang(context) ? mainColor1 : mainColor2)),
                      Transform.translate(
                        offset: Offset(0, -w * 0.04),
                        child: Transform.scale(
                            scale: tempScale / 1.4,
                            child: Txt(
                                translateNum("س", "C", contxt),
                                checkLang(contxt)
                                    ? smallFontSize * 0.9
                                    : smallFontSize * 0.75,
                                smallTxtColor)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDec(sideBorder1()));
  }

  Widget Speedometer(String txt, String val, String unit, double value,
      double width, double size, Decoration border) {
    return Container(
        width: homeBoxWidth,
        height: homeBoxHeight,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: txt.tr(),
                style: TextStyle(
                    fontFamily: "Cairo",
                    fontSize:
                        txt == "speed" ? fontSize * 0.95 : fontSize * 0.85,
                    color: textColor)),
          ),
          CustomPaint(
              foregroundPainter: CircleProgress(value, width),
              child: Container(
                padding: EdgeInsets.only(top: 5, bottom: 10),
                width: speedoSize,
                height: speedoSize,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 7,
                    ),
                    Txt(val, fontSize * 1.3, textColor),
                    Transform.translate(
                      child: Txt(unit, smallFontSize * 0.95, smallTxtColor),
                      offset: Offset(0, -8),
                    ),
                  ],
                ),
              ))
        ]),
        decoration: border);
  }
}
