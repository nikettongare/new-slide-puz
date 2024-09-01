import '../widget/cross_apps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_changer.dart';
import '../widget/event_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      "assets/logo.png",
                      height: width / 3,
                      width: width / 3,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  EventButton(
                    callback: () {
                      Navigator.of(context).pushNamed("/ranking");
                    },
                    text: "Ranking",
                    minWidth: width / 2.5,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  EventButton(
                    callback: () {
                      Navigator.of(context).pushNamed("/profile");
                    },
                    text: "Profile",
                    minWidth: width / 2.5,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  EventButton(
                    callback: () {
                      context.read<ThemeChanger>().toggleTheme();
                    },
                    text: "Theme",
                    minWidth: width / 2.5,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  EventButton(
                    callback: () {
                      Navigator.of(context).pushNamed("/game");
                    },
                    text: "PLAY",
                    minWidth: width / 3.5,
                    height: width / 3.5,
                    borderRadius: 70,
                  ),
                  const CrossAppPromotion(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
