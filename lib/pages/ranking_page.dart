import 'dart:math';

import '../models/firestore/rank.dart';
import '../widget/cross_apps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/firestore/user.dart';
import '../providers/auth_service.dart';
import '../services/firestore.dart';
import '../utils/logger.dart';
import '../widget/event_button.dart';
import '../widget/loading.dart';
import 'error_page.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final IUser? user =
        Provider.of<AuthService>(context, listen: false).fireStoreUser;

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ranking",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),

                    // sign out button
                    EventButton(
                      tooltip: "Sign Out",
                      callback: () {
                        Provider.of<AuthService>(context, listen: false)
                            .signOut(context: context);
                      },
                      minWidth: 60,
                      child: Icon(
                        Icons.logout,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Divider(
                    color: Theme.of(context).colorScheme.tertiary,
                    height: 2,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user != null
                                ? user.name ?? "Unknown User"
                                : "Unknown User",
                            style:
                                Theme.of(context).primaryTextTheme.titleLarge,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: "Best Score:",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            TextSpan(
                              text:
                                  " ${user != null ? user.steps ?? "0" : "0"} Steps | ${user != null ? user.timeTaken ?? "0" : "0"} seconds",
                              style:
                                  Theme.of(context).primaryTextTheme.titleSmall,
                            ),
                          ])),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset("assets/placeholder.png"),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Divider(
                    color: Theme.of(context).colorScheme.tertiary,
                    height: 2,
                  ),
                ),
                const CrossAppPromotion(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Divider(
                    color: Theme.of(context).colorScheme.tertiary,
                    height: 2,
                  ),
                ),
                FutureBuilder(
                    future: FireStoreService().fetchRanks(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        // handle the error state
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style:
                                Theme.of(context).primaryTextTheme.titleMedium,
                          ),
                        );
                      }

                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          // handle the loading state
                          return const Loading();
                        case ConnectionState.done:
                          // handle the done state
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, i) {
                                  IRank rankUser = snapshot.data![i];

                                  return ListTile(
                                    shape: Border(
                                      bottom: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                    ),
                                    leading: Text(
                                      '${i + 1}',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .titleLarge
                                          ?.copyWith(fontSize: 40),
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(rankUser.name!,
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .titleMedium),
                                        const SizedBox(
                                            height:
                                                6.0), // Add gap between title and subtitle
                                        Text(
                                            '${rankUser.steps!} Steps | ${rankUser.timeTaken!} Seconds',
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .titleSmall),
                                      ],
                                    ),
                                    horizontalTitleGap: 10,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    onTap: () {},
                                  );
                                });
                          } else {
                            return Text('No data');
                          }
                        default:
                          // handle the other connection states

                          return Center(
                            child: Text(
                                'Connection state: ${snapshot.connectionState}',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium),
                          );
                      }
                    }),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
