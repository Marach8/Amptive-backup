import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/live_indicator_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/png_jpeg_asset_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AmptiveLiveUserModelWidget extends StatelessWidget {
  const AmptiveLiveUserModelWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(2).r,
              height: 70.h,
              width: 70.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35).r,
                border: Border.all(
                  color: AmptiveColors.orangeGradientColorB,
                  width: 2.w,
                )
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: AmptivePngAndJpegAssetLoaderWidget(
                  pngOrJpegPath: AmptiveImageStrings.jpeg1,
                  boxFit: BoxFit.cover,
                  height: 60.h,
                  width: 60.w,
                ),
              ),
            ),
            const Positioned(
              bottom: -4,
              child: AmptiveLiveIndicatorWidget(),
            )
          ],
        ),
    
        Gap(10.h),
        Text(
          'Emmanuel',
          style: Theme.of(context).textTheme.titleSmall
        ),
      ],
    );
  }
}
