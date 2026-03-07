import 'package:amptive/src/models/hashtag.dart';
import 'package:amptive/src/models/host.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/utils/colors.dart';
import '../../../../../config/utils/font_sizes.dart';
import '../../../../../config/utils/font_weights.dart';
import '../../../../../shared/textformfield_widget.dart';

class CreateShowTextFormField extends ATTextFormField {
  const CreateShowTextFormField(
      {super.key,
      super.controller,
      super.hintText,
      super.prefixIcon,
      super.suffixIcon,
      super.onChanged,
      super.keyboardType,
      this.onTap,
      this.readOnly = false,
      this.maxLength = 400,
      this.maxLines = 1,
      this.counterText = ""});

  @override
  final bool readOnly;
  @override
  final GestureTapCallback? onTap;
  @override
  final int maxLength;
  @override
  final int maxLines;
  @override
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
          fontSize: ATSizes.size14,
          color: ATColors.white.withOpacity(0.4),
          fontWeight: ATFontWeights.w500,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: ATColors.white.withOpacity(0.1),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.w,
            color: ATColors.transparent,
          ),
          borderRadius: BorderRadius.circular(14.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.w,
            color: ATColors.transparent,
          ),
          borderRadius: BorderRadius.circular(14.r),
        ), // Removes the border when not focused
      ),
    );
  }
}

class CreateShowTextFieldTitle extends StatelessWidget {
  const CreateShowTextFieldTitle({
    super.key,
    required this.title,
    this.otherInfo,
    this.prefixIcon,
    this.titleStyle,
  });
  final String title;
  final String? otherInfo;
  final IconData? prefixIcon;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Visibility(
          visible: prefixIcon != null,
          child: Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Icon(
              prefixIcon,
              size: 18.h,
            ),
          ),
        ),
        Text(
          title,
          style: titleStyle ??
              Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontSize: ATSizes.size15),
        ),
        Expanded(
            child: SizedBox(
          width: 1.w,
        )),
        Text(
          otherInfo ?? "",
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: ATColors.white.withOpacity(0.4)),
        ),
      ],
    );
  }
}

class SelectedHashTags extends StatelessWidget {
  const SelectedHashTags({
    super.key,
    required this.hashtags,
    required this.onRemove,
  });

  final Set<ObjectWithNotifier<Hashtag>> hashtags;
  final Function(ObjectWithNotifier<Hashtag>) onRemove;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: hashtags.map((ObjectWithNotifier<Hashtag> hashtag) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: ATColors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    hashtag.obj.name,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: ATSizes.size10,
                          color: ATColors.white.withOpacity(0.7),
                        ),
                  ),
                  SizedBox(width: 4.w),
                  GestureDetector(
                    onTap: () => onRemove(hashtag),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: ATColors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
