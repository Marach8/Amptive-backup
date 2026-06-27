import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/search_filter_widget.dart';
import 'package:flutter/material.dart';

class ATTextFormField extends StatelessWidget {
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
    this.focusedBorder,
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
    this.disabledBorder,
    this.suffix,
    this.isDense,
    this.filled,
    this.readOnly,
    this.onTap,
    this.onFieldSubmitted,
    this.onTapOutside,
    this.autoValidateMode,
  });

  final TextEditingController? controller;
  final void Function(String)? onChanged, onFieldSubmitted;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String? hintText, counterText;
  final TextAlign? textAlign;
  final double? cursorHeight;
  final Widget? suffixIcon, prefixIcon, prefix, suffix;
  final bool? obscureText,
      disableBlueBorder,
      enabled,
      filled,
      isDense,
      readOnly;
  final Color? cursorColor, fillColor;
  final BoxConstraints? suffixConstraints, prefixConstraints, constraints;
  final InputDecoration? decoration;
  final InputBorder? enabledBorder, focusedBorder, disabledBorder;
  final FocusNode? focusNode;
  final TextStyle? hintStyle;
  final TextInputAction? textInputAction;
  final int? maxLines, maxLength;
  final EdgeInsetsGeometry? contentPadding;
  final AutovalidateMode? autoValidateMode;
  final VoidCallback? onTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final Widget? Function(BuildContext,
      {required int currentLength,
      required bool isFocused,
      required int? maxLength})? buildCounter;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTapOutside: onTapOutside ?? (_) => FocusScope.of(context).unfocus(),
      enabled: enabled,
      textAlign: textAlign ?? TextAlign.start,
      validator: validator,
      maxLines: maxLines,
      focusNode: focusNode,
      autovalidateMode: autoValidateMode ?? AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      maxLength: maxLength,
      onTap: onTap,
      buildCounter: buildCounter,
      textInputAction: textInputAction,
      onSaved: onSaved,
      onFieldSubmitted: onFieldSubmitted,
      readOnly: readOnly ?? false,
      cursorColor:
          disableBlueBorder ?? false ? ATColors.white : ATColors.hex307FE2,
      obscureText: obscureText ?? false,
      cursorHeight: cursorHeight,
      cursorErrorColor: ATColors.textRedColor,
      keyboardType: keyboardType,
      style: TextStyle(
        fontWeight: ATFontWeights.w400,
        fontSize: ATSizes.size16,
        color: ATColors.white,
      ),
      decoration: decoration ??
          InputDecoration(
            counterText: counterText,
            hintText: hintText,
            isDense: isDense,
            errorMaxLines: 5,
            constraints: constraints,
            fillColor: fillColor ?? ATColors.white.withValues(alpha: 0.1),
            filled: filled ?? true,
            contentPadding: contentPadding ?? EdgeInsets.zero,
            focusedBorder: focusedBorder ??
                (disableBlueBorder ?? false
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: ATColors.transparent))
                    : null),
            hintStyle: hintStyle,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon ?? const ATSearchIcon(),
            prefix: prefix,
            suffix: suffix,
            prefixIconConstraints: prefixConstraints ??
                const BoxConstraints(maxHeight: 35, maxWidth: 35),
            suffixIconConstraints: suffixConstraints ??
                const BoxConstraints(maxHeight: 35, maxWidth: 35),
            enabledBorder: enabledBorder,
            disabledBorder: disabledBorder,
          ),
    );
  }
}
