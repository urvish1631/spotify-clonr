import 'package:flutter/material.dart';
import 'package:sada_app/src/providers/theme_provier.dart';
import 'package:provider/provider.dart';

class ThemeContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Decoration lightThemeDecoration;
  final Decoration? darkThemeDecoration;
  final BoxConstraints? constraints;

  const ThemeContainer(
      {Key? key,
      required this.child,
      this.width,
      this.margin,
      this.padding,
      required this.lightThemeDecoration,
      this.darkThemeDecoration,
      this.height,
      this.constraints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeData, _) => Container(
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        constraints: constraints,
        decoration:
            themeData.isDarkMode ? darkThemeDecoration : lightThemeDecoration,
        child: child,
      ),
    );
  }
}
