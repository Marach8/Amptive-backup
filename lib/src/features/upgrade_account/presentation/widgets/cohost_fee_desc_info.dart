import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';

class CohostFeeDescInfo extends StatelessWidget {
  const CohostFeeDescInfo({
    super.key,
    required this.onClose,
  });
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
        radius: 14,
        margin: const EdgeInsets.only(bottom: 20),
        color: ATColors.hex9E9E9E.withValues(alpha: 0.3),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onClose,
                child: const Icon(Icons.close, size: 15),
              ),
            ),
            Row(
              children: <Widget>[
                const ATImgLoader(imgPath: ATImgStrings.INFO_ICON),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        ATStrings.whatIsCohostFee,
                        style: context
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: ATSizes.size15),
                      ),
                      Text(ATStrings.cohostFeeDesc,
                          maxLines: 3,
                          style: context
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: ATColors.hexC2C2C2)),
                    ],
                  ),
                ),
              ],
            )
          ],
        )
      );
  }
}
