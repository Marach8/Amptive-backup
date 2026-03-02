import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'custom_container_widget.dart';

class ATHashtagsWidget extends StatelessWidget {
  const ATHashtagsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <String>[
        'Society', 'Climate Change', 'JACKSCIPIO', 'attackingjacob',
        'Documentry',
      ].map(
        (String element) => IntrinsicWidth(
          child: ATContainer(
            margin: const EdgeInsets.only(bottom: 15, right: 15),
            padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
            alignment: Alignment.center, radius: 10,
            color: ATColors.white.withValues(alpha: 0.1),
            child: Row(
              children: <Widget>[
                const ATImgLoader(imgPath: ATImgStrings.HASH_ICON),
                const SizedBox(width: 2,),
                Flexible(
                  child: Text(
                    element,
                    style: context.textTheme.bodySmall!.copyWith(
                      color: ATColors.hexA8A8A8,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ).toList()
    );
  }
}
