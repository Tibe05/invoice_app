import 'package:brain_memo/core/constants/app_colors.dart';
import 'package:brain_memo/presentation/components/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextfield extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final bool enabled;
  const AppTextfield({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.words,
    this.inputFormatters,
    this.obscureText = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    bool isObscured = obscureText;
    return Column(
      spacing: 5.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: AppText(text: label, size: 14.sp),
        ),
        StatefulBuilder(
          builder: (context, setState) {
            return TextFormField(
              controller: controller,
              cursorColor: const Color.fromARGB(117, 0, 0, 0),
              enabled: enabled,
              obscureText: isObscured,
              textCapitalization: textCapitalization,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: AppColor.subText),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.r),
                  borderSide:
                      BorderSide(color: const Color.fromARGB(117, 0, 0, 0)),
                ),
                suffixIcon: obscureText
                    ? IconButton(
                        icon: Icon(
                          isObscured ? Icons.visibility : Icons.visibility_off,
                          color: AppColor.subText,
                        ),
                        onPressed: () {
                          setState(() {
                            isObscured = !isObscured;
                          });
                        },
                      )
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }
}
