import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<String?> showSecurityQuestionsDialog(BuildContext context, List<String> items) {
  int selectedIndex = 0;

  return showCupertinoModalPopup<String>(
    context: context,
    builder: (dialogContext) {
      return ATContainer(
        height: 220,
        color: ATColors.hex292929,
        child: Column(
          children: [
            ATContainer(
              height: 40, color: ATColors.hex9E9E9E.withValues(alpha: 0.3),
              padding: const EdgeInsets.only(right: 15),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.pop(dialogContext, items[selectedIndex]),
                child: Text(
                  ATStrings.DONE,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: ATFontSizes.size16
                  )
                ),
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 40,     
                looping: true,
                onSelectedItemChanged: (int index) => selectedIndex = index,
                children: items.map(
                  (item) => Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: ATFontSizes.size20
                        ),
                      ),
                    ),
                  )
                ).toList(),
              ),
            ),
          ],
        ),
      );
    },
  );
}

