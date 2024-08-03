import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:flutter/material.dart';

class AmptiveTextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String? hintText;
  final TextAlign? textAlign;
  final double? cursorHeight;
  final Widget? suffixIcon;
  final bool? obscureText;
  final Color? cursorColor;

  final InputDecoration? decoration;

  const AmptiveTextFormFieldWidget({
    super.key,
    required this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.textAlign,
    this.cursorHeight,
    this.hintText,
    this.cursorColor, this.decoration,
    this.suffixIcon,
    this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlign: textAlign ?? TextAlign.start,
      validator: validator,
      maxLines: 1,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      cursorColor: cursorColor ?? AmptiveColors.brandBlueColor,
      obscureText: obscureText ?? false,
      cursorHeight: cursorHeight,
      cursorErrorColor: AmptiveColors.textRedColor,
      keyboardType: keyboardType,
      decoration: decoration ??  InputDecoration(hintText: hintText, suffixIcon: suffixIcon),
      style: TextStyle(
        fontWeight: AmptiveFontWeights.regular,
        fontSize: AmptiveFontSizes.size18,
        color: AmptiveColors.whiteColor,
      ),
    );
  }
}
