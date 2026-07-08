import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';

import '../config/utils/colors.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    this.height,
    this.width,
    this.description,
    this.canScroll = false
  });
  final double? height, width;
  final String? description;
  final bool canScroll;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: !canScroll ? const NeverScrollableScrollPhysics()
          : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: <Widget>[
            ATImgLoader(
              imgPath: ATImgStrings.emptyStateImage,
              height: height, width: width,
            ),
            if(description != null) Text(
              description!, maxLines: 5,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall
                ?.copyWith(color: ATColors.white.withValues(alpha: 0.6)),
            )
          ],
        ),
      ),
    );
  }
}
