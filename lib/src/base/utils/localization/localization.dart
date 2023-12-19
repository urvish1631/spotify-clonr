import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/utils/constants/app_constant.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:intl/intl.dart';

import 'localization_ar.dart';
import 'localization_en.dart';

class MyLocalizationsDelegate extends LocalizationsDelegate<Localization> {
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

// @override
// bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<Localization> load(Locale locale) => _load(locale);

  static Future<Localization> _load(Locale locale) async {
    final String name =
        (locale.countryCode == null || locale.countryCode!.isEmpty)
            ? locale.languageCode
            : locale as String;

    final localeName = Intl.canonicalizedLocale(name);
    Intl.defaultLocale = localeName;

    if (locale.languageCode == ar) {
      return LocalizationAR();
    } else {
      return LocalizationEN();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localization> old) => false;
}

abstract class Localization {
  static Localization of() {
    return Localizations.of<Localization>(
        locator<NavigationUtils>().getCurrentContext, Localization)!;
  }

  // Common Strings
  String get internetNotConnected;
  String get poorInternetConnection;
  String get alertPermissionNotRestricted;
  String get appName;
  String get ok;
  String get cancel;
  String get edit;
  String get delete;
  String get done;
  String get login;
  String get logout;
  String get galleryTitle;
  String get cameraTitle;
  String get yes;
  String get no;
  String get save;
  String get search;
  String get submit;

  // Auth Stringd
  String get phoneNumber;
  String get email;
  String get forgotPassword;
  String get password;
  String get confirmPassword;
  String get msgPhoneEmpty;
  String get msgEmailEmpty;
  String get msgNameEmpty;
  String get msgPhoneInvalid;
  String get msgEmailInvalid;
  String get msgPasswordEmpty;
  String get msgConfirmPasswordEmpty;
  String get msgPasswordError;
  String get msgPasswordNotMatch;
  String get dontHaveAccount;
  String get haveAccount;
  String get register;
  String get supportText;
  String get clickHere;
  String get resetPassword;
  String get forgotPasswordHeader;
  String get msgNoArticlesInPlaylist;

  // OTP screen
  String get otp;
  String get resendOtp;
  String get verificationText;
  String get msgVerificationCodeEmpty;
  String get msgVerificationCodeInvalid;

  //Bottom TabBar
  String get home;
  String get playList;
  String get recent;
  String get profile;

  //Start text
  String get getStarted;
  String get podcastForEveryone;
  String get creator;
  String get create;
  String get selectRole;
  String get user;
  String get continueText;

  //Headers
  String get recentlyPlayed;
  String get recommended;
  String get artists;
  String get category;
  String get articles;
  String get mostlyPlayed;
  String get nowPlaying;

  // Settings
  String get language;
  String get termsCondition;
  String get logoutText;
  String get settings;
  String get playlistName;
  String get english;
  String get arabic;
  String get selectLanguage;

  String get followers;
  String get myArticles;
  String get follow;
  String get following;
  String get noArticleCategory;
  String get record;
  String get remove;
  String get name;
  String get update;
  String get publish;
  String get addArticle;
  String get selectCategory;
  String get start;
  String get stop;
  String get pause;
  String get resume;
  String get noArtistArticle;
  String get comments;
  String get article;
  String get writeArticleHere;
  String get write;
  String get uploadPhoto;
  String get dataNotFound;
  String get searchArticle;
  String get editProfile;
  String get playListDeleteText;
  String get updatePassword;
  String get oldPassword;
  String get editArticle;
  String get deleteArticle;
  String get noCreatedArticles;
  String get addToPlaylist;
  String get loginSuccessfully;
  String get selectOption;
  String get selectImageMessage;
  String get noPlaylistMessage;
  String get createPlaylist;
  String get noRecentPlayArticle;
  String get msgArticleNameEmpty;
  String get msgPlaylistNameEmpty;
  String get msgWrittenArticleEmpty;
  String get msgCommentsEmpty;
  String get welcomeText;
  String get privacyPolicy;
  String get deleteAccount;
  String get msgDeleteAccount;
  String get alertPhotosPermission;
  String get alertCameraPermission;
  String get alertMicrophonePermission;
}
