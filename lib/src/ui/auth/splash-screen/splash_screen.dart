import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/extensions/context_extension.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/image_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/navigation_route_constants.dart';
import 'package:spotify_clone/src/base/utils/constants/preference_key_constant.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:spotify_clone/src/base/utils/preference_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //Variables
  Timer? _timer;
  double? dimension = 0.0;

  //Methods
  void _startTimer() async {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (timer.tick == 1) {
        setState(() {
          dimension = 800;
        });
      } else {
        _timer!.cancel();
        if (getString(prefkeyToken).isNotEmpty &&
            getBool(prefkeyIsOtpVerified)) {
          locator<NavigationUtils>().pushAndRemoveUntil(routeTabBar);
        } else if (getString(prefkeyToken).isNotEmpty &&
            !getBool(prefkeyIsOtpVerified)) {
          locator<NavigationUtils>().pushAndRemoveUntil(routeLogin);
        } else if (getBool(prefkeyIsGetStartedDone)) {
          locator<NavigationUtils>().pushAndRemoveUntil(routeChooseRole);
        } else {
          locator<NavigationUtils>().pushAndRemoveUntil(routeGetStarted);
        }
      }
    });
  }

  //Lifecycle Methods
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  //Build Method
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.getHeight(),
      color: splashColor,
      child: Center(
        child: AnimatedContainer(
          height: dimension,
          width: dimension,
          curve: Curves.linearToEaseOut,
          duration: const Duration(seconds: 2),
          child: Image.asset(
            appLogo,
          ),
        ),
      ),
    );
  }
}
