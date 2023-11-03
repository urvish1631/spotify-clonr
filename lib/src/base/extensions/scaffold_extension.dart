import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sada_app/src/base/dependencyinjection/locator.dart';
import 'package:sada_app/src/base/utils/constants/color_constant.dart';
import 'package:sada_app/src/base/utils/constants/image_constant.dart';
import 'package:sada_app/src/base/utils/constants/preference_key_constant.dart';
import 'package:sada_app/src/base/utils/localization/localization.dart';
import 'package:sada_app/src/base/utils/constants/navigation_route_constants.dart';
import 'package:sada_app/src/base/utils/navigation_utils.dart';
import 'package:sada_app/src/base/utils/preference_utils.dart';

extension ScaffoldExtension on Widget {
  Scaffold normalScaffold({
    required BuildContext context,
    required bool isTopRequired,
  }) {
    return Scaffold(
      body: SafeArea(
        top: isTopRequired ? true : false,
        child: this,
      ),
    );
  }

  Scaffold titleScaffold({
    required BuildContext context,
    required bool isTopRequired,
    AppBar? appBar,
  }) {
    return Scaffold(
      appBar: appBar ?? AppBar(),
      body: SafeArea(
        top: isTopRequired ? true : false,
        child: this,
      ),
    );
  }

  Scaffold playerScreen() {
    return Scaffold(
        backgroundColor: secondaryColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: secondaryColor,
          leading: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => locator<NavigationUtils>().pop(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: blackColor.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(50.0),
                  border:
                      Border.all(width: 1, color: whiteColor.withOpacity(0.5)),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
            ),
          ),
          title: Text(Localization.of().nowPlaying),
        ),
        body: this);
  }

  Scaffold getStartContainerScaffold({required BuildContext context}) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.7),
                spreadRadius: 200,
                blurRadius: 100,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: AppBar(
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                headerLogo,
                height: 50,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: this,
      ),
    );
  }

  Scaffold authContainerScaffold(
      {required BuildContext context,
      required bool isLeadingEnable,
      String title = "",
      bool isTitleEnable = false}) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: isLeadingEnable
            ? InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => locator<NavigationUtils>().pop(),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: blackColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                ),
              )
            : const SizedBox(),
        title: isTitleEnable
            ? Text(title)
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  headerLogo,
                  height: 50,
                ),
              ),
      ),
      body: SafeArea(
        child: this,
      ),
    );
  }

  Scaffold homeScreenScaffold({required BuildContext context}) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          getBool(prefkeyIsCreator)
              ? InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () => locator<NavigationUtils>().push(routeSettings),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SvgPicture.asset(
                      icSettings,
                      height: 30,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
        centerTitle: true,
        leading: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => locator<NavigationUtils>().push(routeSearch),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset(icSearch),
            )),
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            headerLogo,
            height: 50,
          ),
        ),
      ),
      body: SafeArea(
        child: this,
      ),
    );
  }

  Scaffold tabBarScreenScaffold(
      {required BuildContext context,
      required String headerTitle,
      void Function()? onRightIconClick,
      void Function()? onLeftIconClick,
      required bool isRecentlyPlayed}) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: whiteColor.withOpacity(0.3),
                spreadRadius: 6,
                blurRadius: 60,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: AppBar(
            actions: [
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: onRightIconClick,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: isRecentlyPlayed
                      ? const SizedBox()
                      : SvgPicture.asset(
                          icAdd,
                          height: 40,
                        ),
                ),
              ),
            ],
            centerTitle: true,
            leading: isRecentlyPlayed
                ? const SizedBox()
                : InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => locator<NavigationUtils>().push(routeSearch),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(icSearch),
                    )),
            title: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(headerTitle),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: this,
      ),
    );
  }

  Dialog dialogContainer({double height = 350}) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 20.0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        height: height,
        padding: const EdgeInsets.all(20.0),
        child: this,
      ),
    );
  }
}
