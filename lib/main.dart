import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/auth_page.dart';
import 'pages/game_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/profile_page.dart';
import 'pages/ranking_page.dart';
import 'pages/error_page.dart';

import 'providers/auth_service.dart';
import 'providers/puzzle_game.dart';
import 'providers/theme_changer.dart';

import 'firebase_options.dart';
import 'config.dart';

import 'services/admob/ads_controller.dart';
import 'services/shared_preferences.dart';
import 'theme.dart';
import 'utils/logger.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await SharedPreferencesService.init();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await AdsController.initializeAdsInstance();
    runApp(const MyApp());
  }, (error, stack) {
    developerLog("$error and $stack");
    runApp(MyApp(
      error: error.toString(),
    ));
  });
}

class MyApp extends StatelessWidget {
  final String? error;
  const MyApp({super.key, this.error});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeChanger()),
        ChangeNotifierProvider(create: (_) => PuzzleGame()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
        StreamProvider<PendingDynamicLinkData?>.value(
          value: FirebaseDynamicLinks.instance.onLink,
          initialData: null,
        ),
        StreamProvider<PendingDynamicLinkData?>.value(
          value: FirebaseDynamicLinks.instance.getInitialLink().asStream(),
          initialData: null,
        ),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConfig.appName,
          theme: CustomThemes.lightTheme,
          darkTheme: CustomThemes.darkTheme,
          themeMode: Provider.of<ThemeChanger>(context).themeMode,
          initialRoute: error == null ? "/" : "/startup-error",
          routes: {
            "/": (context) => const AuthPage(),
            "/home": (context) => const HomePage(),
            "/login": (context) => const LoginPage(),
            "/game": (context) => const GamePage(),
            "/profile": (context) => const ProfilePage(),
            "/ranking": (context) => const RankingPage(),
            "/startup-error": (context) => ErrorPage(
                  message:
                      "Some unconditional error has occurred. We Informed our team The problem had been resolved very quickly.",
                  error: error.toString(),
                ),
          },
        );
      }),
    );
  }
}
