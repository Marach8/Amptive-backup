import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/strings/image_strings.dart';
import '../../../../common_widgets/image_loader_widget.dart';

class AmptiveDiscoverCategoriesTitleWidget extends StatelessWidget {
  final String categoryName;
  const AmptiveDiscoverCategoriesTitleWidget({
    super.key,
    required this.categoryName
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          const AmptiveImageLoaderWidget(imagePath: ATImgStrings.GROUP_ICON_BLUE),
          Gap(10.h),
          Text(
            categoryName,
            style: Theme.of(context).textTheme.bodyLarge 
          ),
          const Spacer(),
          GestureDetector(
            onTap: (){},
            child: Icon(Icons.more_horiz, color: ATColors.authHintColor,),
          )
        ],
      ),
    );
  }
}