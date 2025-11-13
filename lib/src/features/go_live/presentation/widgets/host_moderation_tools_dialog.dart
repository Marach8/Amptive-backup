import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../bloc/main_app/go_live_bloc/audience_view/host_moderation_control_bloc.dart';
import '../../../../views/widgets/common_widgets/dismiss_modal.dart';
import '../../../../views/widgets/common_widgets/switch_widget.dart';

Future<void> showHostModerationToolsDialog(BuildContext context) async {
  return await showModalBottomSheet(
    backgroundColor: ATColors.hex202020,
    context: context, isScrollControlled: true,
    useSafeArea: true,
    barrierColor: ATColors.black.withValues(alpha:0.6),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15), topRight: Radius.circular(15),
    )),
    builder: (BuildContext context) {
      return Container(
        width: context.screenWidth,
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ATModalDismisser(),
              const SizedBox(height: 10,),
              Text(
                ATStrings.MODERATION_TOOLS,
                style: context.textTheme.bodyLarge,
              ),
              const SizedBox(height: 20,),
              _CustomRow(
                title: ATStrings.ALLOW_COMMENTS,
                icon: Iconsax.message,
                trailing: BlocConsumer<AmptiveGoLiveHostModerationToolsBloc, List<bool>>(
                  listenWhen: (List<bool> prev, List<bool> curr) => prev.first != curr.first,
                  buildWhen: (List<bool> prev, List<bool> curr) => prev.first != curr.first,
                  listener: (_, List<bool> state){
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
                  builder: (_, List<bool> state) {
                    return ATSwitch(
                      value: state.first,
                      onChanged: (bool value) => value ?
                      context.read<AmptiveGoLiveHostModerationToolsBloc>().allowComments()
                      : context.read<AmptiveGoLiveHostModerationToolsBloc>().disableComments()
                    );
                  }
                ),
              ),
              const SizedBox(height: 10),
              _CustomRow(
                title: ATStrings.ALLOW_AUDIENCE_MIC,
                icon: Icons.mic,
                subtitle: ATStrings.NEED_2_ENABLE_LISTENERS_MIC,
                trailing: BlocConsumer<AmptiveGoLiveHostModerationToolsBloc, List<bool>>(
                  listenWhen: (List<bool> prev, List<bool> curr) => prev[1] != curr[1],
                  buildWhen: (List<bool> prev, List<bool> curr) => prev[1] != curr[1],
                  listener: (_, List<bool> state){
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
                  builder: (_, List<bool> state) {
                    return ATSwitch(
                      value: state[1],
                      onChanged: (bool value) => value ?
                      context.read<AmptiveGoLiveHostModerationToolsBloc>().allowAudienceMic()
                      : context.read<AmptiveGoLiveHostModerationToolsBloc>().disableAudienceMic()
                    );
                  }
                ),
              ),
              const SizedBox(height: 10),
              _CustomRow(
                title: ATStrings.ALLOW_HANDRAISING,
                icon: Icons.front_hand_outlined,
                trailing: BlocConsumer<AmptiveGoLiveHostModerationToolsBloc, List<bool>>(
                  listenWhen: (List<bool> prev, List<bool> curr) => prev.last != curr.last,
                  buildWhen: (List<bool> prev, List<bool> curr) => prev.last != curr.last,
                  listener: (_, List<bool> state){
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
                  builder: (_, List<bool> state) {
                    return ATSwitch(
                      value: state.last,
                      onChanged: (bool value) => value ?
                      context.read<AmptiveGoLiveHostModerationToolsBloc>().allowHandRaising()
                      : context.read<AmptiveGoLiveHostModerationToolsBloc>().disableHandRaising()
                    );
                  }
                ),
              ),
            ]
          ),
        );
      }
    );
}



class _CustomRow extends StatelessWidget {
  const _CustomRow({
    required this.icon,
    required this.title,
    required this.trailing,
    this.subtitle
  });
  final IconData icon;
  final String title;
  final Widget trailing;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      child: Row(
        children: <Widget>[
          Icon(icon),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontSize: ATSizes.size17
                  ),
                ),
                if(subtitle != null)const SizedBox(height: 8,),
                if(subtitle != null)Text(
                  subtitle!,
                  style: context.textTheme.bodySmall?.copyWith(
                    fontSize: ATSizes.size12,
                    color: ATColors.white.withValues(alpha: 0.4)
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          trailing
        ],
      ),
    );
  }
}
