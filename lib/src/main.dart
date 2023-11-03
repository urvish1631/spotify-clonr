import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sada_app/src/base/utils/constants/navigation_route_constants.dart';
import 'package:sada_app/src/base/utils/localization/localization.dart';
import 'package:sada_app/src/base/utils/preference_utils.dart';
import 'package:sada_app/src/providers/theme_provier.dart';
import 'package:sada_app/src/widgets/themewidgets/theme_data.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'base/dependencyinjection/locator.dart';
import 'base/utils/navigation_utils.dart';

void mainDelegate() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await init();
  // await initializeDateFormatting('en_US');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeData, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'flutter-boilerplate',
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child ?? Container(),
            );
          },
          themeMode: themeData.getTheme() ? ThemeMode.dark : ThemeMode.light,
          theme: lightThemeData(),
          darkTheme: darkThemeData(),
          navigatorKey: locator<NavigationUtils>().navigatorKey,
          onGenerateRoute: locator<NavigationUtils>().generateRoute,
          initialRoute: routeLogin,
          localizationsDelegates: const [
            MyLocalizationsDelegate(),
            // DefaultMaterialLocalizations.delegate,
            // DefaultWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],
        ),
      ),
    );
  }
}
