import 'package:flutter/material.dart';

import '../loading.dart';

dynamic showLoadingDialog({required BuildContext context}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Loading();
    },
  );
}
