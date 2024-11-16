import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/font_sizes.dart';
import '../../../../../utils/constants/font_weights.dart';
import '../../../common_widgets/textformfield_widget.dart';

class CreateShowTextFormField extends AmptiveTextFormFieldWidget {
  const CreateShowTextFormField(
      {super.key,
        required super.controller,
        super.hintText,
        super.prefixIcon,
        super.suffixIcon,
        super.onChanged,
        super.keyboardType,
        this.onTap,
        this.readOnly = false,
        this.maxLength = 400,
        this.maxLines = 1,
        this.counterText = ""
      });

  final bool readOnly;
  final GestureTapCallback? onTap;
  final int maxLength;
  final int maxLines;
  final String counterText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      maxLength: maxLength,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        overflow: TextOverflow.ellipsis,
      ),
      decoration: InputDecoration(
        counterText: counterText,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: AmptiveFontSizes.size14,
          color: AmptiveColors.whiteColor.withOpacity(0.4),
          fontWeight: AmptiveFontWeights.medium,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: AmptiveColors.whiteColor.withOpacity(0.1),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.w,
            color: AmptiveColors.transparentColor,
          ),
          borderRadius: BorderRadius.circular(14.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.w,
            color: AmptiveColors.transparentColor,
          ),
          borderRadius: BorderRadius.circular(14.r),
        ), // Removes the border when not focused
      ),
    );
  }
}
