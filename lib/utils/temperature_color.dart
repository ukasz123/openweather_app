import 'dart:math';

import 'package:flutter/widgets.dart';

const coldColor = const Color(0xff0099ff);
const mildColor = const Color(0xff66aa33);
const warmColor = const Color(0xffff5500);

const minTemp = -15;
const maxTemp = 40;

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
