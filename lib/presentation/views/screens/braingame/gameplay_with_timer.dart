import 'dart:async';
import 'dart:math';

import 'package:brain_memo/l10n/app_localizations.dart';
import 'package:brain_memo/presentation/components/app_text.dart';
import 'package:brain_memo/presentation/views/screens/braingame/gameplay_answer.dart';
import 'package:brain_memo/presentation/views/screens/braingame/welcome_screen.dart';
import 'package:brain_memo/services/ads/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GameplayWithTimer extends StatefulWidget {
  final String mode;
  final int? level;
  const GameplayWithTimer({
    super.key,
    this.mode = "Number",
    this.level,
  });

  @override
  State<GameplayWithTimer> createState() => _GameplayWithTimerState();
}

class _GameplayWithTimerState extends State<GameplayWithTimer> {
  final int totalDuration = 5; // in seconds
  Timer? _timer;

  double progress = 1.0;
  //Function to give random number or letter based on the mode the lenght of the string is based on the level
  //int level = 1;

  /// Mode can be 'letters', 'numbers', or 'mixed'
  String generateRandomString(int length, String mode) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    late String chars;

    switch (mode) {
      case 'letters':
        chars = letters;
        break;
      case 'number':
        chars = numbers;
        break;
      case 'mixed':
      default:
        chars = letters + numbers;
    }

    final rand = Random();
    rightAnswer =
        List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
    return rightAnswer;
  }

  void startSmoothTimer(additionalTime) {
    // bool levelNotNull = widget.level != null && widget.level! > 10;
    // final int additionalTime = levelNotNull ? 2 : 0;
    const tickInterval = Duration(milliseconds: 50); // smoother updates
    final int totalTicks = ((totalDuration + additionalTime) * 1000) ~/
        tickInterval.inMilliseconds;
    int currentTick = 0;

    _timer?.cancel();
    setState(() => progress = 1.0);

    _timer = Timer.periodic(tickInterval, (timer) {
      currentTick++;
      setState(() {
        progress = 1.0 - (currentTick / totalTicks);
      });

      if (currentTick >= totalTicks) {
        timer.cancel();
        setState(() => progress = 0.0);
        // 👇 Do your action here
        if (!context.mounted) return; // Check if context is still valid
        print("Timer complete, navigating to GameplayAnswer screen");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GameplayAnswer(
              mode: widget.mode,
            ),
          ),
        );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => GameplayAnswer(
        //       mode: widget.mode,
        //     ),
        //   ),
        // );
        print("⏱ Timer complete!");
      }
    });
  }

  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

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

  int additionalTime = 0;
  bool levelNotNull = false;
  @override
  void initState() {
    setAdditionalTime();
    startSmoothTimer(
        additionalTime); // Start the timer when the widget is initialized
    generateRandomString(level, widget.mode);
    _loadBannerAd();
    print(
        "Timer started with total duration: ${totalDuration + additionalTime} seconds");
    super.initState();
  }

  setAdditionalTime() {
    setState(() {
      levelNotNull = widget.level != null && widget.level! > 10;
      additionalTime = levelNotNull ? 2 : 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Clean up when widget is removed
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
                  //Serie to remember
                  TweenAnimationBuilder(
                    duration:
                        Duration(milliseconds: 500 + (additionalTime * 100)),
                    tween: Tween<double>(begin: 0.5, end: 1.0),
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: AppText(
                          text: rightAnswer,
                          weight: FontWeight.w800,
                          size: rightAnswer.length >= 10
                              ? 34.sp
                              : rightAnswer.length >= 5
                                  ? 64.sp
                                  : 128.sp,
                          alignment: TextAlign.center,
                          color: Colors.white,
                          maxLine: 50,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 43.h),
                  //Timer Progress Bar
                  Container(
                    width: 240.w,
                    height: 24.h,
                    //margin: EdgeInsets.only(bottom: 68.h),
                    decoration: BoxDecoration(
                      color: Color(0xFF02345C),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(50.r),
                        value: progress,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Level indicator
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 80.h),
                child: AppText(
                  text: "${loc.level} $level",
                  weight: FontWeight.w800,
                  size: 64.sp,
                  color: Colors.white,
                ),
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
