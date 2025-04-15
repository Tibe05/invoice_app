
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

extension DialogExtensions on BuildContext {
  void showLoadingDialog() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColor.textColor),
          ),
        );
      },
    );
  }

  void dismissDialog() {
    Navigator.of(this, rootNavigator: true).pop();
  }
}
