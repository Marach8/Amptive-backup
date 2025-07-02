import 'package:flutter/material.dart';

class ATOutlinedBtn extends StatelessWidget {

  const ATOutlinedBtn({
    super.key,
    required this.buttonTitle,
    required this.onPressed,
    this.fgColor,
    this.bgColor,
    this.height
  });
  final String buttonTitle;
  final Color? fgColor, bgColor;
  final void Function()? onPressed;
  final double? height;

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