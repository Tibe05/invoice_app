import 'package:brain_memo/l10n/app_localizations.dart';
import 'package:brain_memo/presentation/components/app_text.dart';
import 'package:brain_memo/presentation/views/screens/braingame/start_game_screen.dart';
import 'package:brain_memo/services/ads/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

import 'welcome_screen.dart';

class ModeSelectionScreen extends StatefulWidget {
  const ModeSelectionScreen({super.key});

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId, 
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() => _isBannerAdReady = true);
        },
        onAdFailedToLoad: (ad, err) {
          print('Banner failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WelcomeScreen(),
              )),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 24.sp,
          ),
        ),
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
      ),
      backgroundColor: Color(0xFF2B87D1),
      body: Center(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AppText(
                    text: loc.chooseMode,
                    weight: FontWeight.w600,
                    size: 40.sp,
                    color: Colors.white,
                  ),
                  SizedBox(height: 68.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Posthog()
                              .capture(eventName: "modeLetters", properties: {
                            "mode": "letters",
                          });
                          level =
                              1; // Reset level to 1 when entering mode selection
                          rightAnswer =
                              ""; // Reset right answer when entering mode selection
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StartGameScreen(
                                  mode: "letters",
                                ),
                              ));
                        },
                        child: Container(
                          width: 265.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: 55.w, vertical: 11.h),
                          decoration: BoxDecoration(
                            color: Color(0xFF02345C),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Center(
                            child: AppText(
                              text: loc.letters,
                              weight: FontWeight.w600,
                              size: 32.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Posthog()
                              .capture(eventName: "modeNumbers", properties: {
                            "mode": "numbers",
                          });
                          level =
                              1; // Reset level to 1 when entering mode selection
                          rightAnswer =
                              ""; // Reset right answer when entering mode selection
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StartGameScreen(
                                  mode: "number",
                                ),
                              ));
                        },
                        child: Container(
                          width: 265.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: 55.w, vertical: 11.h),
                          decoration: BoxDecoration(
                            color: Color(0xFF02345C),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Center(
                            child: AppText(
                              text: loc.numbers,
                              weight: FontWeight.w600,
                              size: 32.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 64.h),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 50.h),
                child: _isBannerAdReady
                    ? SizedBox(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      )
                    : SizedBox(
                        width: 49.w,
                        height: 49.w,
                        child: SvgPicture.asset(
                          'assets/logo/logo-braingame.svg',
                          width: 49.w,
                          height: 49.w,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
