import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/extensions/context_extension.dart';
import 'package:spotify_clone/src/base/extensions/scaffold_extension.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/fontsize_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/image_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/navigation_route_constants.dart';
import 'package:spotify_clone/src/base/utils/constants/preference_key_constant.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:spotify_clone/src/base/utils/preference_utils.dart';
import 'package:spotify_clone/src/providers/language_provider.dart';
import 'package:spotify_clone/src/widgets/primary_button.dart';
import 'package:spotify_clone/src/widgets/themewidgets/theme_text.dart';

class SelectRoleScreen extends StatefulWidget {
  const SelectRoleScreen({Key? key}) : super(key: key);

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  //Variables
  final ValueNotifier<bool> _isRoleSelected = ValueNotifier<bool>(false);
  // bool? isLanguageSelected = false;

  @override
  void initState() {
    // _isRoleSelected.value = getBool(prefkeyIsUser) || getBool(prefkeyIsCreator);
    super.initState();
  }

  //Build Method
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.getWidth(),
      decoration: const BoxDecoration(
        image: DecorationImage(
            alignment: Alignment.topCenter,
            image: AssetImage(backgroundImage),
            fit: BoxFit.contain),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: blackColor.withOpacity(0.7),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _selectPreference(),
      ),
    ).getStartContainerScaffold(context: context);
  }

  //Widgets
  Widget _selectPreference() => Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return ValueListenableBuilder(
            valueListenable: _isRoleSelected,
            builder: (context, bool isRoleSelected, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ThemeText(
                    text: Localization.of().selectRole,
                    lightTextColor: whiteColor,
                    fontSize: fontSize22,
                    fontWeight: fontWeightSemiBold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  _getRowOfIcons(isRoleSelected),
                  const SizedBox(height: 50.0),
                  _getContinueButton(),
                  const SizedBox(height: 50.0),
                  // Select Language commented code.
                  // ThemeText(
                  //   text: Localization.of().selectLanguage,
                  //   lightTextColor: whiteColor,
                  //   fontSize: fontSize22,
                  //   fontWeight: fontWeightSemiBold,
                  //   textAlign: TextAlign.center,
                  // ),
                  // const SizedBox(height: 20.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     PrimaryButton(
                  //         buttonText: Localization.of().english,
                  //         width: 120,
                  //         textColor: languageProvider.languageCode == en
                  //             ? blackColor
                  //             : whiteColor,
                  //         buttonColor: languageProvider.languageCode == en
                  //             ? primaryColor
                  //             : secondaryColor,
                  //         onButtonClick: () {
                  //           RestartWidget.restartApp(context);
                  //           languageProvider.changeLanguage(const Locale(en));
                  //         }),
                  //     PrimaryButton(
                  //         width: 100,
                  //         buttonText: Localization.of().arabic,
                  //         textColor: languageProvider.languageCode == ar
                  //             ? blackColor
                  //             : whiteColor,
                  //         buttonColor: languageProvider.languageCode == ar
                  //             ? primaryColor
                  //             : secondaryColor,
                  //         onButtonClick: () {
                  //           RestartWidget.restartApp(context);
                  //           languageProvider.changeLanguage(const Locale(ar));
                  //         }),
                  //   ],
                  // ),
                  // const SizedBox(height: 50.0),
                ],
              );
            },
          );
        },
      );

  PrimaryButton _getContinueButton() => PrimaryButton(
        width: context.getWidth(),
        buttonText: Localization.of().continueText,
        buttonColor: primaryColor,
        onButtonClick: () async {
          if (!_isRoleSelected.value) {
            await setBool(prefkeyIsUser, true);
            await setBool(prefkeyIsCreator, false);
          } else if (_isRoleSelected.value) {
            await setBool(prefkeyIsUser, false);
            await setBool(prefkeyIsCreator, true);
          }
          await locator<NavigationUtils>().push(routeRegister);
        },
      );

  Row _getRowOfIcons(bool isRoleSelected) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              _getIcons(isRoleSelected, () async {
                if (!(isRoleSelected)) {
                  _isRoleSelected.value = !(isRoleSelected);
                }
              }, Icons.mic),
              const SizedBox(height: 20.0),
              ThemeText(
                text: Localization.of().creator,
                lightTextColor: whiteColor,
                fontSize: fontSize18,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Column(
            children: [
              _getIcons(!(isRoleSelected), () async {
                if (isRoleSelected) {
                  _isRoleSelected.value = !(isRoleSelected);
                }
              }, Icons.headphones),
              const SizedBox(height: 20.0),
              ThemeText(
                text: Localization.of().user,
                lightTextColor: whiteColor,
                fontSize: fontSize18,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      );

  Widget _getIcons(
    bool? isSelected,
    void Function()? onIconClick,
    IconData icon,
  ) =>
      InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onIconClick,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (isSelected ?? false)
                ? primaryColor
                : secondaryColor.withOpacity(0.8),
          ),
          padding: const EdgeInsets.all(18.0),
          child: Icon(
            icon,
            size: 30,
            color: (isSelected ?? false) ? blackColor : whiteColor,
          ),
        ),
      );
}
