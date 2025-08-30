import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:invoice_app/presentation/components/app_text.dart';
import 'package:invoice_app/presentation/views/screens/braingame/gameplay_with_timer.dart';
import 'package:invoice_app/presentation/views/screens/braingame/welcome_screen.dart';

class StartGameScreen extends StatelessWidget {
  final String mode;
  const StartGameScreen({
    super.key,
    required this.mode,
  });

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
                    text: "Level $level",
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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameplayWithTimer(
                                mode: mode,
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
                              text: "GO",
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
