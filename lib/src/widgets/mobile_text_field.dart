import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/src/providers/language_provider.dart';

import '../base/utils/constants/color_constant.dart';
import '../base/utils/constants/fontsize_constant.dart';

class MobileTextField extends StatefulWidget {
  final String hint;
  final FocusNode focusNode;
  final TextInputType type;
  final String? trailingIcon;
  final int? maxLength;
  final bool enabled;
  final bool isObscureText;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? textInputFormatter;
  final TextEditingController controller;
  final Function(PhoneNumber?)? onSaved;
  final String? Function(PhoneNumber?)? validateFunction;
  final Function? endIconClick;
  final Function(PhoneNumber)? onFieldSubmitted;
  final Function(PhoneNumber)? onChanged;
  final Function(Country)? onCountryChanged;
  final int maxLines;
  final bool autoFocus;

  const MobileTextField(
      {Key? key,
      required this.hint,
      required this.focusNode,
      required this.type,
      this.trailingIcon,
      this.isObscureText = false,
      required this.textInputAction,
      this.enabled = true,
      this.onSaved,
      this.maxLength,
      this.validateFunction,
      this.endIconClick,
      this.onCountryChanged,
      this.onFieldSubmitted,
      this.textInputFormatter,
      this.onChanged,
      required this.controller,
      this.maxLines = 1,
      this.autoFocus = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PrimaryTextFieldState();
}

class PrimaryTextFieldState extends State<MobileTextField> {
  bool _obscureText = true;
  String number = PhoneNumber(
          countryISOCode: Platform.localeName.split('_').last,
          countryCode: 'SA',
          number: '')
      .countryCode;

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(builder: (context, language, child) {
      return IntlPhoneField(
        initialCountryCode: 'SA',
        initialValue: number,
        pickerDialogStyle: PickerDialogStyle(
          backgroundColor: blackColor,
        ),
        cursorColor: primaryColor,
        autofocus: widget.autoFocus,
        controller: widget.controller,
        textInputAction: widget.textInputAction,
        focusNode: widget.focusNode,
        onCountryChanged: widget.onCountryChanged,
        enabled: widget.enabled,
        style: TextStyle(
          color: widget.enabled ? Colors.white : Colors.grey,
          fontSize: fontSize16,
          fontWeight: fontWeightRegular,
        ),
        languageCode: language.languageCode,
        decoration: InputDecoration(
          hintText: widget.hint,
          counter: const Offstage(),
          contentPadding: const EdgeInsets.all(20.0),
          errorStyle: const TextStyle(color: redColor),
          errorBorder: const OutlineInputBorder(
            gapPadding: 10.0,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: redColor, width: 1.0),
          ),
          errorMaxLines: 3,
          focusedBorder: const OutlineInputBorder(
            gapPadding: 10.0,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: primaryColor, width: 1),
          ),
          border: const OutlineInputBorder(
            gapPadding: 10.0,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: primaryColor, width: 1),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            gapPadding: 10.0,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: redColor, width: 1),
          ),
          suffixIcon:
              widget.isObscureText ? _passwordIcon() : _suffixIconCheck(),
        ),
        validator: widget.validateFunction,
        onSaved: widget.onSaved,
        inputFormatters: widget.textInputFormatter,
        keyboardType: widget.type,
        obscureText: widget.isObscureText ? _obscureText : false,
        onChanged: widget.onChanged,
      );
    });
  }

  _suffixIconCheck() => widget.trailingIcon != null
      ? GestureDetector(
          onTap: () {
            widget.endIconClick!();
          },
          child: SizedBox(
            height: 15,
            width: 15,
            child: Image.asset(
              widget.trailingIcon!,
              color: widget.endIconClick == null ? primaryTextColor : null,
              scale: 2.7,
            ),
          ),
        )
      : null;

  _passwordIcon() => InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        child: SizedBox(
          height: 15,
          width: 15,
          child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,
              color: secondaryColor),
        ),
      );
}
