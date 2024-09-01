import '../utils/logger.dart';
import '../widget/dialogs/loading_dialog.dart';
import '../widget/dialogs/my_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_service.dart';
import '../widget/event_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailNode.dispose();
    super.dispose();
  }

  void onEmailSubmit({required BuildContext context}) async {
    FocusScope.of(context).unfocus();
    final String email = _emailController.value.text;

    // If email is empty or null
    if (email.isEmpty) {
      showSnackBar(
          context: context, text: "Please enter your email.", duration: 5);
      return;
    }

    final bool isValidEmail = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    // Email validator
    if (!isValidEmail) {
      showSnackBar(
          context: context,
          text: "Invalid email, Please enter the valid email.",
          duration: 5);
      return;
    }

    showLoadingDialog(context: context);

    try {
      await Provider.of<AuthService>(context, listen: false)
          .sendSignInWithEmailLink(email);
      if (context.mounted) {
        Navigator.of(context).pop();
        showSnackBar(
            context: context,
            text: "Email sent on '$email' successfully",
            duration: 5);
      }
    } catch (error) {
      developerLog(error);
      Navigator.of(context).pop();
      showSnackBar(
          context: context,
          text: "Error while sending email, error: $error",
          duration: 5);
      return;
    }
  }

  void googleSignInHandler({required BuildContext context}) async {
    try {
      await Provider.of<AuthService>(context, listen: false).signInWithGoogle();

      if (context.mounted) {
        Navigator.of(context).pop();
        showSnackBar(
            context: context,
            text: "User successfully Logged In.",
            duration: 5);
      }
    } catch (error) {
      developerLog(error);
      showSnackBar(
          context: context,
          text: "Error while google sign in, error: $error",
          duration: 5);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // logo
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      "assets/logo.png",
                      height: 140,
                      width: 140,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 50),

                  //
                  Text(
                    'Please enter your email, We will send login link on that.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).primaryTextTheme.titleSmall,
                  ),

                  const SizedBox(height: 25),
                  TextField(
                    controller: _emailController,
                    focusNode: _emailNode,
                    style: Theme.of(context).primaryTextTheme.titleMedium,
                    cursorColor: Colors.black,
                    cursorHeight: 24,
                    decoration: const InputDecoration(
                      hintText: "Enter your email",
                    ).applyDefaults(Theme.of(context).inputDecorationTheme),
                  ),

                  const SizedBox(height: 25),

                  EventButton(
                    callback: () {
                      onEmailSubmit(context: context);
                    },
                    text: "Sign In",
                    minWidth: width,
                  ),

                  const SizedBox(height: 20),

                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style:
                                Theme.of(context).primaryTextTheme.titleSmall,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // google sign in button
                  EventButton(
                    callback: () {
                      googleSignInHandler(context: context);
                    },
                    child: Image.asset(
                      "assets/icons/google.png",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
