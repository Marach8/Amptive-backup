import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AmptiveAppBarLeadingWidget extends StatelessWidget {
  final String? leadingText;
  final TextStyle? leadingStyle;
  const AmptiveAppBarLeadingWidget({
    super.key,
    this.leadingText,
    this.leadingStyle
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back_ios, size: 20.r,),
          Text(
            leadingText ?? AmptiveOtherStrings.back,
            style: leadingStyle ?? Theme.of(context).textTheme.titleMedium,
          )
        ],
      ),
    );
  }
}