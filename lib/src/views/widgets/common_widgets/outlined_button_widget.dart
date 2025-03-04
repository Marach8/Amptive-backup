import 'package:flutter/material.dart';


class AmptiveOutlinedButtonWidget extends StatelessWidget {
  final String buttonTitle;
  final Color? fgColor, bgColor;
  final void Function()? onPressed;
  final double? height;

  const AmptiveOutlinedButtonWidget({
    super.key,
    required this.buttonTitle,
    required this.onPressed,
    this.fgColor,
    this.bgColor,
    this.height
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: fgColor,
        backgroundColor: bgColor,
      ),
      onPressed: onPressed,
      child: Text(buttonTitle)
    );
  }
}