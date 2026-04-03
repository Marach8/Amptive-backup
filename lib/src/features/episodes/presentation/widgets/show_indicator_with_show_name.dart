import 'package:amptive/src/shared/show_event_nd_paid_icons.dart';
import 'package:flutter/material.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:go_router/go_router.dart';


class ShowIndicatorWithShowName extends StatelessWidget {
  const ShowIndicatorWithShowName({
    super.key,
    required this.titleOfParentShow,
    this.onTappOverride,
  });

  final String titleOfParentShow;
  final VoidCallback? onTappOverride;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTappOverride ?? () => context.pop(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: <Widget>[
          const ATShowIcon(),
          Text(
            titleOfParentShow,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: ATSizes.size15,
              color: ATColors.dimWhiteColor1
            ),
          ),
        ],
      ),
    );
  }
}
