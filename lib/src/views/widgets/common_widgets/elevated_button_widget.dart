import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveElevatedButtonWidget extends StatelessWidget {
  final String buttonTitle;
  final void Function() onPressed;

  const AmptiveElevatedButtonWidget({
    super.key,
    required this.buttonTitle,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(buttonTitle)
      ),
    );
  }
}