import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../config/utils/colors.dart';
import '../../../common_widgets/custom_container_widget.dart';

class AmptiveHashtagsWidget extends StatelessWidget {
  const AmptiveHashtagsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <String>[
        'Society', 'Climate Change', 'JACKSCIPIO', 'attackingjacob',
        'Documentry',
      ].map(
        (String element) => Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IntrinsicWidth(
              child: ATContainer(
                margin: const EdgeInsets.only(bottom: 15,),
                padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                alignment: Alignment.center, radius: 10,
                color: ATColors.white.withValues(alpha: 0.1),
                child: Row(
                  children: <Widget>[
                    const ATImgLoader(imgPath: ATImgStrings.HASH_ICON),
                    const SizedBox(width: 2,),
                    Text(
                      element,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: ATColors.hexA8A8A8,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Gap(15)
          ],
        ),
      ).toList()
    );
  }
}
