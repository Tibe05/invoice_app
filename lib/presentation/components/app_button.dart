import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';
import 'app_text.dart';

class AppButton extends StatelessWidget {
  final String label;
  final Function() onTap;
  final bool addMargin;
  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.addMargin = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 56.h,
        margin: addMargin
            ? EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 12.h,
              )
            : null,
        decoration: BoxDecoration(
          color: AppColor.textColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: AppText(
            text: label,
            size: 16.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
