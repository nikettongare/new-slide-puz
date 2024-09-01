import './raw_layout.dart';
import 'package:flutter/material.dart';

class WinGameDialog extends StatelessWidget {
  final String movesCount, timeTaken;
  final VoidCallback onRestartAction;
  const WinGameDialog(
      {super.key,
      required this.movesCount,
      required this.timeTaken,
      required this.onRestartAction});

  @override
  Widget build(BuildContext context) {
    return RawDialog(children: [
      Text(
        "Congratulations",
        textAlign: TextAlign.center,
        style: Theme.of(context).primaryTextTheme.titleMedium,
      ),
      const SizedBox(
        height: 20,
      ),
      Text(
        "You win!",
        textAlign: TextAlign.center,
        style: Theme.of(context).primaryTextTheme.titleLarge,
      ),
      const SizedBox(
        height: 15,
      ),
      Text(
        "Your score is \"$movesCount\" moves and \"$timeTaken\" seconds of time.",
        textAlign: TextAlign.center,
        style: Theme.of(context).primaryTextTheme.titleMedium,
      ),
      const SizedBox(
        height: 25,
      ),
      TextButton(
        onPressed: onRestartAction,
        child: Text(
          "RESTART",
          style: Theme.of(context)
              .primaryTextTheme
              .titleMedium
              ?.copyWith(color: Theme.of(context).colorScheme.tertiary),
        ),
      ),
    ]);
  }
}



/*

*/