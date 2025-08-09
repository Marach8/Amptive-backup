import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class ATOutlinedBtn extends StatelessWidget {

  const ATOutlinedBtn({
    super.key,
    this.btnTitle,
    required this.onPressed,
    this.fgColor,
    this.bgColor,
    this.height,
    this.width,
    this.child
  });
  final String? btnTitle;
  final Color? fgColor, bgColor;
  final void Function()? onPressed;
  final double? height, width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: fgColor,
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
        ),
        fixedSize: Size(width ?? context.screenWidth, height ?? 54)
      ),
      child: child ?? Text(btnTitle ?? ''),
      
    );
  }
}


