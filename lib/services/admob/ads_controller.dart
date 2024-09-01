import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsController {
  static String bannerId_01 = "ca-app-pub-3940256099942544/9214589741"; // """ca-app-pub-3166882328175414/5248333619";
  static String bannerId_02 = "ca-app-pub-3940256099942544/9214589741"; // "ca-app-pub-3166882328175414/9083598854";

  String interstitialId_01 = "ca-app-pub-3940256099942544/1033173712"; // """ca-app-pub-3166882328175414/5902901746";
  String rewardedId_01 = "ca-app-pub-3940256099942544/5224354917"; // "ca-app-pub-3166882328175414/2540078096";

  static AdSize banner = AdSize.banner;
  static AdSize mediumRectangle = AdSize.mediumRectangle;

  static AdRequest request = const AdRequest(
    keywords: <String>[
      'food',
      'gym',
      'hacking',
      'wordlist',
      'password',
      'generator',
      'movie',
      'youtube',
      'recipe',
      'news',
      'sale',
      'amazon',
      'flipkart',
      'games',
      'zomato',
      'swiggi',
      'google',
      'facebook',
      'microsoft',
      'ubisoft',
      'tiktok',
      'instagram',
      "bunny",
      "tacocat",
      "business"
    ],
    contentUrl: 'URL',
    nonPersonalizedAds: true,
  );

  static Future<void> initializeAdsInstance() async {
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        await MobileAds.instance
            .initialize()
            .then((InitializationStatus status) {
          MobileAds.instance.updateRequestConfiguration(
            RequestConfiguration(
                tagForChildDirectedTreatment:
                    TagForChildDirectedTreatment.unspecified,
                testDeviceIds: <String>["B3EEABB8EE11C2BE770B684D95219ECB"]),
          );
        });
        log("Ads Instance Initialized");
      } catch (e) {
        log(e.toString());
      }
    }
  }

  int retryLimit = 3;

  InterstitialAd? _interstitialAd;

  int retryInterstitial = 0;
  void createInterstitialAd() {
    try {
      InterstitialAd.load(
          adUnitId: interstitialId_01,
          request: request,
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              _interstitialAd = ad;
              _interstitialAd!.setImmersiveMode(true);
            },
            onAdFailedToLoad: (LoadAdError error) {
              _interstitialAd = null;
              if (retryLimit > retryInterstitial) {
                retryInterstitial++;
                createInterstitialAd();
              }
            },
          ));
    } catch (e) {
      log(e.toString());
    }
  }

  void showInterstitialAd() {
    if (_interstitialAd == null) {
      createInterstitialAd();
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {},
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  RewardedAd? _rewardedAd;

  int retryRewarded = 0;
  void createRewardedAd() {
    try {
      RewardedAd.load(
          adUnitId: rewardedId_01,
          request: request,
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              _rewardedAd = ad;
            },
            onAdFailedToLoad: (LoadAdError error) {
              _rewardedAd = null;
              if (retryLimit > retryRewarded) {
                retryRewarded++;
                createRewardedAd();
              }
            },
          ));
    } catch (e) {
      log(e.toString());
    }
  }

  void showRewardedAd() {
    try {
      if (_rewardedAd == null) {
        createRewardedAd();
        return;
      }
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) {},
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();
          createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          ad.dispose();
          createRewardedAd();
        },
      );
      _rewardedAd!.setImmersiveMode(true);
      _rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        ad.dispose();
        createRewardedAd();
      });
      _rewardedAd = null;
    } catch (e) {
      log(e.toString());
    }
  }
}
