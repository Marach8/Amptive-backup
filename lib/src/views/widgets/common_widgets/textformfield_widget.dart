import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveTextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String? hintText;
  final TextAlign? textAlign;
  final double? cursorHeight;
  final Widget? suffixIcon, prefixIcon;
  final bool? obscureText, disableBlueBorder;
  final Color? cursorColor;
  final BoxConstraints? suffixConstraints, prefixConstraints;
  final InputDecoration? decoration;
  final FocusNode? focusNode;
  final TextStyle? hintStyle;

  const AmptiveTextFormFieldWidget({
    super.key,
    required this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.textAlign,
    this.cursorHeight,
    this.hintText,
    this.cursorColor, 
    this.decoration,
    this.suffixIcon,
    this.obscureText,
    this.prefixIcon,
    this.suffixConstraints,
    this.focusNode,
    this.hintStyle,
    this.onSaved,
    this.disableBlueBorder,
    this.prefixConstraints
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlign: textAlign ?? TextAlign.start,
      validator: validator,
      maxLines: 1, focusNode: focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      onSaved: onSaved,
      cursorColor: disableBlueBorder ?? false ? AmptiveColors.whiteColor
        : AmptiveColors.brandBlueColor,
      obscureText: obscureText ?? false,
      cursorHeight: cursorHeight,
      cursorErrorColor: AmptiveColors.textRedColor,
      keyboardType: keyboardType,
      decoration: decoration ??  InputDecoration(        
        hintText: hintText,
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12).r,
        focusedBorder: disableBlueBorder ?? false ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(14).r,
          borderSide: BorderSide(
            color: AmptiveColors.transparentColor
          )
        ) : null,
        hintStyle: hintStyle ?? Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AmptiveColors.strokeGreyColor
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        prefixIconConstraints: prefixConstraints ?? const BoxConstraints(
          maxHeight: 20,
          maxWidth: 35
        ),
        suffixIconConstraints: suffixConstraints ?? const BoxConstraints(
          maxHeight: 20,
          maxWidth: 35
        )
      ),
      style: TextStyle(
        fontWeight: AmptiveFontWeights.regular,
        fontSize: AmptiveFontSizes.size18,
        color: AmptiveColors.whiteColor,
      ),
    );
  }
}
