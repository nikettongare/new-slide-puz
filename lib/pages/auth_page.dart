import '../pages/error_page.dart';
import '../pages/profile_page.dart';
import '../providers/auth_service.dart';
import '../services/firestore.dart';
import '../utils/logger.dart';
import '../widget/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    bool loggedIn = user != null;
    final dynamicLink = Provider.of<PendingDynamicLinkData?>(context);

    if (loggedIn) {
      return FutureBuilder(
          future: FireStoreService().fetchUser(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                developerLog(snapshot.error);
                return ErrorPage(
                    message: "Unable to find user in firestore.",
                    error: snapshot.error.toString());
              }

              if (snapshot.hasData) {
                Provider.of<AuthService>(context, listen: false)
                    .setFireStoreUser(snapshot.data!);
              }

              if (snapshot.hasData && snapshot.data!.isProfileComplete!) {
                return const HomePage();
              } else {
                return const ProfilePage();
              }
            } else {
              return const SafeArea(
                  child: Scaffold(
                body: Loading(),
              ));
            }
          });
    }

    if (dynamicLink != null) {
      final Uri deepLink = dynamicLink.link;

      return FutureBuilder(
          future: Provider.of<AuthService>(context, listen: false)
              .verifySignInLink(deepLink: deepLink),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                developerLog(snapshot.error);
                return ErrorPage(
                    message: "Unable to verify dynamic link.",
                    error: snapshot.error);
              }

              if (snapshot.hasData) {
                Provider.of<AuthService>(context, listen: false)
                    .setFireStoreUser(snapshot.data!);
              }

              if (snapshot.hasData && snapshot.data!.isProfileComplete!) {
                return const HomePage();
              } else {
                return const ProfilePage();
              }
            } else {
              return const Loading();
            }
          });
    }

    return const LoginPage();
  }
}
