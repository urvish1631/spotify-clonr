import 'package:flutter/material.dart';

import '../../base/utils/common_ui_methods.dart';
import '../../base/utils/constants/color_constant.dart';

ThemeData lightThemeData() {
  return ThemeData(
    useMaterial3: true,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 10.0,
      foregroundColor: whiteColor,
      backgroundColor: primaryColor,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: whiteColor,
      textStyle: lightPopupMenuTextStyle(),
    ),
    radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all<Color>(primaryColor)),
    checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all<Color>(primaryColor)),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: whiteColor),
    dialogTheme: const DialogTheme(backgroundColor: whiteColor),
    scaffoldBackgroundColor: whiteColor,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Poppins',
  );
}

ThemeData darkThemeData() {
  return ThemeData(
    useMaterial3: true,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 10.0,
        foregroundColor: whiteColor,
        backgroundColor: Colors.black45),
    popupMenuTheme: PopupMenuThemeData(
      color: blackColor,
      textStyle: darkPopupMenuTextStyle(),
    ),
    radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all<Color>(primaryColor)),
    checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all<Color>(primaryColor)),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.black45,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.black45,
    ),
    scaffoldBackgroundColor: blackColor,
    brightness: Brightness.dark,
    primaryColor: blackColor,
    appBarTheme: const AppBarTheme(backgroundColor: blackColor),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Poppins',
  );
}
