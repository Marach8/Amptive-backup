import 'dart:io';
import 'dart:ui';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';

import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../bloc/main_app/go_live_bloc/audience_view/host_moderation_control_bloc.dart';
import '../../../views/widgets/common_widgets/switch_widget.dart';
import '../../constants/strings/other_strings.dart';

Future<void> showHostModerationToolsDialog(BuildContext context) async {
  return await showModalBottomSheet(
    backgroundColor: ATColors.hex202020,
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: ATColors.black.withOpacity(0.6),
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
          child: ATContainer(
            width: ATHelperFuncs.getScreenWidth(context),
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
                          color: ATColors.whiteColor.withOpacity(0.6),
                        )
                      : ATContainer(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          radius: 5, height: 4, width: 30,
                          color: ATColors.whiteColor.withOpacity(0.6),
                          child: const SizedBox.shrink(),
                        ),
                    ),
                  ),
                  const Gap(10),
                  Text(
                    ATStrings.MODERATION_TOOLS,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Gap(20),
                  _CustomRow(
                    title: ATStrings.ALLOW_COMMENTS,
                    icon: Iconsax.message,
                    trailing: BlocConsumer<AmptiveGoLiveHostModerationToolsBloc, List<bool>>(
                      listenWhen: (prev, curr) => prev.first != curr.first,
                      buildWhen: (prev, curr) => prev.first != curr.first,
                      listener: (_, state){
                        if(state[1]){
                          showAppNotification(
                          context: context,
                            text: ATStrings.ALLOWED_COMMENTS,
                            icon:const Icon(Iconsax.message,)
                          );
                        }
                        else{
                          showAppNotification(
                          context: context,
                            text: ATStrings.DISABLED_COMMENTS,
                            icon:const Icon(Iconsax.message)
                          );
                        }
                      },
                      builder: (_, state) {
                        return AmptiveSwitch(
                          value: state.first,
                          onChanged: (value) => value ?
                          context.read<AmptiveGoLiveHostModerationToolsBloc>().allowComments()
                          : context.read<AmptiveGoLiveHostModerationToolsBloc>().disableComments()
                        );
                      }
                    ),
                  ),
                  const Gap(10),
                  _CustomRow(
                    title: ATStrings.ALLOW_AUDIENCE_MIC,
                    icon: Icons.mic,
                    subtitle: ATStrings.NEED_2_ENABLE_LISTENERS_MIC,
                    trailing: BlocConsumer<AmptiveGoLiveHostModerationToolsBloc, List<bool>>(
                      listenWhen: (prev, curr) => prev[1] != curr[1],
                      buildWhen: (prev, curr) => prev[1] != curr[1],
                      listener: (_, state){
                        if(state[1]){
                          showAppNotification(
                          context: context,
                            text: ATStrings.ALLOWED_AUD_MIC,
                            icon:const Icon(Icons.mic)
                          );
                        }
                        else{
                          showAppNotification(
                          context: context,
                            text: ATStrings.DISABLED_AUD_MIC,
                            icon:const Icon(Icons.mic)
                          );
                        }
                      },
                      builder: (_, state) {
                        return AmptiveSwitch(
                          value: state[1],
                          onChanged: (value) => value ?
                          context.read<AmptiveGoLiveHostModerationToolsBloc>().allowAudienceMic()
                          : context.read<AmptiveGoLiveHostModerationToolsBloc>().disableAudienceMic()
                        );
                      }
                    ),
                  ),
                  const Gap(10),
                  _CustomRow(
                    title: ATStrings.ALLOW_COMMENTS,
                    icon: Icons.front_hand_outlined,
                    trailing: BlocConsumer<AmptiveGoLiveHostModerationToolsBloc, List<bool>>(
                      listenWhen: (prev, curr) => prev.last != curr.last,
                      buildWhen: (prev, curr) => prev.last != curr.last,
                      listener: (_, state){
                        if(state.last){
                          showAppNotification(
                            context: context,
                            text: ATStrings.ALLOWED_HAND_RAISING,
                            icon:const Icon(Icons.front_hand_outlined)
                          );
                        }
                        else{
                          showAppNotification(
                            context: context,
                            text: ATStrings.DISABLED_HAND_RAISING,
                            icon:const Icon(Icons.front_hand_outlined)
                          );
                        }
                      },
                      builder: (_, state) {
                        return AmptiveSwitch(
                          value: state.last,
                          onChanged: (value) => value ?
                          context.read<AmptiveGoLiveHostModerationToolsBloc>().allowHandRaising()
                          : context.read<AmptiveGoLiveHostModerationToolsBloc>().disableHandRaising()
                        );
                      }
                    ),
                  ),
                ]
              ),
            )
          ),
        );
      }
    );
}



class _CustomRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  final String? subtitle;
  const _CustomRow({
    required this.icon,
    required this.title,
    required this.trailing,
    this.subtitle
  });

  @override
  Widget build(context) {
    return SizedBox(
      width: ATHelperFuncs.getScreenWidth(context),
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
                    color: ATColors.whiteColor.withOpacity(0.4)
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),
          trailing
        ],
      ),
    );
  }
}
