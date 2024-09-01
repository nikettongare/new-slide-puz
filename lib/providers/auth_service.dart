import 'dart:async';
import '../utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/firestore/user.dart';
import '../services/firestore.dart';
import '../services/shared_preferences.dart';
import '../utils/safe_promise.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Stream<PendingDynamicLinkData?> get dynamicLinkState =>
      FirebaseDynamicLinks.instance.onLink;

  FireStoreService fireStoreService = FireStoreService();

  IUser? _fireStoreUser;
  IUser? get fireStoreUser => _fireStoreUser;

  void setFireStoreUser(IUser newUser) {
    _fireStoreUser = newUser;
  }

  // Google Sign In instance
  final _googleSignIn = GoogleSignIn();

  Future<void> sendSignInWithEmailLink(String email) async {
    try {
      await _firebaseAuth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: ActionCodeSettings(
          url: 'https://crypticpuzzler.page.link/89eQ?email=$email',
          handleCodeInApp: true,
          iOSBundleId: 'com.example.cryptic_puzzle',
          androidPackageName: 'com.example.cryptic_puzzle',
          androidInstallApp: true,
          androidMinimumVersion: '21',
        ),
      );

      // store the user's email to shared pref (used when we verify dynamic link)
      SharedPreferencesService.instance.setString('passwordLessEmail', email);
    } catch (error) {
      return Future.error('Error sending email verification $error');
    }
  }

  // function which retrieve the dynamic link and verify the authentication
  Future<IUser> verifySignInLink({required Uri deepLink}) async {
    // check the email is empty
    if (deepLink.toString().isEmpty) {
      return Future.error('deepLink is empty.');
    }

    // get the stored email from shared pref
    String email =
        SharedPreferencesService.instance.getString('passwordLessEmail') ?? '';

    // check the email is empty
    if (email.isEmpty) {
      return Future.error('No email saved in shared pref.');
    }

    // if found the link then authenticate the user
    bool validLink = _firebaseAuth.isSignInWithEmailLink(deepLink.toString());

    // if user not authenticate
    if (!validLink) {
      return Future.error('Invalid Dynamic Link.');
    }

    final result = await promiseHandler(_firebaseAuth.signInWithEmailLink(
      email: email,
      emailLink: deepLink.toString(),
    ));

    if (result.hasError) {
      return Future.error(
          'Error when signInWithEmailLink using email: $email and link: ${deepLink.toString()} error: ${result.error}');
    }

    UserCredential userCredential = result.response;

    if (userCredential.user == null) {
      return Future.error('User not authenticated.');
    }

    final userResult = await promiseHandler(
        fireStoreService.fetchUserIfExistsOrSet(
            userCredential.user!.uid,
            IUser(
                uid: userCredential.user!.uid,
                email: userCredential.user!.email,
                provider: "password less",
                isProfileComplete: false,
                isActive: true,
                steps: 0,
                timeTaken: 0,
                createdAt: fireStoreService.getCurrentTimestamp,
                updatedAt: fireStoreService.getCurrentTimestamp)));

    if (userResult.hasError) {
      return Future.error('Unable to connect with firestore.');
    }
    // remove the email from shared pref
    SharedPreferencesService.instance.setString('passwordLessEmail', '');

    return userResult.response;
  }

  Future<IUser> signInWithGoogle() async {
    // Get the Google sign-in account
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    // Get the Google sign-in authentication token
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    // Create a Firebase credential from the Google authentication token
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    // Sign in to Firebase with the Google credential
    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);

    if (userCredential.user == null) {
      return Future.error('User not authenticated.');
    }

    final userResult = await promiseHandler(
        fireStoreService.fetchUserIfExistsOrSet(
            userCredential.user!.uid,
            IUser(
                uid: userCredential.user!.uid,
                email: userCredential.user!.email,
                provider: "google",
                isProfileComplete: false,
                isActive: true,
                steps: 0,
                timeTaken: 0,
                createdAt: fireStoreService.getCurrentTimestamp,
                updatedAt: fireStoreService.getCurrentTimestamp)));

    if (userResult.hasError) {
      return Future.error('Unable to connect with firestore.');
    }
    return userResult.response;
  }

  Future<void> signOut({required BuildContext context}) async {
    try {
      // firebase auth sign out
      await _firebaseAuth.signOut();
      // google auth sign out
      await _googleSignIn.signOut();

      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed("/");
      }
    } catch (error) {
      developerLog("Error when signing out the user: $error");
      Future.error("Error when signing out the user!");
    }
  }
}
