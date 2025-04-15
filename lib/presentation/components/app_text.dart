import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';

// ignore: must_be_immutable
class AppText extends StatelessWidget {
  final String text;
  final String family;
  final double? size;
  final double? lineHeight;
  final int? maxLine;
  final Color? color;
  FontWeight? weight;
  TextAlign? alignment;
  TextDecoration? underline;

  AppText({
    super.key,
    required this.text,
    required this.size,
    this.family = "Urbanist",
    this.underline = TextDecoration.none,
    this.lineHeight,
    this.maxLine = 2,
    this.color = AppColor.textColor,
    this.weight = FontWeight.normal,
    this.alignment = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignment,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.getFont(
        family,
        height: lineHeight,
        fontSize: size,
        fontWeight: weight,
        color: color,
        decoration: underline,
      ),

      // TextStyle(

      // ),
    );
  }
}
