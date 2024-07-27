import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar.dart';
import 'package:amptive/src/views/widgets/common_widgets/png_jpeg_asset_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/svg_asset_loader_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/appbar_pop_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';


class AmptiveHomeScreen extends StatelessWidget {
  const AmptiveHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        appBar: AmptiveAppBar(
          centerTitle: false,
          //hideLeading: true,
          leadingWidth: 150.w,
          leading: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AmptiveSvgAssetLoaderWidget(svgPath: AmptiveImageStrings.svgLogo2),
              AmptiveAppBarDropDownWidget()
            ],
          ),

          actions: [
            GestureDetector(
              onTap: (){},
              child: const AmptiveSvgAssetLoaderWidget(svgPath: AmptiveImageStrings.svgWalletIcon)
            ),
            Gap(20.w),
            GestureDetector(
              onTap: (){},
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: AmptivePngAndJpegAssetLoaderWidget(
                  pngOrJpegPath: AmptiveImageStrings.jpeg1,
                  boxFit: BoxFit.cover,
                  height: 30.h,
                  width: 30.w,
                ),
              ),
            ),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: Iterable.generate(
              50,
              (index){
                if(index == 0){
                  return const AmptiveLiveUserWidget();
                }
                else{
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(20.w),
                      const AmptiveLiveUserWidget()
                    ],
                  );
                }
              }
            ).toList()
          ),
        ),
      ),
    );
  }
}

class AmptiveLiveUserWidget extends StatelessWidget {
  const AmptiveLiveUserWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(1),
              height: 70.h,
              width: 70.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35).r,
                border: Border.all(
                  color: AmptiveColors.orangeGradientColorB,
                  width: 2,
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
            Positioned(
              bottom: 0,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                height: 22.h,
                width: 40.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AmptiveColors.orangeGradientColorA,
                      AmptiveColors.orangeGradientColorB
                    ]
                  ),
                  borderRadius: BorderRadius.circular(5).r,
                  border: Border.all(
                    color: AmptiveColors.brandBlackColor,
                    width: 2,
                  )
                ),
                child: Text(
                  AmptiveOtherStrings.live.toUpperCase(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: AmptiveFontWeights.semiBold
                  )
                ),
              ),
            )
          ],
        ),
    
        Gap(5.h),
        Text(
          'Emmanuel',
          style: Theme.of(context).textTheme.titleSmall
        ),
      ],
    );
  }
}