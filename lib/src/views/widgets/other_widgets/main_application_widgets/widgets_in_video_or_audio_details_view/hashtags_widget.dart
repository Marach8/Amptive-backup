import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../common_widgets/container_for_rendering_other_widgets.dart';
import '../../../common_widgets/two_texts_rich_text_widget.dart';

class AmptiveHashtagsWidget extends StatelessWidget {
  const AmptiveHashtagsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        'Society', 'Climate Change', 'JACKSCIPIO', 'attackingjacob',
        'Documentry'
      ].map(
        (element) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IntrinsicWidth(
              child: AmptiveCustomContainer(
                margin: const EdgeInsets.only(bottom: 15,),
                padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
                alignment: Alignment.center,
                radius: 10,
                color: AmptiveColors.whiteColor.withOpacity(0.1),
                child: AmptiveTwoTextRichTextWidget(
                  text1: '# ',
                  text2: element,
                  style1: Theme.of(context).textTheme.bodyMedium,
                  style2: Theme.of(context).textTheme.bodySmall,
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
