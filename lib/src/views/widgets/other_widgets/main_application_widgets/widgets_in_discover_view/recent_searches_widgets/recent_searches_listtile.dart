import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'container_with_picture.dart';

class AmptiveRecentSearchesListTileWidget extends StatelessWidget {
  final String title, leadingImagePath;
  final bool isCircular;

  const AmptiveRecentSearchesListTileWidget({
    super.key,
    required this.title,
    required this.leadingImagePath,
    this.isCircular = false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        
        minTileHeight: 60,
        dense: true,
        contentPadding: const EdgeInsets.only(bottom:8),
        leading: AmptivePictureWidget(
          imagePath: leadingImagePath,
          diameter: 50,
          radius: 5,
          isCircular: isCircular,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: AmptiveFontWeights.medium,
            height: 1
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              'Show',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AmptiveColors.subtitleColor,
                fontWeight: AmptiveFontWeights.medium,
                fontSize: AmptiveFontSizes.size13,
                height: 1.5
              ),
            ),
            const Gap(5),
            const AmptiveCirceAvatarWidget(diameter: 3),
            const Gap(5),
            Text(
              'MONDAY AT 20:00',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AmptiveColors.subtitleColor,
                fontWeight: AmptiveFontWeights.medium,
                fontSize: AmptiveFontSizes.size13,
                height: 1.5
              ),
            ),
          ],
        ),

        trailing: GestureDetector(
          onTap: (){},
          child: Icon(Icons.close, size: 14, color: AmptiveColors.authHintColor,),
        )
      ),
    );
  }
}
