import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoice_app/presentation/components/app_text.dart';
import 'package:invoice_app/presentation/views/screens/braingame/gameplay_with_timer.dart';
import 'package:invoice_app/presentation/views/screens/braingame/mode_selection_screen.dart';
import 'package:invoice_app/presentation/views/screens/braingame/welcome_screen.dart';

//const int level = 1; // Example level, can be dynamic

class GameplayAnswer extends StatefulWidget {
  final String mode;
  const GameplayAnswer({
    super.key,
    this.mode = "Number",
  });

  @override
  State<GameplayAnswer> createState() => _GameplayAnswerState();
}

class _GameplayAnswerState extends State<GameplayAnswer> {
  //Function to process the answer
  void processAnswer() {
    if (_controller.text.isNotEmpty) {
      // Show a message or handle empty input
      if (_controller.text.toLowerCase() == rightAnswer.toLowerCase()) {
        // Handle number input
        print("User entered the right answer: ${_controller.text}");
        // Increment level or show success message
        level++;
        log("Level: $level");
        // Navigate to the next screen or show success message
        FocusScope.of(context).unfocus();
        Future.delayed(Duration(milliseconds: 250), () {
          if (mounted) {
            // Reset the controller for the next input
            _controller.clear();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => GameplayWithTimer(
                    mode: widget.mode,
                  ),
                ));
          }
        });
      } else {
        // Handle letter input
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return TweenAnimationBuilder(
              duration: Duration(milliseconds: 350),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              curve: Curves.easeOut,
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: PopScope(
                    canPop: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 330.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(68.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 46.h,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppText(
                                text: "Level $level",
                                alignment: TextAlign.center,
                                weight: FontWeight.w800,
                                size: 36.sp,
                                color: Color(0xFF282727),
                              ),
                              AppText(
                                text: "GAME OVER",
                                alignment: TextAlign.center,
                                weight: FontWeight.w800,
                                size: 36.sp,
                                color: Color(0xFF282727),
                              ),
                              SizedBox(height: 14.h),
                              AppText(
                                text: "Your answer :",
                                alignment: TextAlign.center,
                                weight: FontWeight.w800,
                                size: 20.sp,
                                color: Color(0xFFaeadad),
                              ),
                              AppText(
                                text: _controller.text.toUpperCase(),
                                alignment: TextAlign.center,
                                weight: FontWeight.w800,
                                size: 32.sp,
                                maxLine: 5,
                                color: Color(0xFFaeadad),
                              ),
                              SizedBox(height: 14.h),
                              AppText(
                                text: "Correct answer :",
                                alignment: TextAlign.center,
                                weight: FontWeight.w800,
                                size: 20.sp,
                                color: Color(0xFF2B87D1),
                              ),
                              AppText(
                                text: rightAnswer.toUpperCase(),
                                alignment: TextAlign.center,
                                weight: FontWeight.w800,
                                size: 32.sp,
                                maxLine: 5,
                                color: Color(0xFF2B87D1),
                              ),
                              SizedBox(height: 32.h),
                              GestureDetector(
                                onTap: () {
                                  level = 1;
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WelcomeScreen()),
                                    (route) => false,
                                  );
                                },
                                child: Container(
                                  width: 204.w,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 36.w,
                                    vertical: 24.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2B87D1),
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                  child: Center(
                                    child: AppText(
                                      text: "PLAY AGAIN",
                                      weight: FontWeight.w600,
                                      size: 14.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
        print("User entered the wrong answer: ${_controller.text}");
      }
    }
  }

  //textfield controller for the user input
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    log("Correct answer: $rightAnswer");
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
                    text:
                        "What was the ${widget.mode == "number" ? "number" : level > 1 ? "letters" : "letter"}?",
                    weight: FontWeight.w800,
                    size: 40.sp,
                    maxLine: 3,
                    color: Colors.white,
                    alignment: TextAlign.center,
                  ),
                  // TextField for user input
                  Container(
                    width: 280.w,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Center(
                      child: IntrinsicWidth(
                        child: TextField(
                          textCapitalization: TextCapitalization.characters,
                          controller: _controller,
                          autofocus: true,
                          keyboardType: widget.mode == "number"
                              ? TextInputType.number
                              : TextInputType.text,
                          inputFormatters: widget.mode == "number"
                              ? [FilteringTextInputFormatter.digitsOnly]
                              : [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[a-zA-Z]'))
                                ],
                          style: TextStyle(
                            fontSize: _controller.text.length > 5
                                ? 54.sp
                                : _controller.text.length > 8
                                    ? 44
                                    : 64.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.none,
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              log("User submitted: $value");
                              processAnswer();
                            }
                          },
                          onChanged: (value) {
                            if (widget.mode != "number") {
                              _controller.value = _controller.value.copyWith(
                                text: value.toUpperCase(),
                                selection: TextSelection.collapsed(
                                    offset: value.length),
                              );
                            }
                            setState(
                                () {}); // Trigger rebuild to update font size
                          },
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: widget.mode == "number" ? "0" : "A",
                            hintStyle: TextStyle(
                              fontSize: 64.sp,
                              color: Colors.white.withAlpha(128),
                              fontWeight: FontWeight.w800,
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 50.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 51.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          processAnswer();
                        },
                        child: Container(
                          width: 265.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: 36.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFD154),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Center(
                            child: AppText(
                              text: "SEND",
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
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: EdgeInsets.only(bottom: 20.h),
            //     child: SizedBox(
            //       width: 49.w,
            //       height: 49.w,
            //       child: SvgPicture.asset(
            //         'assets/logo/logo-braingame.svg',
            //         width: 49.w,
            //         height: 49.w,
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
