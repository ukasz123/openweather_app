import 'dart:math';

import 'package:flutter/widgets.dart';

const coldColor = const Color(0xff6699ff);
const mildColor = const Color(0xff99ff00);
const warmColor = const Color(0xffff5533);

const minTemp = -25;
const maxTemp = 45;

final Animatable<Color> colorFunc = TweenSequence<Color>([
  TweenSequenceItem(
      tween: ColorTween(begin: coldColor, end: mildColor)
          .chain(CurveTween(curve: Curves.easeInOutCubic)),
      weight: 1.0),
  TweenSequenceItem(
      tween: ColorTween(begin: mildColor, end: warmColor)
          .chain(CurveTween(curve: Curves.easeInOutCubic)),
      weight: 1.0),
]);

Color forTemperature(double temperature) {
  final normTemp =
      (max(minTemp, min(maxTemp, temperature)) - minTemp) / (maxTemp - minTemp);

  final tempColor = colorFunc.transform(normTemp);
  return tempColor;
}
