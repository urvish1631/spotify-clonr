import 'package:flutter/material.dart';
import 'package:sada_app/src/base/dependencyinjection/locator.dart';
import 'package:sada_app/src/base/extensions/context_extension.dart';
import 'package:sada_app/src/base/extensions/scaffold_extension.dart';
import 'package:sada_app/src/base/utils/constants/color_constant.dart';
import 'package:sada_app/src/base/utils/constants/fontsize_constant.dart';
import 'package:sada_app/src/base/utils/constants/image_constant.dart';
import 'package:sada_app/src/base/utils/constants/navigation_route_constants.dart';
import 'package:sada_app/src/base/utils/constants/preference_key_constant.dart';
import 'package:sada_app/src/base/utils/localization/localization.dart';
import 'package:sada_app/src/base/utils/navigation_utils.dart';
import 'package:sada_app/src/base/utils/preference_utils.dart';
import 'package:sada_app/src/widgets/primary_button.dart';
import 'package:sada_app/src/widgets/themewidgets/theme_text.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
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
        child: _getScreenText(),
      ),
    ).getStartContainerScaffold(context: context);
  }

  //Widgets
  Widget _getScreenText() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ThemeText(
                text: Localization.of().podcastForEveryone,
                lightTextColor: primaryColor,
                fontSize: fontSize26,
                fontWeight: fontWeightBold,
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          ThemeText(
            text: Localization.of().welcomeText,
            lightTextColor: whiteColor,
            fontSize: fontSize16,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          PrimaryButton(
            width: context.getWidth(),
            buttonText: Localization.of().getStarted,
            buttonColor: primaryColor,
            onButtonClick: () async {
              await setBool(prefkeyIsGetStartedDone, true);
              locator<NavigationUtils>().pushAndRemoveUntil(routeChooseRole);
            },
          ),
          const SizedBox(height: 50.0),
        ],
      );
}
