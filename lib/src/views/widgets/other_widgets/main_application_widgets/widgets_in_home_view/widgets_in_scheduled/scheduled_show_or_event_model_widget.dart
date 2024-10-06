import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/list_tile_with_leading_picture_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/row_of_paid_show_and_play_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/row_of_people_listening_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/with_2_others_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/strings/route_strings.dart';
import '../../../../../../utils/dialogs/added_or_removed_from_calender_dialog.dart';
import '../../../../common_widgets/image_loader_widget.dart';


class AmptiveScheduledShowOrEventDataModelWidget extends StatefulWidget {
  final String? scheduleDateAndTime;
  const AmptiveScheduledShowOrEventDataModelWidget({
    super.key,
    this.scheduleDateAndTime
  });

  @override
  State<AmptiveScheduledShowOrEventDataModelWidget> createState() => _AmptiveScheduledShowOrEventDataModelWidgetState();
}

class _AmptiveScheduledShowOrEventDataModelWidgetState extends State<AmptiveScheduledShowOrEventDataModelWidget> {
  late ValueNotifier<bool> _notifier;

  @override 
  void initState(){
    super.initState();
    _notifier = ValueNotifier(false);
  }

  @override
  void dispose(){
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AmptiveListTileWithLeadingPictureWidget(
          leadingImagePath: AmptiveImageStrings.jpeg3,
          trailingOnPressed: (){
            context.pushNamed(AmptiveRoutes.EVENT_DETAILED_SCREEN);
          },
          title: 'glennodoyle',
          subtitle: 'Started a live show',
        ),
        Gap(2.h),
        AmptiveCustomContainer(
          height: 425.h,
          clipBehavior: Clip.hardEdge,
          radius: 15.r,
          child: Stack(
            children: [
              const AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.weCanDoHardThingsBgImage),
              AmptiveCustomContainer(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                radius: 15.r,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AmptiveColors.transparentColor,
                    AmptiveColors.transparentColor,
                    AmptiveColors.transparentColor,
                    AmptiveColors.transparentColor,
                    AmptiveColors.containerGradientColorB.withOpacity(0.5),
                    AmptiveColors.containerGradientColorB,
                    AmptiveColors.containerGradientColorB,
                    AmptiveColors.containerGradientColorB,
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AmptiveWith2OthersWidget(),
                    const Spacer(),
                    Text(
                      '15 Jul 2024 at 17:00',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: AmptiveFontSizes.size16
                      ),
                    ),
                    Gap(10.h),
                    Text(
                      maxLines: 2,
                      "Don't Forget Who You Are ft. Jacob Scipio",
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: AmptiveFontSizes.size24,
                        fontWeight: AmptiveFontWeights.semiBold,
                        fontFamily: "Bricolage Grotesque"
                      ),
                    ),
                    Gap(12.h),
                    const AmptiveRowOfNumberOfPeopleListeningWidget(),
                    Gap(10.h),
                    ValueListenableBuilder(
                      valueListenable: _notifier,
                      builder: (_, value, __) {
                        return GestureDetector(
                          onTap: (){
                            _notifier.value = !value;
                            showAddedOrRemovedSnackbar(
                              context: context,
                              content: value ? AmptiveOtherStrings.removedFromCalender
                                : AmptiveOtherStrings.addedToCalender
                            );
                          },
                          child: AmptiveAnimatedCrossFadeWidget(
                            condition: value,
                            secondChild: const AmptiveRowOfPaidShowAndPlayButtonWidget(
                              icon: Icons.add,
                            ),
                            firstChild: const AmptiveRowOfPaidShowAndPlayButtonWidget(
                              icon: Icons.check,
                            )
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
