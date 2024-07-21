import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:flutter/material.dart';

class AmptiveTextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Widget? label;
  final String? hintText;
  final TextAlign? textAlign;
  final double? cursorHeight;
  final int? maxLength;
  final FloatingLabelBehavior? floatingLabelBehavior;

  const AmptiveTextFormFieldWidget({
    super.key,
    required this.controller,
    this.validator,
    this.onChanged,
    this.label,
    this.keyboardType,
    this.textAlign,
    this.cursorHeight,
    this.hintText,
    this.maxLength,
    this.floatingLabelBehavior
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      controller: controller,
      textAlign: textAlign ?? TextAlign.start,
      validator: validator,
      onChanged: onChanged,
      cursorHeight: cursorHeight,
      cursorColor: AmptiveColors.brandBlueColor,
      cursorErrorColor: AmptiveColors.textRedColor,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        label: label,
        floatingLabelBehavior: floatingLabelBehavior
      ),
      style: TextStyle(
        fontWeight: AmptiveFontWeights.regular,
        fontSize: AmptiveFontSizes.size18,
        color: AmptiveColors.whiteColor,
      ),
    );
  }
}