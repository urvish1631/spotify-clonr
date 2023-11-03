import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sada_app/src/base/dependencyinjection/locator.dart';
import 'package:sada_app/src/base/extensions/scaffold_extension.dart';
import 'package:sada_app/src/base/extensions/string_extension.dart';
import 'package:sada_app/src/base/utils/common_ui_methods.dart';
import 'package:sada_app/src/base/utils/constants/color_constant.dart';
import 'package:sada_app/src/base/utils/constants/fontsize_constant.dart';
import 'package:sada_app/src/base/utils/constants/navigation_route_constants.dart';
import 'package:sada_app/src/base/utils/constants/preference_key_constant.dart';
import 'package:sada_app/src/base/utils/localization/localization.dart';
import 'package:sada_app/src/base/utils/navigation_utils.dart';
import 'package:sada_app/src/base/utils/preference_utils.dart';
import 'package:sada_app/src/controllers/auth/auth_controller.dart';
import 'package:sada_app/src/models/auth/login/req_login_model.dart';
import 'package:sada_app/src/widgets/primary_button.dart';
import 'package:sada_app/src/widgets/primary_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Variables
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  //API calling functions
  _loginApiCall() async {
    String numberWithCountryCode = _emailController.text.trim().toLowerCase();
    await locator<AuthController>().loginApiCall(
      context: context,
      model: ReqLoginModel(
        email: numberWithCountryCode,
        password: _passwordController.text,
      ),
    );
    await setString(prefkeyEmailAddress, numberWithCountryCode);
  }

@override
  void initState() {
    if(kDebugMode){
      _emailController.text = "urvish.sojitra@seaflux.tech";
      _passwordController.text = "Test1234";
    }
    super.initState();
  }
  //Build method
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getAuthHeader(Localization.of().login),
            const SizedBox(height: 10.0),
            _getEmailTextField(),
            const SizedBox(height: 10.0),
            _getPasswordTextField(),
            const SizedBox(height: 10.0),
            _getForgotPassword(),
            const SizedBox(height: 10.0),
            _getLoginButton(),
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
  Widget _getEmailTextField() {
    return PrimaryTextField(
      hint: Localization.of().email,
      focusNode: _emailFocus,
      type: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      controller: _emailController,
      onFieldSubmitted: (value) {
        _emailFocus.unfocus();
        _passwordFocus.requestFocus();
      },
      validateFunction: (phone) {
        return phone.toString().isValidEmail();
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
      },
      validateFunction: (value) {
        return value?.isFieldEmpty(Localization.of().msgPasswordEmpty);
      },
    );
  }

  Widget _getForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => locator<NavigationUtils>().push(routeForgotPassword),
            child: Text(
              Localization.of().forgotPassword,
              style: const TextStyle(
                color: whiteColor,
                fontSize: fontSize14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getCreatAccount() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, top: 0),
      child: RichText(
        text: TextSpan(
          text: Localization.of().dontHaveAccount,
          children: [
            TextSpan(
              text: Localization.of().register,
              recognizer: TapGestureRecognizer()
                ..onTap = () =>
                    locator<NavigationUtils>().pushReplacement(routeRegister),
              style: const TextStyle(
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getLoginButton() {
    return PrimaryButton(
      buttonText: Localization.of().login,
      buttonColor: primaryColor,
      onButtonClick: () {
        if (_formKey.currentState!.validate()) {
          _loginApiCall();
        }
      },
    );
  }
}
