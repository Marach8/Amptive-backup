import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveOutlinedButtonWithLeadingIconWidget extends StatelessWidget {

  const AmptiveOutlinedButtonWithLeadingIconWidget({
    super.key,
    required this.buttonTitle,
    required this.onPressed,
    required this.leadingIcon
  });
  final String buttonTitle;
  final Widget leadingIcon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 50.h,
      child: OutlinedButton(
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.only(left: 5)),
        onPressed: onPressed,
        child: Row(
          children: <Widget>[
            leadingIcon,
            SizedBox(width: 50.w),
            Text(buttonTitle)
          ],
        ),
      ),
    );
  }
}