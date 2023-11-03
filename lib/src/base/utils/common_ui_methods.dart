// Cells Container Decoration
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sada_app/src/base/dependencyinjection/locator.dart';
import 'package:sada_app/src/base/utils/constants/color_constant.dart';
import 'package:sada_app/src/base/utils/constants/navigation_route_constants.dart';
import 'package:sada_app/src/base/utils/localization/localization.dart';
import 'package:sada_app/src/base/utils/navigation_utils.dart';
import 'package:sada_app/src/base/utils/preference_utils.dart';
import 'package:sada_app/src/providers/player_provider.dart';
import 'package:sada_app/src/widgets/customdialogs/cupertino_error_dialog.dart';
import 'package:sada_app/src/widgets/customdialogs/material_error_dialog.dart';
import 'package:sada_app/src/models/playlist/req_playlist_model.dart';
import 'package:sada_app/src/widgets/add_playlist_widget.dart';
import 'package:sada_app/src/widgets/bottom_modal_widget.dart';
import 'package:sada_app/src/widgets/media_picker_widget.dart';
import 'package:sada_app/src/widgets/themewidgets/theme_text.dart';
import 'constants/fontsize_constant.dart';

// Text Style
TextStyle lightPopupMenuTextStyle() {
  return const TextStyle(
    color: primaryTextColor,
    fontWeight: fontWeightRegular,
    fontSize: fontSize14,
  );
}

TextStyle darkPopupMenuTextStyle() {
  return const TextStyle(
    color: Colors.white,
    fontWeight: fontWeightRegular,
    fontSize: fontSize14,
  );
}

ThemeData lightCalendarTheme() {
  return ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light().copyWith(primary: primaryColor),
  );
}

ThemeData darkCalendarTheme() {
  return ThemeData.dark().copyWith();
}

// Media Picker Bottom Sheet Action Style
Widget getBottomSheetAction(
    {required IconData icon,
    required String title,
    required Function onTap,
    required BuildContext context}) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).pop();
      onTap();
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          ClipOval(
            child: Container(
              color: primaryColor,
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                icon,
                color: whiteColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ThemeText(
            text: title,
            lightTextColor: whiteColor,
            darkTextColor: whiteColor,
            fontSize: fontSize13,
            fontWeight: fontWeightRegular,
          ),
        ],
      ),
    ),
  );
}

Future<dynamic> getPlaylistActions({
  required bool? isUpdateTrue,
  required BuildContext context,
  int? playlistId,
  ReqPlaylistModel? playlistData,
}) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BottomModalSheet(
          playlistData: playlistData,
          playlistId: playlistId,
          isUpdateTrue: isUpdateTrue,
        );
      });
}

Future<dynamic> addPlaylist(
    {required BuildContext context, required int articleId}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return AddToPlaylistWidget(
        articleId: articleId,
      );
    },
  );
}

Widget getAuthHeader(String? text) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      const SizedBox(height: 50.0),
      Padding(
        padding: const EdgeInsets.only(bottom: 10.0, top: 20),
        child: Text(
          text ?? " ",
          style: const TextStyle(
            color: whiteColor,
            fontSize: fontSize28,
            fontWeight: fontWeightBold,
          ),
        ),
      ),
    ],
  );
}

Future<void> getImageBottomSheet({
  required BuildContext context,
  required Function onGalleryClick,
  required Function onCameraClick,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (ctx) => MediaPickerBottomSheet(
      title: Localization.of().selectOption,
      children: <Widget>[
        getBottomSheetAction(
          context: context,
          icon: Icons.photo,
          title: Localization.of().galleryTitle,
          onTap: onGalleryClick,
        ),
        getBottomSheetAction(
          context: context,
          icon: Icons.camera,
          title: Localization.of().cameraTitle,
          onTap: onCameraClick,
        ),
        getBottomSheetAction(
            context: context,
            icon: Icons.close,
            title: Localization.of().cancel,
            onTap: () {}),
      ],
    ),
  );
}

showDialogForLogout(BuildContext ctx) {
  return showDialog(
    context: ctx,
    builder: (BuildContext ctx) {
      return Platform.isIOS
          ? CupertinoErrorDialog(
              isCancelEnable: true,
              okFunction: () {
                removePrefkeys();
                Provider.of<PlayerProvider>(ctx, listen: false)
                    .clearAudioPlayer();
                locator<NavigationUtils>().pushAndRemoveUntil(routeChooseRole);
              },
              message: Localization.of().logoutText,
            )
          : MaterialErrorDialog(
              isCancelEnable: true,
              okFunction: () {
                removePrefkeys();
                Provider.of<PlayerProvider>(ctx, listen: false)
                    .clearAudioPlayer();
                locator<NavigationUtils>().pushAndRemoveUntil(routeChooseRole);
              },
              message: Localization.of().logoutText,
            );
    },
  );
}

removePrefkeys() async {
  await clear();
}

Widget getEmptyTextWidget({required String text}) => Center(
      child: ThemeText(
        text: text,
        lightTextColor: whiteColor,
        fontSize: fontSize18,
        textAlign: TextAlign.center,
      ),
    );
