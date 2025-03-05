import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/strings/other_strings.dart';
import '../../../../animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import '../../../../common_widgets/textformfield_widget.dart';


class AmptiveDiscoverSliverHeader extends SliverPersistentHeaderDelegate{
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueNotifier<bool> notifier;

  AmptiveDiscoverSliverHeader({
    required this.controller,
    required this.focusNode,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ATContainer(
      color: ATColors.black,
      height: 61,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: ATTextFormFieldWidget(
                focusNode: focusNode,
                controller: controller,
                disableBlueBorder: true,
                cursorHeight: 20,
                cursorColor: ATColors.whiteColor.withOpacity(0.6),
                constraints: const BoxConstraints(maxHeight: 40),
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                hintText: ATStrings.SEARCH_FOR_EVENTS_ND_SHOWS,
                prefixIcon: const AmptiveImageLoaderWidget(
                  imagePath: AmptiveImageStrings.outlinedSearch,
                ),
                suffixIcon: AmptiveRebuilderWidget(
                  notifier: notifier,
                  shouldDispose: true,
                  builder: (_, value, __) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: AmptiveAnimatedCrossFadeWidget(
                        condition: value,
                        secondChild: const SizedBox.shrink(),
                        firstChild: GestureDetector(
                          onTap: () => controller.clear(),
                          child: Icon(Icons.close, size: 20, color: ATColors.whiteColor)
                        ),
                      ),
                    );
                  }
                ),
              ),
            ),
            Gap(10.w),
            AmptiveRebuilderWidget(
              notifier: notifier,
              shouldDispose: true,
              builder: (_, value, __) {
                return AmptiveAnimatedCrossFadeWidget(
                  condition: value,
                  secondChild: const SizedBox.shrink(),
                  firstChild: Text(
                    ATStrings.CANCEL,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              }
            )
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 59;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) 
    => false;
}