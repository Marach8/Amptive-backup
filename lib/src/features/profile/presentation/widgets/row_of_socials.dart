import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../config/utils/image_strings.dart';
import '../../../../shared/image_loader_widget.dart' show ATImgLoader;

class RowOfSocials extends StatelessWidget {
  const RowOfSocials({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Iconsax.instagram, color: ATColors.hexC2C2C2, size: 15,),
        const SizedBox(width: 3),
        Text(
          ATStrings.INSTAGRAM,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: ATColors.hexC2C2C2
          ),
        ),
        const SizedBox(width: 15),
        const ATImgLoader(imgPath: ATImgStrings.X_LOGO),
        const SizedBox(width: 3),
        Text(
          'x',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: ATColors.hexC2C2C2
          ),
        ),
        const SizedBox(width: 15),
        FaIcon(FontAwesomeIcons.linkedin, color: ATColors.hexC2C2C2, size: 15),
        const SizedBox(width: 3),
        Text(
          ATStrings.LINKEDIN,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: ATColors.hexC2C2C2
          ),
        ),
        const SizedBox(width: 15),
        Transform.rotate(
          angle: -0.9,
          child: Icon(Icons.insert_link, color: ATColors.hexC2C2C2, size: 15),
        ),
        const SizedBox(width: 3),
        Text(
          ATStrings.WEBSITE,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: ATColors.hexC2C2C2
          ),
        ),
      ],
    );
  }
}