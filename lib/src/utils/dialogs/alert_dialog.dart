import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String yesString,
  required String noString
}) async{
  return await showDialog<bool?>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AmptiveColors.indicatorDark.withValues(alpha: 0.82),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: AmptiveFontSizes.size17,
        ),
      ),
      content: Text(
        content, maxLines: 3, textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: AmptiveFontSizes.size13,
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        GestureDetector(
          onTap: () => context.pop(true),
          child: Text(
            yesString,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: AmptiveFontSizes.size17,
              color: AmptiveColors.brandBlue
            ),
          ),
        ),
        GestureDetector(
          onTap: () => context.pop(false),
          child: Text(
            noString,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: AmptiveFontSizes.size17,
              color: AmptiveColors.brandBlue
            ),
          ),
        ),
      ],
    )
  );
}