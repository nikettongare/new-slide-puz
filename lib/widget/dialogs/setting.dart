import './raw_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/puzzle_game.dart';
import '../../providers/theme_changer.dart';

class SettingDialog extends StatelessWidget {
  const SettingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PuzzleGame>(builder: (context, controller, child) {
      return RawDialog(children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.playSound("tap");
              },
              child: Text(
                "CLOSE",
                style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
              ),
            ),
          ),
        ),
        Text(
          "Settings",
          style: Theme.of(context).primaryTextTheme.titleLarge,
        ),
        const SizedBox(
          height: 20,
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            "LAYOUT",
            style: Theme.of(context).primaryTextTheme.titleMedium,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(controller.availableLayouts.length, (i) {
              return InkWell(
                onTap: () {
                  controller.changeLevel(controller.availableLayouts[i]);
                  Navigator.of(context).pop();
                  controller.playSound("tap");
                },
                child: Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.tertiary,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "${controller.availableLayouts[i]}",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleMedium
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            "THEME",
            style: Theme.of(context).primaryTextTheme.titleMedium,
          ),
          trailing: TextButton(
            onPressed: () {
              context.read<ThemeChanger>().toggleTheme();
              controller.playSound("tap");
            },
            child: Text(
              (context.read<ThemeChanger>().isDarkMode) ? "DARK" : "LIGHT",
              style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            controller.restartGame();
            Navigator.of(context).pop();
            controller.playSound("tap");
          },
          child: Text(
            "RESTART",
            style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
          ),
        ),
      ]);
    });
  }
}
