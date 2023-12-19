import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:spotify_clone/src/widgets/customdialogs/cupertino_error_dialog.dart';
import 'package:spotify_clone/src/widgets/customdialogs/material_error_dialog.dart';

void showAlertDialog({
  required String message,
  String? okButtonTitle,
  Function()? okButtonAction,
  bool isCancelEnable = true,
}) {
  showDialog(
    barrierDismissible: isCancelEnable,
    context: locator<NavigationUtils>().getCurrentContext,
    builder: (dialogContext) {
      if (Platform.isIOS) {
        return CupertinoErrorDialog(
            message: message,
            okTitle: okButtonTitle,
            okFunction: okButtonAction,
            isCancelEnable: isCancelEnable);
      } else {
        return MaterialErrorDialog(
            message: message,
            okTitle: okButtonTitle,
            okFunction: okButtonAction,
            isCancelEnable: isCancelEnable);
      }
    },
  );
}
