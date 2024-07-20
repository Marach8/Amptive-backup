import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AmptiveOutlinedButtonWithLeadingIconWidget extends StatelessWidget {
  final String buttonTitle;
  final Widget leadingIcon;
  final void Function()? onPressed;

  const AmptiveOutlinedButtonWithLeadingIconWidget({
    super.key,
    required this.buttonTitle,
    required this.onPressed,
    required this.leadingIcon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 50.h,
      child: OutlinedButton(
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.only(left: 5)),
        onPressed: onPressed,
        child: Row(
          children: [
            leadingIcon,
            Gap(50.w),
            Text(buttonTitle)
          ],
        ),
      ),
    );
  }
}