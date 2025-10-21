import 'package:brain_memo/presentation/components/app_button.dart';
import 'package:brain_memo/presentation/components/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionsPickerBottomSheet extends StatelessWidget {
  final List<String> options;
  final String currentSelection;
  final ValueChanged<String> onOptionSelected;
  final String title;
  final double additionalHeight; // Adjust this value as needed
  final bool looping;

  const OptionsPickerBottomSheet({
    super.key,
    required this.options,
    required this.currentSelection,
    required this.onOptionSelected,
    required this.title,
    this.additionalHeight = 0.0,
    this.looping = false,
  });

  @override
  Widget build(BuildContext context) {
    int defaultIndex = 0;
    return SizedBox(
      height: 250.h + additionalHeight,
      child: Column(
        children: [
          SizedBox(height: 16.h),
          AppText(
            text: title,
            weight: FontWeight.w600,
            size: 18.sp,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              child: CupertinoPicker(
                itemExtent: 40.h,
                looping: looping,
                onSelectedItemChanged: (int index) {
                  onOptionSelected(options[index]);
                  defaultIndex = index;
                },
                children: options
                    .map(
                      (currency) => Center(
                        child: AppText(
                          text: currency,
                          weight: FontWeight.w500,
                          size: 18.sp,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          AppButton(
            label: "Confirmer",
            onTap: () {
              onOptionSelected(options[defaultIndex]);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
