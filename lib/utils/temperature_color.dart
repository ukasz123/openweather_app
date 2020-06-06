import 'package:flutter/widgets.dart';

Color forTemperature(double temperature) {
  final normTemp = (temperature + 9.0) / 40;
  final coldColor = Color(0xff6699ff);
  final warmColor = Color(0xffff9966);
  final tempColor = Color.lerp(coldColor, warmColor, normTemp);
  return tempColor;
}
