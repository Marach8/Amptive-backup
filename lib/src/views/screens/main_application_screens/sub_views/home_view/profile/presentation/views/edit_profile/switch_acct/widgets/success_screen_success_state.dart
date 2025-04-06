import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/screens/main_application_screens/sub_views/home_view/profile/bloc/profile_bloc_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../widgets/creator_badge.dart';


class SuccesState extends StatelessWidget {
  const SuccesState({super.key});

  @override
  Widget build(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 75,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              const ATCircularImage(
                diameter: 70,
                imagePath: ATImgStrings.jpeg1
              ),
              Positioned(
                bottom: 0,
                child: BlocSelector<CreatorSuccessAnimationBloc, List<bool>, bool>(
                  selector: (state) => state.elementAt(4),
                  builder: (_, isVisible) {
                    return AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: isVisible ? 1 : 20,
                      child: const CreatorBadge(),
                    );
                  }
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 30),
        Text(
          ATStrings.U_R_A_CREATOR,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: ATFontSizes.size24
          ),
        ),
        const SizedBox(height: 5),
        Text(
          ATStrings.NOW_U_CAN_CREATE, maxLines: 2,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: ATColors.hexC2C2C2
          )
        ),
      ],
    );
  }
}