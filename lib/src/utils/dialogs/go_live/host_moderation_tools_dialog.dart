import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:amptive/src/bloc/main_app/go_live_bloc/audience_view/following_bloc.dart';
import 'package:amptive/src/bloc/main_app/go_live_bloc/host_view/cohosts_display_bloc.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/dialogs/confirmation_alert_dialog.dart';
import 'package:amptive/src/utils/helpers/extensions/string_extensions.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_container_with_picture_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../bloc/main_app/go_live_bloc/audience_view/subscription_bloc.dart';
import '../../../models/host.dart';
import '../../../services/create_show/create_show_service.dart';
import '../../constants/strings/other_strings.dart';
import '../add_co_host_dialog.dart';
import 'dart:developer' as marach show log;

Future<void> showHostModerationToolsDialog(BuildContext context) async {
  return await showModalBottomSheet(
    backgroundColor: AmptiveColors.black4,
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: AmptiveColors.black.withOpacity(0.6),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15), topRight: Radius.circular(15),
    )),
    builder: (context) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15), topRight: Radius.circular(15),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: AmptiveCustomContainer(
            width: AmptiveHelperFunctions.getScreenWidth(context),
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Platform.isAndroid
                      ? Icon(
                          Icons.keyboard_arrow_down,
                          color: AmptiveColors.whiteColor.withOpacity(0.6),
                        )
                      : AmptiveCustomContainer(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          radius: 5, height: 4, width: 30,
                          color: AmptiveColors.whiteColor.withOpacity(0.6),
                          child: const SizedBox.shrink(),
                        ),
                    ),
                  ),
                  const Gap(10),
                  Text(
                    AmptiveOtherStrings.MODERATION_TOOLS,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Gap(20),
                  const CustomRow(
                    title: AmptiveOtherStrings.ALLOW_COMMENTS,
                    icon: Iconsax.message,
                  ),
                  const Gap(10),
                  const CustomRow(
                    title: AmptiveOtherStrings.ALLOW_AUDIENCE_MIC,
                    icon: Icons.mic,
                    subtitle: AmptiveOtherStrings.NEED_2_ENABLE_LISTENERS_MIC,
                  ),
                  const Gap(10),
                  const CustomRow(
                    title: AmptiveOtherStrings.ALLOW_COMMENTS,
                    icon: Icons.front_hand_outlined
                  ),
                ]
              ),
            )
          ),
        );
      }
    );
}



class CustomRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  const CustomRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AmptiveHelperFunctions.getScreenWidth(context),
      child: Row(
        children: [
          Icon(icon),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: AmptiveFontSizes.size17
                  ),
                ),
                if(subtitle != null)const Gap(8),
                if(subtitle != null)Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: AmptiveFontSizes.size12,
                    color: AmptiveColors.whiteColor.withOpacity(0.4)
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),
          Transform.scale(
            scale: 0.8,
            child: Switch.adaptive(
              value: true,
              onChanged: (value){
                
              }
            ),
          )
        ],
      ),
    );
  }
}
