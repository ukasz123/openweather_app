import 'package:flutter/material.dart';

class TemperatureText extends StatelessWidget {
  const TemperatureText({
    Key key,
    @required this.temperature,
    @required this.height,
    this.textStyle,
  }) : super(key: key);

  final double temperature;
  final double height;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    var style = textStyle ?? Theme.of(context).textTheme.bodyText1;
    return DefaultTextStyle(
      style: style,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: Offset(0, -height * 0.125),
            child: Text(temperature.toStringAsFixed(1),
                style:
                    TextStyle(fontSize: height, fontWeight: FontWeight.w500)),
          ),
          SizedBox(
            width: height * 0.07,
          ),
          Text('o', style: TextStyle(fontSize: height * 0.25, height: 1.5)),
          Text('C', style: TextStyle(fontSize: height * 0.75))
        ],
      ),
    );
  }
}
