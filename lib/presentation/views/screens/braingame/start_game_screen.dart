import 'package:brain_memo/l10n/app_localizations.dart';
import 'package:brain_memo/presentation/components/app_text.dart';
import 'package:brain_memo/presentation/views/screens/braingame/gameplay_with_timer.dart';
import 'package:brain_memo/presentation/views/screens/braingame/welcome_screen.dart';
import 'package:brain_memo/services/ads/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class StartGameScreen extends StatefulWidget {
  final String mode;
  const StartGameScreen({
    super.key,
    required this.mode,
  });

  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
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
                    text: "${loc.level} $level",
                    weight: FontWeight.w800,
                    size: 64.sp,
                    color: Colors.white,
                  ),
                  SizedBox(height: 68.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameplayWithTimer(
                                mode: widget.mode,
                                level: level,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 36.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFD154),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Center(
                            child: AppText(
                              text: loc.go,
                              weight: FontWeight.w600,
                              size: 32.sp,
                              color: Color(0xFF282727),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
