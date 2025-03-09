import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AmptiveUserGoLiveWidget extends StatelessWidget {
  const AmptiveUserGoLiveWidget({
    super.key,
  });

  @override
  Widget build(context) {
    return GestureDetector(
      onTap: (){context.pushNamed(ATRoutes.GO_LIVE_SCREEN);},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: const AmptiveImageLoaderWidget(
                  imagePath: ATImgStrings.jpeg1,
                  boxFit: BoxFit.cover, height: 60, width: 60,
                ),
              ),
              Positioned(
                bottom: -5.h,
                child: ATContainer(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(0),
                  height: 20, width: 20, radius: 10,
                  color: ATColors.hex307FE2,
                  border: Border.all(
                    color: ATColors.brandBlack,
                    width: 2,
                  ),
                  child: const Icon(Icons.add, size: 15, applyTextScaling: true),
                ),
              )
            ],
          ),
      
          Gap(10.h),
          Text(
            ATStrings.GO_LIVE,
            style: Theme.of(context).textTheme.titleSmall
          ),
        ],
      ),
    );
  }
}