import 'package:flutter/material.dart';

SnackBar mySnackbar(
    {required BuildContext context,
    required String text,
    required int duration}) {
  return SnackBar(
    backgroundColor: Theme.of(context).colorScheme.tertiary,
    content: Text(text, style: Theme.of(context).primaryTextTheme.titleMedium),
    duration: Duration(seconds: duration),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    {required BuildContext context,
    required String text,
    required int duration}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Theme.of(context).colorScheme.tertiary,
    content: Text(text, style: Theme.of(context).primaryTextTheme.titleMedium),
    duration: Duration(seconds: duration),
  ));
}
