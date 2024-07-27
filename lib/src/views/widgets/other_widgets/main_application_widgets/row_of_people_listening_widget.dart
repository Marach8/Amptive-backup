import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/png_jpeg_asset_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmptiveRowOfNumberOfPeopleListeningWidget extends StatelessWidget {
  const AmptiveRowOfNumberOfPeopleListeningWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 70.w,
          child: Stack(
            alignment: Alignment.centerLeft,
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15).r,
                child: AmptivePngAndJpegAssetLoaderWidget(
                  pngOrJpegPath: AmptiveImageStrings.jpeg1,
                  boxFit: BoxFit.cover,
                  height: 30.h,
                  width: 30.w,
                ),
              ),
              Positioned(
                left: 15.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15).r,
                  child: AmptivePngAndJpegAssetLoaderWidget(
                    pngOrJpegPath: AmptiveImageStrings.jpeg2,
                    boxFit: BoxFit.cover,
                    height: 30.h,
                    width: 30.w,
                  ),
                ),
              ),
              Positioned(
                left: 30.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15).r,
                  child: AmptivePngAndJpegAssetLoaderWidget(
                    pngOrJpegPath: AmptiveImageStrings.jpeg3,
                    boxFit: BoxFit.cover,
                    height: 30.h,
                    width: 30.w,
                  ),
                ),
              ),
            ],
          ),
        ),
    
        Text(
          '656 listening',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: AmptiveFontWeights.medium,
            fontSize: AmptiveFontSizes.size10
          )
        )
      ],
    );
  }
}
