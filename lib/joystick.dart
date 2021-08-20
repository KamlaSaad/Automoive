import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:collection';
import 'dart:ui';
import 'dart:math' as _math;
import 'share.dart';
import 'Theme.dart';

Color iconColor = Colors.white;
enum Gestures {
  TAPDOWN,
  TAPUP,
  TAPCANCEL,
  TAP,
  LONGPRESS,
  LONGPRESSSTART,
  LONGPRESSUP,
}

class PadButtonItem {
  final int index;
  final String buttonText;
  final Image buttonImage;
  final Icon buttonIcon;
  final Color backgroundColor;
  final Color pressedColor;
  final List<Gestures> supportedGestures;

  const PadButtonItem({
    @required this.index,
    this.buttonText,
    this.buttonImage,
    this.buttonIcon,
    this.backgroundColor = Colors.white54,
    this.pressedColor = Colors.lightBlueAccent,
    this.supportedGestures = const [Gestures.TAP],
  }) : assert(index != null);
}

class CircleView extends StatelessWidget {
  final double size;
  final Color color;
  final List<BoxShadow> boxShadow;
  final Border border;
  final double opacity;
  final Image buttonImage;
  final Icon buttonIcon;
  final String buttonText;

  CircleView({
    this.size,
    this.color = Colors.transparent,
    this.boxShadow,
    this.border,
    this.opacity,
    this.buttonImage,
    this.buttonIcon,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Center(
        child: buttonIcon != null
            ? buttonIcon
            : (buttonImage != null)
                ? buttonImage
                : (buttonText != null)
                    ? Text(buttonText)
                    : null,
      ),
      decoration: BoxDecoration(
        color: textColor == Colors.white ? boxColor2 : boxColor,
        shape: BoxShape.circle,
        border: border,
        boxShadow: boxShadow,
      ),
    );
  }

  factory CircleView.joystickCircle(double size, Color color) => CircleView(
        size: size,
        color: boxColor,
        border: Border.all(
          color: boxColor,
          width: 4.0,
          style: BorderStyle.solid,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 5.0,
            blurRadius: 5.0,
          )
        ],
      );

  factory CircleView.joystickInnerCircle(double size, Color color) =>
      CircleView(
        size: size,
        color: boxColor,
        border: Border.all(
          color: Colors.black12,
          width: 2.0,
          style: BorderStyle.solid,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 5.0,
            blurRadius: 5.0,
          )
        ],
      );

  factory CircleView.padBackgroundCircle(
          double size, Color backgroundColour, borderColor, Color shadowColor,
          {double opacity}) =>
      CircleView(
        size: size,
        color: boxColor,
        opacity: opacity,
        border: Border.all(
          color: borderColor,
          width: 4.0,
          style: BorderStyle.solid,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 5.0,
            blurRadius: 5.0,
          )
        ],
      );

  factory CircleView.padButtonCircle(
    double size,
    Color color,
    Image image,
    Icon icon,
    String text,
  ) =>
      CircleView(
        size: size,
        color: textColor,
        buttonImage: image,
        buttonIcon: icon,
        buttonText: text,
        border: Border.all(
          color: textColor == Colors.white ? Colors.black26 : Colors.black12,
          width: 2.0,
          style: BorderStyle.solid,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 8.0,
            blurRadius: 8.0,
          )
        ],
      );
}

typedef JoystickDirectionCallback = void Function(
    double degrees, double distance);

class JoystickView extends StatelessWidget {
  final double size;
  final Color iconsColor;
  final Color backgroundColor;
  final Color innerCircleColor;
  final double opacity;
  final JoystickDirectionCallback onDirectionChanged;

  final Duration interval;
  final bool showArrows;

  JoystickView(
      {this.size,
      this.iconsColor = Colors.white54,
      this.backgroundColor = Colors.blueGrey,
      this.innerCircleColor = Colors.blueGrey,
      this.opacity,
      this.onDirectionChanged,
      this.interval,
      this.showArrows = true});

  @override
  Widget build(BuildContext context) {
    double actualSize = size != null
        ? size
        : _math.min(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height) *
            0.5;
    double innerCircleSize = actualSize / 2;
    Offset lastPosition = Offset(innerCircleSize, innerCircleSize);
    Offset joystickInnerPosition = _calculatePositionOfInnerCircle(
        lastPosition, innerCircleSize, actualSize, Offset(0, 0));

    DateTime _callbackTimestamp;

    return Center(
      child: StatefulBuilder(
        builder: (context, setState) {
          Widget joystick = Stack(
            children: <Widget>[
              CircleView.joystickCircle(
                actualSize,
                backgroundColor,
              ),
              Positioned(
                child: CircleView.joystickInnerCircle(
                  actualSize / 2,
                  innerCircleColor,
                ),
                top: joystickInnerPosition.dy,
                left: joystickInnerPosition.dx,
              ),
              if (showArrows) ...createArrows(context),
            ],
          );

          return GestureDetector(
            onPanStart: (details) {
              _callbackTimestamp = _processGesture(actualSize, actualSize / 2,
                  details.localPosition, _callbackTimestamp);
              setState(() => lastPosition = details.localPosition);
            },
//            onPanEnd: (details) {
//              _callbackTimestamp = null;
////              if (onDirectionChanged != null) {
////                onDirectionChanged(0, 0);
////              }
//              joystickInnerPosition = _calculatePositionOfInnerCircle(
//                Offset(innerCircleSize, innerCircleSize),
//                innerCircleSize,
//                actualSize,
//                Offset(innerCircleSize, innerCircleSize),
//                //Offset(0, 0),
//              );
//              setState(() =>
//                  lastPosition = Offset(innerCircleSize, innerCircleSize));
//            },
            onPanUpdate: (details) {
              _callbackTimestamp = _processGesture(actualSize, actualSize / 2,
                  details.localPosition, _callbackTimestamp);
              joystickInnerPosition = _calculatePositionOfInnerCircle(
                  lastPosition,
                  innerCircleSize,
                  actualSize,
                  details.localPosition);

              setState(() => lastPosition = details.localPosition);
            },
            child: (opacity != null)
                ? Opacity(opacity: opacity, child: joystick)
                : joystick,
          );
        },
      ),
    );
  }

  List<Widget> createArrows(BuildContext context) {
    return [
      Positioned(
        child: Icon(
          Icons.arrow_upward,
          color: textColor,
        ),
        top: 16.0,
        left: 0.0,
        right: 0.0,
      ),
      Positioned(
        child: Icon(
          checkLang(context) ? Icons.arrow_back : Icons.arrow_forward,
          color: textColor,
        ),
        top: 0.0,
        bottom: 0.0,
        left: 16.0,
      ),
      Positioned(
        child: Icon(
          checkLang(context) ? Icons.arrow_forward : Icons.arrow_back,
          color: textColor,
        ),
        top: 0.0,
        bottom: 0.0,
        right: 16.0,
      ),
      Positioned(
        child: Icon(
          Icons.arrow_downward,
          color: textColor,
        ),
        bottom: 16.0,
        left: 0.0,
        right: 0.0,
      ),
    ];
  }

  DateTime _processGesture(double size, double ignoreSize, Offset offset,
      DateTime callbackTimestamp) {
    double middle = size / 2.0;

    double angle = _math.atan2(offset.dy - middle, offset.dx - middle);
    double degrees = angle * 180 / _math.pi + 90;
    if (offset.dx < middle && offset.dy < middle) {
      degrees = 360 + degrees;
    }

    double dx = _math.max(0, _math.min(offset.dx, size));
    double dy = _math.max(0, _math.min(offset.dy, size));

    double distance =
        _math.sqrt(_math.pow(middle - dx, 2) + _math.pow(middle - dy, 2));

    double normalizedDistance = _math.min(distance / (size / 2), 1.0);

    DateTime _callbackTimestamp = callbackTimestamp;
    if (onDirectionChanged != null &&
        _canCallOnDirectionChanged(callbackTimestamp)) {
      _callbackTimestamp = DateTime.now();
      onDirectionChanged(degrees, normalizedDistance);
    }

    return _callbackTimestamp;
  }

  bool _canCallOnDirectionChanged(DateTime callbackTimestamp) {
    if (interval != null && callbackTimestamp != null) {
      int intervalMilliseconds = interval.inMilliseconds;
      int timestampMilliseconds = callbackTimestamp.millisecondsSinceEpoch;
      int currentTimeMilliseconds = DateTime.now().millisecondsSinceEpoch;

      if (currentTimeMilliseconds - timestampMilliseconds <=
          intervalMilliseconds) {
        return false;
      }
    }

    return true;
  }

  Offset _calculatePositionOfInnerCircle(
      Offset lastPosition, double innerCircleSize, double size, Offset offset) {
    double middle = size / 2.0;

    double angle = _math.atan2(offset.dy - middle, offset.dx - middle);
    double degrees = angle * 180 / _math.pi;
    if (offset.dx < middle && offset.dy < middle) {
      degrees = 360 + degrees;
    }
    bool isStartPosition = lastPosition.dx == innerCircleSize &&
        lastPosition.dy == innerCircleSize;
    double lastAngleRadians =
        (isStartPosition) ? 0 : (degrees) * (_math.pi / 180.0);

    var rBig = size / 2;
    var rSmall = innerCircleSize / 2;

    var x = (lastAngleRadians == -1)
        ? rBig - rSmall
        : (rBig - rSmall) + (rBig - rSmall) * _math.cos(lastAngleRadians);
    var y = (lastAngleRadians == -1)
        ? rBig - rSmall
        : (rBig - rSmall) + (rBig - rSmall) * _math.sin(lastAngleRadians);

    var xPosition = lastPosition.dx - rSmall;
    var yPosition = lastPosition.dy - rSmall;

    var angleRadianPlus = lastAngleRadians + _math.pi / 2;
    if (angleRadianPlus < _math.pi / 2) {
      if (xPosition > x) {
        xPosition = x;
      }
      if (yPosition < y) {
        yPosition = y;
      }
    } else if (angleRadianPlus < _math.pi) {
      if (xPosition > x) {
        xPosition = x;
      }
      if (yPosition > y) {
        yPosition = y;
      }
    } else if (angleRadianPlus < 3 * _math.pi / 2) {
      if (xPosition < x) {
        xPosition = x;
      }
      if (yPosition > y) {
        yPosition = y;
      }
    } else {
      if (xPosition < x) {
        xPosition = x;
      }
      if (yPosition < y) {
        yPosition = y;
      }
    }
    return Offset(xPosition, yPosition);
  }
}

typedef PadButtonPressedCallback = void Function(
    int buttonIndex, Gestures gesture);

class PadButtonsView extends StatelessWidget {
  final double size;
  final List<PadButtonItem> buttons;
  final PadButtonPressedCallback padButtonPressedCallback;
  final Map<int, Color> buttonsStateMap = HashMap<int, Color>();
  final double buttonsPadding;
  final Color backgroundPadButtonsColor;

  PadButtonsView({
    this.size,
    this.buttons = const [
      PadButtonItem(index: 0, buttonText: "A"),
      PadButtonItem(index: 1, buttonText: "B", pressedColor: Colors.red),
      PadButtonItem(index: 2, buttonText: "C", pressedColor: Colors.green),
      PadButtonItem(index: 3, buttonText: "D", pressedColor: Colors.yellow),
    ],
    this.padButtonPressedCallback,
    this.buttonsPadding = 0,
    this.backgroundPadButtonsColor = Colors.transparent,
  }) : assert(buttons != null && buttons.isNotEmpty) {
    buttons.forEach(
        (button) => buttonsStateMap[button.index] = button.backgroundColor);
  }

  @override
  Widget build(BuildContext context) {
    double actualSize = size != null
        ? size
        : _math.min(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height) *
            0.5;
    double innerCircleSize = actualSize / 3;

    return Center(
        child: Stack(children: createButtons(innerCircleSize, actualSize)));
  }

  List<Widget> createButtons(double innerCircleSize, double actualSize) {
    List<Widget> list = List();
    list.add(CircleView.padBackgroundCircle(
        actualSize,
        backgroundPadButtonsColor,
        backgroundPadButtonsColor != Colors.transparent
            ? Colors.black45
            : Colors.transparent,
        backgroundPadButtonsColor != Colors.transparent
            ? Colors.black12
            : Colors.transparent));

    for (var i = 0; i < buttons.length; i++) {
      var padButton = buttons[i];
      list.add(createPositionedButtons(
        padButton,
        actualSize,
        i,
        innerCircleSize,
      ));
    }
    return list;
  }

  Positioned createPositionedButtons(PadButtonItem paddButton,
      double actualSize, int index, double innerCircleSize) {
    return Positioned(
      child: StatefulBuilder(builder: (context, setState) {
        return GestureDetector(
          onTap: () {
            _processGesture(paddButton, Gestures.TAP);
          },
          onTapUp: (details) {
            _processGesture(paddButton, Gestures.TAPUP);
            Future.delayed(const Duration(milliseconds: 50), () {
              setState(() => buttonsStateMap[paddButton.index] =
                  paddButton.backgroundColor);
            });
          },
          onTapDown: (details) {
            _processGesture(paddButton, Gestures.TAPDOWN);

            setState(() =>
                buttonsStateMap[paddButton.index] = paddButton.pressedColor);
          },
          onTapCancel: () {
            _processGesture(paddButton, Gestures.TAPCANCEL);

            setState(() =>
                buttonsStateMap[paddButton.index] = paddButton.backgroundColor);
          },
          onLongPress: () {
            _processGesture(paddButton, Gestures.LONGPRESS);
          },
          onLongPressStart: (details) {
            _processGesture(paddButton, Gestures.LONGPRESSSTART);

            setState(() =>
                buttonsStateMap[paddButton.index] = paddButton.pressedColor);
          },
          onLongPressUp: () {
            _processGesture(paddButton, Gestures.LONGPRESSUP);

            setState(() =>
                buttonsStateMap[paddButton.index] = paddButton.backgroundColor);
          },
          child: Padding(
            padding: EdgeInsets.all(buttonsPadding),
            child: CircleView.padButtonCircle(
                innerCircleSize,
                buttonsStateMap[paddButton.index],
                paddButton.buttonImage,
                paddButton.buttonIcon,
                paddButton.buttonText),
          ),
        );
      }),
      top: _calculatePositionYOfButton(index, innerCircleSize, actualSize),
      left: _calculatePositionXOfButton(index, innerCircleSize, actualSize),
    );
  }

  void _processGesture(PadButtonItem button, Gestures gesture) {
    if (padButtonPressedCallback != null &&
        button.supportedGestures.contains(gesture)) {
      padButtonPressedCallback(button.index, gesture);
      print("$gesture paddbutton id =  ${[button.index]}");
    }
  }

  double _calculatePositionXOfButton(
      int index, double innerCircleSize, double actualSize) {
    double degrees = 360 / buttons.length * index;
    double lastAngleRadians = (degrees) * (_math.pi / 180.0);

    var rBig = actualSize / 2;
    var rSmall = (innerCircleSize + 2 * buttonsPadding) / 2;

    return (rBig - rSmall) + (rBig - rSmall) * _math.cos(lastAngleRadians);
  }

  double _calculatePositionYOfButton(
      int index, double innerCircleSize, double actualSize) {
    double degrees = 360 / buttons.length * index;
    double lastAngleRadians = (degrees) * (_math.pi / 180.0);
    var rBig = actualSize / 2;
    var rSmall = (innerCircleSize + 2 * buttonsPadding) / 2;

    return (rBig - rSmall) + (rBig - rSmall) * _math.sin(lastAngleRadians);
  }
}
