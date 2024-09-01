import 'package:flutter/material.dart';

class RawDialog extends StatelessWidget {
  final List<Widget> children;
  const RawDialog({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      alignment: Alignment.center,
      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      children: children,
    );
  }
}
