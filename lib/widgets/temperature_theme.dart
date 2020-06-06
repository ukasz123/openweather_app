import 'package:flutter/material.dart';

class PrimaryThemeBuilder extends StatelessWidget {
  final WidgetBuilder builder;
  final Color color;

  const PrimaryThemeBuilder({Key key, this.builder, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData tempTheme = ThemeData(
      primaryColor: color,
    );
    return Theme(data: tempTheme, child: Builder(builder: this.builder));
  }
}
