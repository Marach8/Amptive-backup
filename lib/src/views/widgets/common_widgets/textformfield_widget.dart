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
  final String? hintText, counterText;
  final TextAlign? textAlign;
  final double? cursorHeight;
  final Widget? suffixIcon, prefixIcon;
  final bool? obscureText, disableBlueBorder, enabled;
  final Color? cursorColor, fillColor;
  final BoxConstraints? suffixConstraints,
  prefixConstraints, constraints;
  final InputDecoration? decoration;
  final FocusNode? focusNode;
  final TextStyle? hintStyle;
  final int? maxLines, maxLength;
  final EdgeInsetsGeometry? contentPadding;

  const AmptiveTextFormFieldWidget({
    super.key,
    required this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.textAlign,
    this.counterText,
    this.cursorHeight,
    this.hintText,
    this.cursorColor, 
    this.decoration,
    this.constraints,
    this.suffixIcon,
    this.obscureText,
    this.prefixIcon,
    this.fillColor,
    this.maxLines,
    this.suffixConstraints,
    this.focusNode,
    this.hintStyle,
    this.onSaved,
    this.disableBlueBorder,
    this.prefixConstraints,
    this.contentPadding,
    this.enabled,
    this.maxLength
  });

  @override
  Widget build(context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      
      textAlign: textAlign ?? TextAlign.start,
      validator: validator,
      maxLines: maxLines ?? 1, focusNode: focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      maxLength: maxLength,
      onSaved: onSaved,
      cursorColor: disableBlueBorder ?? false ? ATColors.white
        : ATColors.hex307FE2,
      obscureText: obscureText ?? false,
      cursorHeight: cursorHeight,
      cursorErrorColor: ATColors.textRedColor,
      keyboardType: keyboardType,
      decoration: decoration ??  InputDecoration(     
        counterText: counterText,   
        hintText: hintText,
        constraints: constraints,
        fillColor: fillColor,
        contentPadding: contentPadding ?? const EdgeInsets.fromLTRB(16, 12, 16, 12).r,
        focusedBorder: disableBlueBorder ?? false ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(14).r,
          borderSide: BorderSide(
            color: ATColors.trsprtColor
          )
        ) : null,
        hintStyle: hintStyle ?? Theme.of(context).textTheme.titleLarge?.copyWith(
          color: ATColors.strokeGreyColor,
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
        ),
        enabledBorder: null
      ),
      style: TextStyle(
        fontWeight: ATFontWeights.w400,
        fontSize: ATFontSizes.size18,
        color: ATColors.white,
      ),
    );
  }
}





