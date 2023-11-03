import 'package:flutter/material.dart';
import 'package:sada_app/src/base/dependencyinjection/locator.dart';
import 'package:sada_app/src/base/extensions/scaffold_extension.dart';
import 'package:sada_app/src/base/extensions/string_extension.dart';
import 'package:sada_app/src/base/utils/common_ui_methods.dart';
import 'package:sada_app/src/base/utils/constants/color_constant.dart';
import 'package:sada_app/src/base/utils/constants/preference_key_constant.dart';
import 'package:sada_app/src/base/utils/localization/localization.dart';
import 'package:sada_app/src/base/utils/preference_utils.dart';
import 'package:sada_app/src/controllers/auth/auth_controller.dart';
import 'package:sada_app/src/models/auth/reset_password/req_reset_password_model.dart';
import 'package:sada_app/src/models/auth/update_password/req_update_password_model.dart';
import 'package:sada_app/src/widgets/primary_button.dart';
import 'package:sada_app/src/widgets/primary_text_field.dart';

class ConfirmPassword extends StatefulWidget {
  const ConfirmPassword({Key? key}) : super(key: key);

  @override
  State<ConfirmPassword> createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  //Variables
  final _oldPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _oldPasswordFocus = FocusNode();
  final _confirmPasswordController = TextEditingController();
  final _confirmPasswordFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  //API calling functions
  _resetPasswordAPICalling() async {
    await locator<AuthController>().resetPasswordApiCall(
        context: context,
        model: ReqResetPasswordModel(
          confirmPassword: _confirmPasswordController.text,
          password: _passwordController.text,
          email: getString(prefkeyEmailAddress),
          otp: getString(prefkeyOTP),
        ));
  }

  _updatePasswordAPICall() async {
    await locator<AuthController>().updatePasswordApiCall(
        context: context,
        model: ReqPasswordUpdateModel(
          newPassword: _passwordController.text,
          oldPassword: _oldPasswordController.text,
        ));
  }

  //Build method
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getAuthHeader(getBool(prefkeyResetPasswordFromProfile)
                ? Localization.of().updatePassword
                : Localization.of().resetPassword),
            if (getBool(prefkeyResetPasswordFromProfile))
              Column(
                children: [
                  const SizedBox(height: 10.0),
                  _getOldPasswordTextField(),
                ],
              ),
            const SizedBox(height: 10.0),
            _getPasswordTextField(),
            const SizedBox(height: 10.0),
            _getConfirmPasswordTextField(),
            const SizedBox(height: 10.0),
            _getSubmitButton(),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    ).authContainerScaffold(
      context: context,
      isLeadingEnable: getBool(prefkeyResetPasswordFromProfile) ? true : false,
    );
  }

  //Widgets
  Widget _getOldPasswordTextField() {
    return PrimaryTextField(
      isObscureText: true,
      hint: Localization.of().oldPassword,
      focusNode: _oldPasswordFocus,
      type: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      controller: _oldPasswordController,
      onFieldSubmitted: (value) {
        _oldPasswordFocus.unfocus();
        _passwordFocus.requestFocus();
      },
      validateFunction: (value) {
        return value!.isValidPassword();
      },
    );
  }

  Widget _getPasswordTextField() {
    return PrimaryTextField(
      isObscureText: true,
      hint: Localization.of().password,
      focusNode: _passwordFocus,
      type: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      controller: _passwordController,
      onFieldSubmitted: (value) {
        _passwordFocus.unfocus();
        _confirmPasswordFocus.requestFocus();
      },
      validateFunction: (value) {
        return value!.isValidPassword();
      },
    );
  }

  Widget _getConfirmPasswordTextField() {
    return PrimaryTextField(
      isObscureText: true,
      hint: Localization.of().confirmPassword,
      focusNode: _confirmPasswordFocus,
      type: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      controller: _confirmPasswordController,
      onFieldSubmitted: (value) {
        _confirmPasswordFocus.unfocus();
      },
      validateFunction: (value) {
        if ((value ?? '').isEmpty) {
          return (value ?? '')
              .isFieldEmpty(Localization.of().msgConfirmPasswordEmpty);
        } else {
          return value!.isValidConfirmPassword(_passwordController.text);
        }
      },
    );
  }

  Widget _getSubmitButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryButton(
          buttonText: Localization.of().submit,
          buttonColor: primaryColor,
          onButtonClick: () {
            if (_formKey.currentState!.validate()) {
              if (getBool(prefkeyResetPasswordFromProfile)) {
                _updatePasswordAPICall();
              } else {
                _resetPasswordAPICalling();
              }
            }
          },
        ),
      ],
    );
  }
}
