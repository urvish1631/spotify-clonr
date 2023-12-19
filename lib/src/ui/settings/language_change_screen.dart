import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/extensions/scaffold_extension.dart';
import 'package:spotify_clone/src/base/utils/constants/app_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/fontsize_constant.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/controllers/home/home_controller.dart';
import 'package:spotify_clone/src/models/auth/language/req_language_model.dart';
import 'package:spotify_clone/src/providers/language_provider.dart';
import 'package:spotify_clone/src/widgets/themewidgets/theme_text.dart';

class LanguageChangeScreen extends StatefulWidget {
  const LanguageChangeScreen({Key? key}) : super(key: key);

  @override
  State<LanguageChangeScreen> createState() => _LanguageChangeScreenState();
}

class _LanguageChangeScreenState extends State<LanguageChangeScreen> {
  changeLanguage(String language) {
    locator<HomeController>().changeLanguageApi(
        context: context, model: ReqLanguageModel(languagePref: language));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(builder: (context, locale, child) {
      return Column(
        children: [
          child ?? Container(),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              if (locale.locale.languageCode == ar) {
                changeLanguage(english);
              }
            },
            child: ListTile(
              leading: locale.locale.languageCode == en
                  ? const Icon(
                      Icons.check,
                      color: whiteColor,
                    )
                  : const SizedBox(),
              title: ThemeText(
                  text: Localization.of().english,
                  lightTextColor: whiteColor,
                  fontSize: fontSize16),
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              if (locale.locale.languageCode == en) {
                changeLanguage(arabic);
              }
            },
            child: ListTile(
              leading: (locale.locale.languageCode == ar)
                  ? const Icon(
                      Icons.check,
                      color: whiteColor,
                    )
                  : const SizedBox(),
              title: ThemeText(
                  text: Localization.of().arabic,
                  lightTextColor: whiteColor,
                  fontSize: fontSize16),
            ),
          ),
        ],
      ).authContainerScaffold(
        context: context,
        isLeadingEnable: true,
        isTitleEnable: true,
        title: Localization.of().language,
      );
    });
  }
}
