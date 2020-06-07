import 'dart:math';

import 'package:flutter/widgets.dart';

const coldColor = const Color(0xff6699ff);
const warmColor = const Color(0xffff9966);

Color forTemperature(double temperature) {
  final normTemp = (max(-15.0, min(40.0, temperature)) + 15.0) / 55.0;
  final tempColor = Color.lerp(coldColor, warmColor, normTemp);
  return tempColor;
}
