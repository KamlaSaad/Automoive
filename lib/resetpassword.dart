import 'package:app/services/auth.dart';
import 'package:app/share.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gradient_text/gradient_text.dart';

import 'package:app/Theme.dart';

class Reset extends StatefulWidget {
  @override
  _ResetState createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  //Authentication
  AuthService _auth = AuthService();
  //State
  String _email = '';
  String _error = '';
  String mailMsg = "";
  String code = "";
  bool loading = false;
  String platformResponse = "";
  Color _ercolor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    setting(media, w, h);
    getMood();
    theme();
    if (Portrait(media)) {
      w = MediaQuery.of(context).size.width;
    } else {
      w = MediaQuery.of(context).size.height;
    }
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bodyColor,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: textColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Portrait(media) ? Body(w, h) : ListView(children: [Body(w, h)]));
  }

  Widget Body(double w, double h) {
    return Container(
      width: w,
      height: h,
      color: bodyColor,
      child: Form(
          key: formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Spacer(),
                Image(
                  image: AssetImage("imgs/logo.png"),
                  height: h * 0.1,
                  width: w * 0.4,
                ),
                //Spacer(),
                GradientText("resetPass".tr(),
                    gradient: LinearGradient(colors: [mainColor2, mainColor1]),
                    style: TextStyle(
                        fontSize: largeFontSize,
                        fontFamily: "Cairo",
                        fontWeight: FontWeight.w500,
                        letterSpacing: -2.6)),
                Spacer(),
                Input(Icons.email, "enterMail", "wrongUser", (value) {
                  if (value.isEmpty) {
                    return "enterMail".tr();
                  } else if (value.isNotEmpty &&
                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.com")
                          .hasMatch(value)) {
                    return null;
                  } else {
                    return "validMail".tr();
                  }
                }, (value) {
                  setState(() {
                    _email = value;
                  });
                }),
                Spacer(),
                //reset button
                ButtonContainer(
                  buttonWidth,
                  buttonHeight,
                  "confirm".tr(),
                  false,
                  [mainColor2, mainColor1],
                  Colors.white,
                  loading,
                  () async {
                    if (formKey.currentState.validate()) {
                      setState(() {
                        loading = true;
                        _error = "";
                      });
                      dynamic result = await _auth.findIfEmailIsExists(_email);
                      if (result) {
                        await _auth.sendPasswordReserEmail(_email);
                        setState(() {
                          loading = false;
                          _error = "sendMail".tr();
                          _ercolor = mainColor1;
                        });
                      } else {
                        setState(() {
                          loading = false;
                          _error = "notExist".tr();
                          _ercolor = Colors.red;
                        });
                      }
                    }
                  },
                ),
                Spacer(),
                Text(
                  _error.tr(),
                  style: TextStyle(color: _ercolor, fontSize: smallFontSize),
                ),
                Spacer(),
                Spacer(),
                Spacer(),
              ])),
    );
  }

  Widget Input(IconData prefix, String hintTxt, String wrong, Function valid,
      Function chan) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: inputMargin),
      child: TextFormField(
        style: TextStyle(color: textColor, fontSize: fontSize),
        decoration: InputDecoration(
          fillColor: boxColor,
          filled: true,
          errorStyle: TextStyle(fontSize: fontSize),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(
            prefix,
            color: mainColor1,
            size: inputIconSize,
          ),
          hintText: hintTxt.tr(),
          hintStyle: TextStyle(color: textColor, fontSize: fontSize),
          contentPadding:
              EdgeInsets.symmetric(vertical: inputPadding, horizontal: 5),
        ),
        onChanged: chan,
        validator: valid,
      ),
    );
  }
}
