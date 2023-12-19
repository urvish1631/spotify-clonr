import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:spotify_clone/src/base/extensions/scaffold_extension.dart';
import 'package:spotify_clone/src/base/extensions/string_extension.dart';
import 'package:spotify_clone/src/base/utils/common_ui_methods.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/fontsize_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/navigation_route_constants.dart';
import 'package:spotify_clone/src/base/utils/constants/preference_key_constant.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:spotify_clone/src/controllers/auth/auth_controller.dart';
import 'package:spotify_clone/src/models/auth/otp/req_otp_model.dart';
import 'package:spotify_clone/src/models/auth/otp/req_resend_otp_model.dart';
import 'package:spotify_clone/src/widgets/primary_button.dart';
import 'package:spotify_clone/src/widgets/themewidgets/theme_text.dart';

import '../../../base/dependencyinjection/locator.dart';
import '../../../base/utils/preference_utils.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  //Variables
  final _pinController = TextEditingController();
  final _pinFocus = FocusNode();
  Timer? _timer;
  int _timeLeft = 30;
  final _formKey = GlobalKey<FormState>();

  //Lifecycle Methods
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _startTimer();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  //Timer Method
  _startTimer() {
    _timeLeft = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft -= 1;
        } else {
          _timer!.cancel();
        }
      });
    });
  }

  //Build Method
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getAuthHeader(Localization.of().otp),
            const SizedBox(height: 10.0),
            _getOtpTextField(),
            const SizedBox(height: 10.0),
            _getResendOtp(),
            const SizedBox(height: 40.0),
            _getOTPButton(),
          ],
        ),
      ),
    ).authContainerScaffold(context: context, isLeadingEnable: false);
  }

  //Widgets
  Widget _getResendOtp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () async {
            if (_timeLeft == 0) {
              _startTimer();
              _resendOtp();
            }
          },
          child: ThemeText(
            text: Localization.of().resendOtp,
            fontWeight: fontWeightSemiBold,
            lightTextColor: _timeLeft == 0 ? primaryColor : secondaryColor,
            fontSize: fontSize14,
          ),
        ),
        ThemeText(
          text: _timeLeft < 10 ? "00:0$_timeLeft" : "00:$_timeLeft",
          lightTextColor: primaryColor,
          fontSize: fontSize14,
        ),
      ],
    );
  }

  Widget _getOtpTextField() {
    return SizedBox(
      height: 64.0,
      width: 250,
      child: PinInputTextFormField(
        controller: _pinController,
        decoration: BoxLooseDecoration(
          strokeColorBuilder:
              PinListenColorBuilder(secondaryColor, primaryColor),
          errorTextStyle: const TextStyle(
            fontSize: fontSize12,
            color: redColor,
          ),
          textStyle: const TextStyle(
            fontSize: fontSize18,
          ),
          gapSpace: 10,
          radius: const Radius.circular(10.0),
        ),
        focusNode: _pinFocus,
        cursor: Cursor(
          color: whiteColor,
          width: 30,
        ),
        pinLength: 4,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        enabled: true,
        onChanged: (value) {},
        validator: (pin) {
          return pin?.isValidCode(context);
        },
      ),
    );
  }

  Widget _getOTPButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryButton(
          textColor:
              _pinController.text.length != 4 ? whiteColor : primaryTextColor,
          buttonText: Localization.of().submit,
          buttonColor:
              _pinController.text.length != 4 ? secondaryColor : primaryColor,
          onButtonClick: () {
            if (_pinController.text.length == 4) {
              if (getBool(prefkeyIsForgotPassword) &&
                  _pinController.text == getString(prefkeyOTP)) {
                locator<NavigationUtils>().push(routeConfirmPassword);
              } else {
                _verifyOtp();
              }
            }
          },
        ),
      ],
    );
  }

  //API calling Functions.
  _verifyOtp() {
    locator<AuthController>().verifyOtpApiCall(
      context: context,
      model: ReqOtpModel(
        otp: _pinController.text,
        email: getString(prefkeyEmailAddress),
      ),
    );
  }

  _resendOtp() {
    locator<AuthController>().resendOtpApiCall(
      context: context,
      model: ReqResendOtpModel(email: getString(prefkeyEmailAddress)),
    );
  }
}
