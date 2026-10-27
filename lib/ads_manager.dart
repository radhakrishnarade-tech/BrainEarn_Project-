import 'package:flutter/material.dart';

class AdsManager {
  static Future<void> initAllAds() async {
    debugPrint("Initializing AdMob...");
    debugPrint("Initializing AppLovin...");
    debugPrint("Initializing Unity Ads...");
    debugPrint("Initializing Start.io...");
  }

  static void showRewardedAd(BuildContext context, VoidCallback onAdClosed) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.video_collection, color: Colors.deepPurple),
            SizedBox(width: 10),
            Text("Loading Video Ad..."),
          ],
        ),
        content: const Text("Watching ad from AdMob/Unity/AppLovin/Start.io to claim 5 coins."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onAdClosed();
            },
            child: const Text("Skip / Close Ad"),
          ),
        ],
      ),
    );
  }

  static void showInterstitialAd(BuildContext context) {
    debugPrint("Showing Full Screen Interstitial Ad");
  }
}
