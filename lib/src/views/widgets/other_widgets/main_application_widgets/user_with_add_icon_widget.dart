import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/png_jpeg_asset_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AmptiveUserWithAddIconWidget extends StatelessWidget {
  const AmptiveUserWithAddIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 81.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                height: 70.h,
                width: 70.w,
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
              Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: (){},
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(0),
                    height: 20.h,
                    width: 20.w,
                    decoration: BoxDecoration(
                      color: AmptiveColors.brandBlueColor,
                      borderRadius: BorderRadius.circular(10).r,
                      border: Border.all(
                        color: AmptiveColors.brandBlackColor,
                        width: 2.w,
                      )
                    ),
                    child: const Icon(Icons.add, size: 15, applyTextScaling: true,),
                  ),
                ),
              )
            ],
          ),
        ),
    
        Gap(5.h),
        Text(
          AmptiveOtherStrings.goLive,
          style: Theme.of(context).textTheme.titleSmall
        ),
      ],
    );
  }
}