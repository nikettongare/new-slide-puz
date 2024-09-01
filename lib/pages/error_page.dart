import '../providers/auth_service.dart';
import '../widget/event_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ErrorPage extends StatefulWidget {
  final String message;
  final dynamic error;

  const ErrorPage({Key? key, required this.message, required this.error})
      : super(key: key);

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Icon(
                Icons.error_outline,
                size: 100,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),

              const SizedBox(
                height: 60,
              ),
              Text(
                widget.error,
                textAlign: TextAlign.center,
                style: Theme.of(context).primaryTextTheme.titleSmall,
              ),
              const SizedBox(
                height: 40,
              ),
              // sign out button
              EventButton(
                callback: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                minWidth: width,
                text: "Retry",
              ),
              const SizedBox(
                height: 40,
              ),
              EventButton(
                callback: () {
                  Provider.of<AuthService>(context, listen: false)
                      .signOut(context: context);
                },
                minWidth: width,
                text: "Sign Out",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
