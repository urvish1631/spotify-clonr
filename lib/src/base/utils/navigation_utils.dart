import 'package:flutter/material.dart';
import 'package:spotify_clone/src/base/utils/common_ui_methods.dart';
import 'package:spotify_clone/src/base/utils/constants/dic_params.dart';
import 'package:spotify_clone/src/ui/auth/confirm-password/confirm_password.dart';
import 'package:spotify_clone/src/ui/auth/forgot-password/forgot_password.dart';
import 'package:spotify_clone/src/ui/auth/get-started/get_started_screen.dart';
import 'package:spotify_clone/src/ui/auth/login/login_screen.dart';
import 'package:spotify_clone/src/ui/auth/otp/otp_screen.dart';
import 'package:spotify_clone/src/ui/auth/register/register_screen.dart';
import 'package:spotify_clone/src/ui/auth/select-role/select_role.dart';
import 'package:spotify_clone/src/ui/auth/splash-screen/splash_screen.dart';
import 'package:spotify_clone/src/ui/bottom_tabbar/bottom_tabbar.dart';
import 'package:spotify_clone/src/ui/comment_section/comment_section.dart';
import 'package:spotify_clone/src/ui/record_audio/publish_article.dart';
import 'package:spotify_clone/src/ui/record_audio/select_recording.dart';
import 'package:spotify_clone/src/ui/home/display_playlist_screen.dart';
import 'package:spotify_clone/src/ui/home/search_bar.dart';
import 'package:spotify_clone/src/ui/player-screen/player_screen.dart';
import 'package:spotify_clone/src/ui/profile/profile_edit_screen.dart';
import 'package:spotify_clone/src/ui/record_audio/update_written_article.dart';
import 'package:spotify_clone/src/ui/settings/language_change_screen.dart';
import 'package:spotify_clone/src/ui/settings/settings_screen.dart';
import 'package:spotify_clone/src/ui/profile/artist_profile_screen.dart';
import 'package:spotify_clone/src/ui/settings/terms_condition_screen.dart';

import 'constants/navigation_route_constants.dart';

class NavigationUtils {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get getCurrentContext {
    return _navigatorKey.currentContext!;
  }

  GlobalKey<NavigatorState> get navigatorKey {
    return _navigatorKey;
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case routeSplash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const SplashScreen(), // To pass args use as const SplashScreen(id: args?["id"])
        );
      case routeChooseRole:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const SelectRoleScreen(), // To pass args use as const SelectRoleScreen(id: args?["id"])
        );
      case routeGetStarted:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const GetStartedScreen(), // To pass args use as const GetStartedScreen(id: args?["id"])
        );
      case routeLogin:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const LoginScreen(), // To pass args use as const LoginScreen(id: args?["id"])
        );
      case routeOtp:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const OtpScreen(), // To pass args use as const OtpScreen(id: args?["id"])
        );
      case routeRegister:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const RegisterScreen(), // To pass args use as const RegisterScreen(id: args?["id"])
        );
      case routeForgotPassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const ForgotPassword(), // To pass args use as const ForgotPassword(id: args?["id"])
        );
      case routeAudioPlayer:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const PlayerScreen(), // To pass args use as const ForgotPassword(id: args?["id"])
        );
      case routeConfirmPassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const ConfirmPassword(), // To pass args use as const ConfirmPassword(id: args?["id"])
        );
      case routeTabBar:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const BottomTabBar(), // To pass args use as const BottomTabBar(id: args?["id"])
        );
      case routeArtistProfile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ArtistProfileScreen(
            artistId: args?[paramArtistId],
            isFollowed: args?[paramisFollowed],
          ), // To pass args use as const ArtistProfileScreen(id: args?["id"])
        );
      case routeSettings:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const SettingsScreen(), // To pass args use as const SettingsScreen(id: args?["id"])
        );
      case routeTermsAndCondition:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => TermsConditionScreen(
            fromTerms: args?[paramFromTerms],
          ), // To pass args use as const SettingsScreen(id: args?["id"])
        );
      case routeUpdateArticle:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => UpdateWrittenArticleScreen(
              articleData: args?[paramArticleData],
              isWritten: args?[
                  paramIsWrittenArticle]), // To pass args use as const SettingsScreen(id: args?["id"])
        );
      case routeDisplayPlaylist:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => DisplayPlaylistScreen(
            playlistData: args?[paramPlaylistData],
            fromPlaylistData: args?[paramFromPlaylistData],
            fromPlaylist: args?[paramFromPlayList],
          ), // To pass args use as const DisplayPlaylistScreen(id: args?["id"])
        );
      case routeEditProfile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => EditProfileScreen(
              imageUrl: args?[
                  paramImageUrl]), // To pass args use as const EditProfileScreen(id: args?["id"])
        );
      case routePublishArticle:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => PublishArticleScreen(
              isArticleRecorded: args?[paramArticleRecorded],
              articleData: args?[paramArticleData],
              articleId: args?[paramArticleId],
              writtenArticle: args?[paramWrittenArticle],
              fromProfile: args?[paramFromProfile],
              recordedFile: args?[
                  paramRecordedFile]), // To pass args use as const PublishArticleScreen(id: args?["id"])
        );
      case routeComments:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CommentScreen(
            articleId: args?[paramArticleId],
          ), // To pass args use as const CommentScreen(id: args?["id"])
        );
      case routeLanguageScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const LanguageChangeScreen(), // To pass args use as const LanguageChangeScreen(id: args?["id"])
        );
      case routeAudioRecorder:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const SelectRecordingScreen(), // To pass args use as const AudioRecorderScreen(id: args?["id"])
        );
      case routeSearch:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const SearchBarScreen(), // To pass args use as const SearchBarScreen(id: args?["id"])
        );
      default:
        return _errorRoute(" Comming soon...");
    }
  }

  Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: getEmptyTextWidget(text: message));
    });
  }

  void pushReplacement(String routeName, {Object? arguments}) {
    _navigatorKey.currentState
        ?.pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic>? push(String routeName, {Object? arguments}) {
    return _navigatorKey.currentState
        ?.pushNamed(routeName, arguments: arguments);
  }

  void pop({dynamic args}) {
    _navigatorKey.currentState?.pop(args);
  }

  Future<dynamic>? pushAndRemoveUntil(String routeName, {Object? arguments}) {
    return _navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName, (route) => false,
        arguments: arguments);
  }
}
