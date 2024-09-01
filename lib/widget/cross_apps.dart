import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/firestore.dart';

class CrossAppPromotion extends StatelessWidget {
  const CrossAppPromotion({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FireStoreService().fetchCrossApps(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Check Our Apps",
                      style: Theme.of(context).primaryTextTheme.titleMedium,
                    ),
                  ),
                ),
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, i) {
                      dynamic obj = snapshot.data?[i];

                      return InkWell(
                        onTap: () async {
                          Uri url = Uri.parse(obj["url"]);
                          await launchUrl(url);
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: NetworkImage(obj["image"]),
                                fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox(
            height: 1,
          );
        });
  }
}
