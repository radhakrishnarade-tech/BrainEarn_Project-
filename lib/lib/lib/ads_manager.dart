import 'package:flutter/material.dart';

class AdsManager {
  // ಎಲ್ಲಾ ಆಡ್ ನೆಟ್‌ವರ್ಕ್‌ಗಳನ್ನು ಒಟ್ಟಿಗೆ ಇನಿಶಿಯಲೈಸ್ ಮಾಡುವ ಫಂಕ್ಷನ್
  static Future<void> initAllAds() async {
    debugPrint("Initializing AdMob...");
    debugPrint("Initializing AppLovin...");
    debugPrint("Initializing Unity Ads...");
    debugPrint("Initializing Start.io...");
  }

  // ಪ್ರತಿ ಗೇಮ್ ಮುಗಿದಾಗ ಅಥವಾ ಟೈಮ್ ಔಟ್ ಆದಾಗ ಆಡ್ ತೋರಿಸಲು ಈ ಫಂಕ್ಷನ್ ಬಳಕೆಯಾಗುತ್ತದೆ
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
              onAdClosed(); // ಆಡ್ ಮುಗಿದ ಮೇಲೆ ಕಾಯಿನ್ಸ್ ಕ್ರೆಡಿಟ್ ಆಗಲು ಇದು ಮುಖ್ಯ
            },
            child: const Text("Skip / Close Ad"),
          ),
        ],
      ),
    );
  }

  // ಇಂಟರ್‌ಸ್ಟೀಶಿಯಲ್ ಆಡ್ಸ್ (ಪೂರ್ಣ ಸ್ಕ್ರೀನ್ ಆಡ್) ತೋರಿಸಲು
  static void showInterstitialAd(BuildContext context) {
    debugPrint("Showing Full Screen Interstitial Ad");
  }
}
