import 'package:flutter/material.dart';
import 'package:spotify_clone/src/base/utils/constants/app_constant.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale(ar); // Default language is English

  Locale get locale => _locale;

  String get languageCode => _locale.languageCode;

  void changeLanguage(Locale locale) {
    _locale = locale;
    const MyLocalizationsDelegate().load(locale);
    notifyListeners();
  }
}
