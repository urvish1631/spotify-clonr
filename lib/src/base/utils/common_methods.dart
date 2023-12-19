import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:http_parser/http_parser.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:spotify_clone/src/providers/language_provider.dart';
import 'package:spotify_clone/src/widgets/customdialogs/cupertino_error_dialog.dart';
import 'package:spotify_clone/src/widgets/customdialogs/material_error_dialog.dart';

import 'common_ui_methods.dart';
import 'constants/app_constant.dart';
import 'constants/dic_params.dart';
import 'dialog_utils.dart';
import 'localization/localization.dart';

// Logger
void logger(String log) {
  if (kDebugMode) {
    debugPrint(log);
  }
}

// To Open App Settings
void openSettings(String message) {
  showAlertDialog(
    message: message,
    okButtonTitle: Localization.of().settings,
    okButtonAction: () {
      AppSettings.openAppSettings();
    },
  );
}

bool isLanguageArabic() {
  return Provider.of<LanguageProvider>(
              locator<NavigationUtils>().getCurrentContext,
              listen: false)
          .locale
          .languageCode ==
      ar;
}

double valueFromPercentageInRange(
    {required final double min, max, percentage}) {
  return percentage * (max - min) + min;
}

double percentageFromValueInRange({required final double min, max, value}) {
  return (value - min) / (max - min);
}

// Get Microphone Permission
Future<bool> recorderPermission({required BuildContext context}) async {
  final status = await Permission.microphone.request();
  bool isAccess = false;
  if (status.isDenied || status.isPermanentlyDenied) {
    openSettings(Localization.of().alertMicrophonePermission);
    isAccess = false;
  } else if (status.isGranted) {
    isAccess = true;
  }
  return isAccess;
}

// Pick Image From Gallery and Camera
Future<File> getImage(
    {required BuildContext context, required bool pickFromCamera}) async {
  final picker = ImagePicker();
  late File file;
  try {
    final pickedFile = await picker.pickImage(
      source: pickFromCamera ? ImageSource.camera : ImageSource.gallery,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: imageQuality,
    );
    if (pickedFile != null) {
      file = File(pickedFile.path);
    }
  } on PlatformException catch (e) {
    if (pickFromCamera
        ? e.code == permissionTypeCamera
        : e.code == permissionTypePhotos) {
      openSettings(
        pickFromCamera
            ? Localization.of().alertCameraPermission
            : Localization.of().alertPhotosPermission,
      );
    }
  }
  return file;
}

// To Get Multiple File
Future<List<PlatformFile>> getMultipleFiles(
    {required BuildContext context, required bool isMedia}) async {
  var pickedFile = <PlatformFile>[];
  var result = await FilePicker.platform.pickFiles(
    type: isMedia ? FileType.media : FileType.any,
    allowMultiple: true,
    allowCompression: true,
  );
  if (result != null) {
    pickedFile = result.files;
  }
  return pickedFile;
}

// To Get the Device ID
Future<String> getDeviceId() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (kIsWeb) {
    return "";
  } else {
    if (Platform.isIOS) {
      final IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor ?? ""; // unique ID on iOS
    } else {
      final AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
  }
}

// Date Picker Method
Future<DateTime?> pickDate(
    {required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate}) async {
  final picked = await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate ?? DateTime.now(),
    lastDate: lastDate ?? DateTime(DateTime.now().year + lastYear),
    builder: (context, child) {
      return Theme(
        data: 1 == 1 ? darkCalendarTheme() : lightCalendarTheme(),
        child: child!,
      );
    },
  );
  return picked;
}

//Format Time to 00:00
String twoDigits(int n) => n.toString().padLeft(2, '0');
String formatTime(Duration duration) {
  final hour = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return [if (duration.inHours > 0) hour, minutes, seconds].join(':');
}

//Get Content-Type of the Image
MediaType getImageContentType({required String filePath}) {
  final extensionName = getFileExtension(filePath: filePath);
  if (extensionName == 'm4a') {
    return MediaType('audio', 'mpeg');
  } else if (extensionName == "jpg" || extensionName == "jpeg") {
    return MediaType('image', 'jpeg');
  } else {
    return MediaType('image', 'png');
  }
}

// To file extenstion
String getFileExtension({required String filePath}) {
  return filePath.split('.').last.toLowerCase();
}

//Empty Image Dialog
showDialogForEmptyImage(BuildContext ctx) {
  return showDialog(
    context: ctx,
    builder: (BuildContext ctx) {
      return Platform.isIOS
          ? CupertinoErrorDialog(
              isCancelEnable: true,
              message: Localization.of().selectImageMessage,
            )
          : MaterialErrorDialog(
              isCancelEnable: true,
              message: Localization.of().selectImageMessage,
            );
    },
  );
}
