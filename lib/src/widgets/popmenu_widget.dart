import 'package:flutter/material.dart';
import 'package:sada_app/src/base/utils/constants/color_constant.dart';
import 'package:sada_app/src/base/utils/constants/fontsize_constant.dart';
import 'package:sada_app/src/widgets/themewidgets/theme_text.dart';

class PopupTextButton extends StatelessWidget {
  final String? text;
  const PopupTextButton({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ThemeText(
        text: text ?? '',
        lightTextColor: whiteColor,
        fontSize: fontSize16,
      ),
    );
  }
}
