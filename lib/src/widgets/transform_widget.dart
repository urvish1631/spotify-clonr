import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:spotify_clone/src/base/utils/common_methods.dart';

class TransformWidget extends StatelessWidget {
  final Widget child;
  const TransformWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLanguageArabic()
        ? Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: child,
          )
        : child;
  }
}
