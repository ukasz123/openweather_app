import 'package:flutter/material.dart';

class PrimaryThemeBuilder extends StatelessWidget {
  final WidgetBuilder builder;
  final Color color;

  const PrimaryThemeBuilder({Key key, this.builder, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var baseTheme = Theme.of(context);
    ThemeData tempTheme = ThemeData(
      primaryColor: color,
    );

    return Theme(
        data: baseTheme.copyWith(
            primaryColor: color,
            primaryColorBrightness: tempTheme.primaryColorBrightness,
            primaryTextTheme: tempTheme.primaryTextTheme,
            primaryIconTheme: tempTheme.primaryIconTheme,
            ),
        child: Builder(builder: this.builder));
  }
}
