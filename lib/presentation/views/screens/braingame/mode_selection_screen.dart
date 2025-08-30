import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:invoice_app/presentation/components/app_text.dart';
import 'package:invoice_app/presentation/views/screens/braingame/start_game_screen.dart';

import 'welcome_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    text: "Choose mode",
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
                              text: "Letters",
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
                              text: "Number",
                              weight: FontWeight.w600,
                              size: 32.sp,
                              color: Colors.white,
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
                padding: EdgeInsets.only(bottom: 20.h),
                child: SizedBox(
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
