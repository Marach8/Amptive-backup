import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../recent_searches_widgets/container_with_picture.dart';

class AmptiveTabViewListTileWidget extends StatelessWidget {
  final String title, leadingImagePath;
  final bool isCircular, addPlayButton;

  const AmptiveTabViewListTileWidget({
    super.key,
    required this.title,
    required this.leadingImagePath,
    this.isCircular = false,
    this.addPlayButton = false
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
            fontWeight: ATFontWeights.w500,
            height: 1
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              'Show',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: ATColors.hexC2C2C2,
                fontWeight: ATFontWeights.w500,
                fontSize: ATFontSizes.size13,
                height: 1.5
              ),
            ),
            const Gap(5),
            const ATCircleAvatar(diameter: 3),
            const Gap(5),
            Text(
              'MONDAY AT 20:00',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: ATColors.hexC2C2C2,
                fontWeight: ATFontWeights.w500,
                fontSize: ATFontSizes.size13,
                height: 1.5
              ),
            ),
          ],
        ),

        trailing: GestureDetector(
          onTap: (){},
          child: addPlayButton 
            ? ATContainer(
              boxShape: BoxShape.circle,
              height: 24, width: 24,
              color: ATColors.authHintColor,
              child: Icon(Icons.play_arrow, size: 15, color: ATColors.brandBlack,),
            )
            : Icon(Icons.keyboard_arrow_right, size: 24, color: ATColors.authHintColor,) 
        )
      ),
    );
  }
}
