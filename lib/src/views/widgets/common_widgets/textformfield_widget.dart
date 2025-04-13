import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:flutter/material.dart';


class ATTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String? hintText, counterText;
  final TextAlign? textAlign;
  final double? cursorHeight;
  final Widget? suffixIcon, prefixIcon, prefix, suffix;
  final bool? obscureText, disableBlueBorder, enabled;
  final Color? cursorColor, fillColor;
  final BoxConstraints? suffixConstraints,
  prefixConstraints, constraints;
  final InputDecoration? decoration;
  final InputBorder? enabledBorder;
  final FocusNode? focusNode;
  final TextStyle? hintStyle;
  final TextInputAction? textInputAction;
  final int? maxLines, maxLength;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? Function(
    BuildContext, {
      required int currentLength, 
      required bool isFocused, 
      required int? maxLength
    }
  )? buildCounter;

  const ATTextFormField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.textAlign,
    this.counterText,
    this.cursorHeight,
    this.hintText,
    this.enabledBorder,
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
    this.buildCounter,
    this.textInputAction,
    this.enabled,
    this.maxLength,
    this.prefix,
    this.suffix
  });

  @override
  Widget build(context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,      
      textAlign: textAlign ?? TextAlign.start,
      validator: validator,
      maxLines: maxLines, focusNode: focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      maxLength: maxLength,
      buildCounter: buildCounter,
      textInputAction: textInputAction,
      onSaved: onSaved,
      cursorColor: disableBlueBorder ?? false ? ATColors.white
        : ATColors.hex307FE2,
      obscureText: obscureText ?? false,
      cursorHeight: cursorHeight,
      cursorErrorColor: ATColors.textRedColor,
      keyboardType: keyboardType,
      style: TextStyle(
        fontWeight: ATFontWeights.w400,
        fontSize: ATFontSizes.size18,
        color: ATColors.white,
      ),
      decoration: decoration ?? InputDecoration(     
        counterText: counterText,   
        hintText: hintText,
        constraints: constraints,
        fillColor: fillColor, filled: fillColor != null,
        contentPadding: contentPadding ?? const EdgeInsets.fromLTRB(16, 12, 16, 12),
        focusedBorder: disableBlueBorder ?? false ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: ATColors.trsprnt)
        ) : null,
        hintStyle: hintStyle ?? Theme.of(context).textTheme.titleLarge?.copyWith(
          color: ATColors.strokeGreyColor,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        prefix: prefix, suffix: suffix,
        prefixIconConstraints: prefixConstraints ?? const BoxConstraints(
          maxHeight: 35,
          maxWidth: 35
        ),
        suffixIconConstraints: suffixConstraints ?? const BoxConstraints(
          maxHeight: 35,
          maxWidth: 35
        ),
        enabledBorder: enabledBorder
      ),
    );
  }
}





