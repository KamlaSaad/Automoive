import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math';
import 'Theme.dart';
//speedometer
class CircleProgress extends CustomPainter{
  double currentProgress,width;

  CircleProgress(this.currentProgress,this.width);

  @override
  void paint(Canvas canvas, Size size) {

    //this is base circle
    Paint outerCircle = Paint()
      ..strokeWidth = width
      ..color = greyColor
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = width
      ..shader = ui.Gradient.linear(Offset(100,0),Offset(0,40),
        [
          mainColor1,
          mainColor2,
        ],
      )
      ..style = PaintingStyle.stroke
      ..strokeCap  = StrokeCap.round;

    Offset center = Offset(size.width/2, size.height/2);
    double radius = min(size.width/2,size.height/2) - 10;

    canvas.drawCircle(center, radius, outerCircle); // this draws main outer circle

    double angle = 2 * pi * (currentProgress/100);

    canvas.drawArc(Rect.fromCircle(center: center,radius: radius), -pi/2, angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

