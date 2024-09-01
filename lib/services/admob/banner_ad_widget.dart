import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_controller.dart';

class BannerAdWidget extends StatefulWidget {
  final String adUnitId;
  final AdSize size;

  const BannerAdWidget({Key? key, required this.adUnitId, required this.size}) : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? bannerAd;

  @override
  void initState() {
    bannerAd = BannerAd(
      adUnitId: widget.adUnitId,
      size: widget.size,
      request: AdsController.request,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          log('Ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          log('Ad Failed To Load');
          ad.dispose();
        },
        onAdImpression: (ad) {
          log('Ad impression registered');
        },
        onAdClicked: (ad) {
          log('Ad click registered');
        },
      ),
    );
    bannerAd?.load();
    super.initState();
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: bannerAd?.size.width.toDouble(),
      height: bannerAd?.size.height.toDouble(),
      child: AdWidget(ad: bannerAd!),
    );
  }
}
