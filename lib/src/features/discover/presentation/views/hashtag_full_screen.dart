import 'package:amptive/src/views/widgets/common_widgets/app_bar_back_arrow_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/font_sizes.dart';
import '../../../../utils/constants/strings/image_strings.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/society_widgets/trending_society_model.dart';

class AmptiveTrendingHashTagFullScreen extends StatelessWidget {
  const AmptiveTrendingHashTagFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                title: Text(
                  ATStrings.HASH + ATStrings.SOCIETY,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                centerTitle: true,
                floating: true,
                leading: const AmptiveBackArrowWidget()
              ),
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    ATContainer(
                      alignment: Alignment.center,
                      height: 40, width: 40,
                      boxShape: BoxShape.circle,
                      color: ATColors.white,
                      child: Text(
                        ATStrings.HASH,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: ATColors.hex0D0D0D
                        )
                      ),
                    ),
                    Gap(10.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ATStrings.HASH + ATStrings.SOCIETY,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: ATFontSizes.size15
                          ),
                        ),
                        Text(
                         'ankira22, emmanuel, and 15k others are live',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: ATFontSizes.size13,
                            color: ATColors.hexA8A8A8
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SliverToBoxAdapter(child: Gap(15)),

              SliverGrid(
                delegate: SliverChildListDelegate.fixed(
                  List.generate(
                    28,
                    (_) => const AmptiveTrendingSocietyModel(trendingPicture: ATImgStrings.weCanDoHardThingsBgImage)
                  ).toList()
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 0,
                  childAspectRatio: 0.75
                )
              )
            ],
          ),
        ),
      ),
    );

  }
}