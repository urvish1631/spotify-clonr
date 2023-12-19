import 'package:flutter/material.dart';
import 'package:spotify_clone/src/base/extensions/context_extension.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/fontsize_constant.dart';
import 'package:spotify_clone/src/widgets/themewidgets/theme_text.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final Function()? onButtonClick;
  final double? width;
  final double? height;
  final IconData? leadingIcon;

  const PrimaryButton({
    Key? key,
    required this.buttonText,
    required this.buttonColor,
    this.width,
    this.height,
    required this.onButtonClick,
    this.textColor = primaryTextColor,
    this.leadingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onButtonClick,
      style: ElevatedButton.styleFrom(
        foregroundColor: blackColor,
        fixedSize: Size(width ?? context.getWidth(), height ?? 50.0),
        backgroundColor: buttonColor,
      ),
      child: ThemeText(
        textAlign: TextAlign.center,
        text: buttonText,
        lightTextColor: textColor,
        fontSize: fontSize20,
        fontWeight: fontWeightSemiBold,
      ),
    );
  }
}
