import 'package:flutter/material.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/extensions/scaffold_extension.dart';
import 'package:spotify_clone/src/base/utils/common_ui_methods.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/dic_params.dart';
import 'package:spotify_clone/src/base/utils/constants/navigation_route_constants.dart';
import 'package:spotify_clone/src/base/utils/dialog_utils.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:spotify_clone/src/controllers/auth/auth_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _getListTile(Icons.language, Localization.of().language,
            () => locator<NavigationUtils>().push(routeLanguageScreen)),
        _getListTile(
          Icons.privacy_tip_outlined,
          Localization.of().privacyPolicy,
          () => locator<NavigationUtils>()
              .push(routeTermsAndCondition, arguments: {
            paramFromTerms: false,
          }),
        ),
        _getListTile(
          Icons.assignment,
          Localization.of().termsCondition,
          () => locator<NavigationUtils>()
              .push(routeTermsAndCondition, arguments: {
            paramFromTerms: true,
          }),
        ),
        _getListTile(
          Icons.delete_outline_rounded,
          Localization.of().deleteAccount,
          () => showAlertDialog(
            message: Localization.of().msgDeleteAccount,
            okButtonAction: () {
              locator<AuthController>().deleteProfileApiCall(context: context);
            },
          ),
        ),
        _getListTile(Icons.logout_rounded, Localization.of().logout,
            () => showDialogForLogout(context)),
      ],
    ).authContainerScaffold(
        context: context,
        isLeadingEnable: true,
        isTitleEnable: true,
        title: Localization.of().settings);
  }

  Widget _getListTile(IconData icon, String title, void Function() onClick) =>
      InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onClick,
        child: ListTile(
          leading: Icon(
            icon,
            color: whiteColor,
            size: 30,
          ),
          title: Text(title),
        ),
      );
}
