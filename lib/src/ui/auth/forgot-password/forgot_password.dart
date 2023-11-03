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
import 'package:sada_app/src/models/auth/otp/req_resend_otp_model.dart';
import 'package:sada_app/src/widgets/primary_button.dart';
import 'package:sada_app/src/widgets/primary_text_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
//Variables
  final _emailController = TextEditingController();
  final _phoneFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  //API calling functions
  _forgotPassword() {
    locator<AuthController>().forgotPasswordApiCall(
      context: context,
      model: ReqResendOtpModel(
        email: _emailController.text,
      ),
    );
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
            getAuthHeader(Localization.of().forgotPasswordHeader),
            const SizedBox(height: 10.0),
            _getEmailTextField(),
            const SizedBox(height: 10.0),
            _getSubmitButton(),
          ],
        ),
      ),
    ).authContainerScaffold(context: context, isLeadingEnable: true);
  }

  //Widgets
  Widget _getEmailTextField() {
    return PrimaryTextField(
      hint: Localization.of().email,
      focusNode: _phoneFocus,
      type: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      controller: _emailController,
      onFieldSubmitted: (value) {
        _phoneFocus.unfocus();
      },
      validateFunction: (value) {
        return value.toString().isValidEmail();
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
              setString(prefkeyEmailAddress, _emailController.text);
              _forgotPassword();
            }
          },
        ),
      ],
    );
  }
}
