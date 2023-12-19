import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:spotify_clone/src/base/utils/constants/app_constant.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/widgets/toast_widget.dart';
import '../utils/constants/color_constant.dart';

extension StringExtension on String {
  String getInitials() => isNotEmpty
      ? trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
      : '';

  Color hexToColor() =>
      isEmpty ? secondaryColor : Color(int.parse(replaceAll('#', "0xff")));

  bool _emailValidation(String value) {
    return RegExp(validEmailRegex).hasMatch(value);
  }

  // Check Email Validation
  String? isValidEmail() {
    if (trim().isEmpty) {
      return Localization.of().msgEmailEmpty;
    } else if (!_emailValidation(trim())) {
      return Localization.of().msgEmailInvalid;
    } else {
      return null;
    }
  }

  // Check Moblie Validation
  String? isValidPhone(PhoneNumber value) {
    if (value.completeNumber.isEmpty) {
      return Localization.of().msgPhoneEmpty;
    } else if (!value.isValidNumber()) {
      return Localization.of().msgPhoneInvalid;
    } else {
      return null;
    }
  }

  // Check Verification code Validation
  String? isValidCode(BuildContext context) {
    if (trim().isEmpty) {
      ToastUtils.showFailed(
          message: Localization.of().msgVerificationCodeEmpty);
      return "";
    } else if (trim().length != 4) {
      ToastUtils.showFailed(
          message: Localization.of().msgVerificationCodeInvalid);
      return "";
    } else {
      return null;
    }
  }

  // Empty Field Validation
  String? isFieldEmpty(String message) {
    if (trim().isEmpty) {
      return message;
    } else {
      return null;
    }
  }

  bool _passwordValidation(String value) {
    return RegExp(validPasswordRegex).hasMatch(value);
  }

  // Check Password Validation
  String? isValidPassword() {
    if (trim().isEmpty) {
      return Localization.of().msgPasswordEmpty;
    } else if (!_passwordValidation(trim())) {
      return Localization.of().msgPasswordError;
    } else {
      return null;
    }
  }

  // Check Valid Confirm Password
  String? isValidConfirmPassword(String newPassword) {
    if (newPassword.trim() != trim()) {
      return Localization.of().msgPasswordNotMatch;
    } else {
      return null;
    }
  }
}

extension ColorExtension on Color {
  String colorToHex() => "#${value.toRadixString(16).substring(2)}";
}
