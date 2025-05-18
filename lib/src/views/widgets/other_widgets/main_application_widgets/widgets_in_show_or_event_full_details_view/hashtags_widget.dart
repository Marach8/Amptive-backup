import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../common_widgets/custom_container_widget.dart';
import '../../../common_widgets/rich_text.dart';

class AmptiveHashtagsWidget extends StatelessWidget {
  const AmptiveHashtagsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        'Society', 'Climate Change', 'JACKSCIPIO', 'attackingjacob',
        'Documentry',
      ].map(
        (element) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IntrinsicWidth(
              child: ATContainer(
                margin: const EdgeInsets.only(bottom: 15,),
                padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
                alignment: Alignment.center,
                radius: 10,
                color: ATColors.white.withOpacity(0.1),
                child: ATRichText(
                  items: {
                    '# ': Theme.of(context).textTheme.bodyMedium!,
                    element : Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: ATColors.grey5Color,
                    ),
                  },
                )
              ),
            ),
            const Gap(15)
          ],
        ),
      ).toList()
    );
  }
}
