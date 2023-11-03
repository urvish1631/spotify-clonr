import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sada_app/src/base/dependencyinjection/locator.dart';
import 'package:sada_app/src/base/extensions/scaffold_extension.dart';
import 'package:sada_app/src/base/extensions/string_extension.dart';
import 'package:sada_app/src/base/utils/common_ui_methods.dart';
import 'package:sada_app/src/base/utils/constants/app_constant.dart';
import 'package:sada_app/src/base/utils/constants/color_constant.dart';
import 'package:sada_app/src/base/utils/constants/navigation_route_constants.dart';
import 'package:sada_app/src/base/utils/constants/preference_key_constant.dart';
import 'package:sada_app/src/base/utils/localization/localization.dart';
import 'package:sada_app/src/base/utils/navigation_utils.dart';
import 'package:sada_app/src/base/utils/preference_utils.dart';
import 'package:sada_app/src/controllers/auth/auth_controller.dart';
import 'package:sada_app/src/models/auth/signup/req_signup_model.dart';
import 'package:sada_app/src/widgets/mobile_text_field.dart';
import 'package:sada_app/src/widgets/primary_button.dart';
import 'package:sada_app/src/widgets/primary_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //Variables
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _nameController = TextEditingController();
  final _nameFocus = FocusNode();
  final _confirmPasswordController = TextEditingController();
  final _confirmPasswordFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String _countryCode = "966";

  //API calling functions
  _signUpApiCalling() async {
    String numberWithCode = _phoneController.text.isNotEmpty
        ? '$_countryCode${_phoneController.text.trim()}'
        : '';
    await locator<AuthController>().signupApiCall(
        context: context,
        model: ReqSignUpModel(
          mobile: numberWithCode,
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text.trim(),
          userType: getBool(prefkeyIsCreator) ? creator : user,
          name: _nameController.text,
        ));
    await setString(
        prefkeyEmailAddress, _emailController.text.trim().toLowerCase());
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
            getAuthHeader(Localization.of().register),
            const SizedBox(height: 10.0),
            _getNameTextField(),
            const SizedBox(height: 10.0),
            _getEmailTextField(),
            const SizedBox(height: 10.0),
            _getMobileTextField(),
            const SizedBox(height: 10.0),
            _getPasswordTextField(),
            const SizedBox(height: 10.0),
            _getConfirmPasswordTextField(),
            const SizedBox(height: 20.0),
            _getRegisterButton(),
            const SizedBox(height: 40.0),
            _getCreatAccount(),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    ).authContainerScaffold(
      context: context,
      isLeadingEnable: getBool(prefkeyIsCreatorRegistered) ? false : true,
    );
  }

  //Widgets
  Widget _getNameTextField() {
    return PrimaryTextField(
      hint: Localization.of().name,
      focusNode: _nameFocus,
      type: TextInputType.text,
      textInputAction: TextInputAction.next,
      controller: _nameController,
      onFieldSubmitted: (value) {
        _nameFocus.unfocus();
        _emailFocus.requestFocus();
      },
      validateFunction: (value) {
        return value!.isFieldEmpty(Localization.of().msgNameEmpty);
      },
    );
  }

  Widget _getEmailTextField() {
    return PrimaryTextField(
      hint: Localization.of().email,
      focusNode: _emailFocus,
      type: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      controller: _emailController,
      onFieldSubmitted: (value) {
        _emailFocus.unfocus();
        _phoneFocus.requestFocus();
      },
      validateFunction: (value) {
        return value?.toString().isValidEmail();
      },
    );
  }

  Widget _getMobileTextField() {
    return MobileTextField(
      hint: Localization.of().phoneNumber,
      focusNode: _phoneFocus,
      type: TextInputType.phone,
      textInputAction: TextInputAction.next,
      controller: _phoneController,
      onFieldSubmitted: (value) {
        _phoneFocus.unfocus();
        _passwordFocus.requestFocus();
      },
      onCountryChanged: (value) {
        setState(() {
          _countryCode = value.dialCode;
        });
      },
      validateFunction: (value) {
        if (value!.number.isEmpty) {
          return null;
        }
        return null;
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

  Widget _getRegisterButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryButton(
          buttonText: Localization.of().register,
          buttonColor: primaryColor,
          onButtonClick: () {
            if (_formKey.currentState!.validate()) {
              _signUpApiCalling();
            }
          },
        ),
      ],
    );
  }

  Widget _getCreatAccount() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, top: 0),
      child: RichText(
        text: TextSpan(text: Localization.of().haveAccount, children: [
          TextSpan(
            text: Localization.of().login,
            recognizer: TapGestureRecognizer()
              ..onTap =
                  () => locator<NavigationUtils>().pushReplacement(routeLogin),
            style: const TextStyle(
              color: primaryColor,
            ),
          ),
        ]),
      ),
    );
  }
}
