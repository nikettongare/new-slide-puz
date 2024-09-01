import '../widget/dialogs/setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/puzzle_game.dart';
import '../services/admob/ads_controller.dart';
import '../services/admob/banner_ad_widget.dart';
import '../widget/event_button.dart';
import '../widget/puzzle.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width > 520.0)
        ? 500.0
        : MediaQuery.of(context).size.width - 20;

    return Scaffold(
      body: Consumer<PuzzleGame>(builder: (context, controller, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: BannerAdWidget(
                adUnitId: AdsController.bannerId_01,
                size: AdsController.banner,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      '${controller.movesCount}',
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleLarge
                          ?.copyWith(
                              color: Theme.of(context).colorScheme.tertiary),
                    ),
                    Text(
                      "Moves",
                      style: Theme.of(context).primaryTextTheme.titleSmall,
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${controller.timeTaken}',
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleLarge
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                    ),
                    Text(
                      "Time",
                      style: Theme.of(context).primaryTextTheme.titleSmall,
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Puzzle(width: width),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                EventButton(
                  callback: () {
                    controller.shuffleTiles();
                  },
                  minWidth: 30,
                  borderRadius: 50,
                  child: Icon(
                    Icons.shuffle_rounded,
                    size: 32,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                EventButton(
                  callback: () {
                    controller.restartGame();
                  },
                  minWidth: 30,
                  borderRadius: 50,
                  child: Icon(
                    Icons.loop_rounded,
                    size: 32,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                EventButton(
                  callback: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const SettingDialog();
                      },
                    );
                  },
                  minWidth: 30,
                  borderRadius: 50,
                  child: Icon(
                    Icons.settings_rounded,
                    size: 32,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: BannerAdWidget(
                adUnitId: AdsController.bannerId_02,
                size: AdsController.banner,
              ),
            ),
          ],
        );
      }),
    );
  }
}
