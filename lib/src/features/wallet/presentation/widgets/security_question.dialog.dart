import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter/cupertino.dart';

Future<String?> showSecurityQuestionsDialog({
  required BuildContext context,
  required List<String> items,
}) {
  int selectedIndex = 0;

  return showCupertinoModalPopup<String>(
    context: context,
    builder: (BuildContext dialogContext) {
      return ATContainer(
        height: 220,
        color: ATColors.hex292929,
        child: Column(
          children: <Widget>[
            ATContainer(
              height: 40,
              color: ATColors.hex9E9E9E.withValues(alpha: 0.3),
              padding: const EdgeInsets.only(right: 15),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.pop(dialogContext, items[selectedIndex]),
                child: Text(ATStrings.done,
                    style: context.textTheme.bodySmall
                        ?.copyWith(fontSize: ATSizes.size16)),
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 40,
                looping: true,
                onSelectedItemChanged: (int index) => selectedIndex = index,
                children: items
                    .map((String item) => Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              item,
                              style: context.textTheme.labelSmall
                                  ?.copyWith(fontSize: ATSizes.size20),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      );
    },
  );
}
