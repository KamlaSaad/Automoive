import 'package:app/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'sideBar.dart';
import 'share.dart';
import 'Theme.dart';

bool show1 = true, show2 = true;

class ChangePass extends StatefulWidget {
  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  //Authentication
  AuthService _auth = AuthService();
  //State
  String _newPass = '';
  String _oldPass = '';
  String _error = '';
  bool loading = false;
  Color _ercolor = Colors.red;
  var inputC1 = TextEditingController(), inputC2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    Size s = MediaQuery.of(context).size;
    double w = s.width, h = s.height;
    getMood();
    theme();
    setting(media, w, h);
    return Scaffold(
        key: scaffoldKey,
        //resizeToAvoidBottomPadding: false,
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
            title: Txt("chPass".tr(), titleSize, textColor),
            backgroundColor: bodyColor),
        body: Portrait(media)
            ? Stack(
                children: [Body(media, w, h), SideBar("chPass")],
              )
            : Stack(
                children: [
                  ListView(
                    children: [Body(media, w, h)],
                  ),
                  SideBar("chPass")
                ],
              ));
  }

  Widget Body(MediaQueryData media, double w, double h) {
    return Container(
      width: w,
      height: h,
      color: bodyColor,
      child: Center(
        child: Container(
          width: Portrait(media) ? buttonWidth : buttonWidth * 1.2,
          height: passBoxHeight,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: boxColor.withOpacity(0.8),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Transform.translate(
                    offset: Offset(0, -passIcon / 2),
                    child: Container(
                      width: passIcon,
                      height: passIcon,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: textColor,
                      ),
                      decoration: BoxDecoration(
                          color: boxColor,
                          boxShadow: [
                            BoxShadow(color: Colors.black38, blurRadius: 3)
                          ],
                          borderRadius: BorderRadius.circular(passIcon * 0.5)),
                    )),
                //new pass
                Input(
                  inputC2,
                  show2,
                  "nPass".tr(),
                  Icons.lock,
                  IconButton(
                    icon: Icon(
                      show2 ? Icons.visibility : Icons.visibility_off,
                      color: textColor,
                      size: inputIconSize,
                    ),
                    onPressed: () {
                      setState(() {
                        show2 = !show2;
                      });
                    },
                  ),
                  (value) {
                    setState(() => _newPass = value);
                  },
                  (value) {
                    if (value.isEmpty) {
                      return "enterPass".tr();
                    } else if (value.length < 8) {
                      return "passLength".tr();
                    }
                    return null;
                  },
                ),
                Spacer(),
                ButtonContainer(
                    buttonWidth * 0.9,
                    buttonHeight * 0.95,
                    "confirm".tr(),
                    false,
                    [mainColor2, mainColor1],
                    Colors.white,
                    loading, () async {
                  if (formKey.currentState.validate()) {
                    setState(() {
                      loading = true;
                      _error = "";
                    });
                    dynamic result =
                        await _auth.changeCurrentUserPassword(_newPass);

                    if (result == null) {
                      setState(() {
                        _error = "updateSuccess".tr();
                        loading = false;
                        _ercolor = mainColor1;
                        inputC1.clear();
                        inputC2.clear();
                      });
                    } else {
                      setState(() {
                        loading = false;
                        _error = "updateFailed".tr();
                      });
                    }
                  }
                }),
                Spacer(),
                Text(
                  _error.tr(),
                  style: TextStyle(
                      color: _ercolor,
                      fontSize: smallFontSize,
                      fontWeight: FontWeight.bold),
                ),

                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget Input(controller, bool secure, String hintTxt, IconData prefix,
      Widget suffix, Function chang, Function validate) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: inputMargin * 0.26),
      child: TextFormField(
          controller: controller,
          obscureText: secure,
          style: TextStyle(color: textColor, fontSize: inputTxt),
          decoration: InputDecoration(
              fillColor: boxColor,
              filled: true,
              errorStyle: TextStyle(fontSize: inputTxt * 0.6),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: inputPadding, horizontal: 5),
              prefixIcon: Icon(
                prefix,
                color: Colors.blue,
                size: inputIconSize,
              ),
              hintText: hintTxt.tr(),
              hintStyle: TextStyle(color: textColor, fontSize: inputTxt),
              suffixIcon: suffix),
          onChanged: chang,
          validator: validate),
    );
  }
}
