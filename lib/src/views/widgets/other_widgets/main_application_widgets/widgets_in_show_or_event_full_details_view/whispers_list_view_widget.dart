import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/image_strings.dart';
import '../../../common_widgets/custom_container_widget.dart';
import '../../../common_widgets/list_tile_with_leading_picture_widget.dart';

class AmptiveWhispersListViewWidget extends StatelessWidget {
  const AmptiveWhispersListViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230.h,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 20),
        separatorBuilder: (_, __) => Gap(15.w),
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (_, __) => ATContainer(
          padding: const EdgeInsets.fromLTRB(15, 0, 15,  0),
          height: 230.h,
          width: 285.w,
          radius: 10,
          color: ATColors.white.withOpacity(0.1),
          child: Column(
            children: [
              const AmptiveListTileWithLeadingPictureWidget(
                title: 'karankabir',
                subtitle: 'Listener',
                leadingImagePath: ATImgStrings.jpeg1,
              ),
              Text(
                maxLines: null,
                'I got so excited whan Jack spoke spanish for just no reason, like what!!!!!!>😂😂😂',
                style: Theme.of(context).textTheme.labelMedium
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}