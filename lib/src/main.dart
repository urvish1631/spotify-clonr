import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:spotify_clone/src/base/utils/constants/navigation_route_constants.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/base/utils/preference_utils.dart';
import 'package:spotify_clone/src/providers/bottom_tabbar_provider.dart';
import 'package:spotify_clone/src/providers/article_provider.dart';
import 'package:spotify_clone/src/providers/comment_provider.dart';
import 'package:spotify_clone/src/providers/language_provider.dart';
import 'package:spotify_clone/src/providers/player_provider.dart';
import 'package:spotify_clone/src/providers/playlist_provider.dart';
import 'package:spotify_clone/src/providers/profile_data.provider.dart';
import 'package:spotify_clone/src/providers/search_provider.dart';
import 'package:spotify_clone/src/providers/theme_provier.dart';
import 'package:spotify_clone/src/widgets/themewidgets/theme_data.dart';
import 'package:provider/provider.dart';

import 'base/dependencyinjection/locator.dart';
import 'base/utils/navigation_utils.dart';

void mainDelegate() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await init();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio Playback',
    androidNotificationOngoing: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final botToastBuilder = BotToastInit();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileDataProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BottomTabBarProvider()),
        ChangeNotifierProvider(create: (_) => ArticlesProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => PlaylistProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeData, languageProvider, child) => RestartWidget(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Sada',
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: botToastBuilder(context, child),
              );
            },
            themeMode: themeData.getTheme() ? ThemeMode.dark : ThemeMode.light,
            theme: darkThemeData(),
            locale: languageProvider.locale,
            // darkTheme: darkThemeData(),
            navigatorObservers: [BotToastNavigatorObserver()],
            navigatorKey: locator<NavigationUtils>().navigatorKey,
            onGenerateRoute: locator<NavigationUtils>().generateRoute,
            initialRoute: routeSplash,
            localizationsDelegates: const [
              MyLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('ar', ''),
            ],
          ),
        ),
      ),
    );
  }
}

class RestartWidget extends StatefulWidget {
  final Widget child;

  const RestartWidget({Key? key, required this.child}) : super(key: key);

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
