import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/main_app/go_live_bloc/host_view/host_end_show_bloc.dart';
import 'host_end_show_dialog.dart';
import '../../../../config/utils/dialogs/go_live/host_view_of_listeners_dialog.dart';
import '../../../../config/utils/dialogs/go_live/top_gifters_modal.dart';
import '../../../../livestream/models/livestream_models.dart';

class LiveProgramHeader extends StatelessWidget {
  const LiveProgramHeader({
    super.key,
    this.exitIcon,
  });

  final Widget? exitIcon;

  @override
  Widget build(BuildContext context) {
    final String? title = context
      .read<LiveStreamCubit1>().state.programTitle;
    
    return Row(
      children: <Widget>[
        exitIcon ?? ATContainer(
          onTap: () {
            showHostEndShowDialog(context: context);
          },
          color: ATColors.hexECO404.withValues(alpha: 0.3),
          height: 35, width: 35,
          boxShape: BoxShape.circle,
          child: Icon(
            Icons.logout,
            color: ATColors.hexECO404,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: LayoutBuilder(
            builder: (_, BoxConstraints kst) {
              return GoLiveProgramTitle(
                width: kst.maxWidth,
                slidingChildren: <Widget>[
                  Text(
                    ATStrings.live,
                    style: context.textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 5),
                  const ATCircleAvatar(diameter: 5),
                  const SizedBox(width: 5),
                  Text(
                    title ?? 'Title',
                    style: context.textTheme.bodyMedium
                        ?.copyWith(overflow: TextOverflow.fade),
                  )
                ],
              );
            }
          ),
        ),
        const SizedBox(width: 10),
        _GiftingAndFollowingRow(
          onGiftsTap: () {
            exitIcon != null
                ? showHostViewOfTopGiftersDialog(context)
                : showAudienceViewOfTopGiftersDialog(context);
          },
          onParticipantsTap: () {
            showListenersDialog(
              context: context,
              liveStreamCubit: context.read<LiveStreamCubit1>(),
              enableKickOut: exitIcon == null
            );
          },
        ),
      ],
    );
  }
}

class _GiftingAndFollowingRow extends StatelessWidget {
  const _GiftingAndFollowingRow({
    required this.onGiftsTap,
    required this.onParticipantsTap,
  });

  final VoidCallback? onGiftsTap, onParticipantsTap;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      // boxShadow: <BoxShadow>[
      //   BoxShadow(
      //     color: ATColors.black,
      //     blurRadius: 35, spreadRadius: 20,
      //     offset: const Offset(-20, 0)
      //   )
      // ],
      child: Row(
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              ATContainer(
                onTap: onGiftsTap,
                radius: 30,
                padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                color: ATColors.white.withValues(alpha: 0.1),
                child: Row(
                  children: <Widget>[
                    const ATImgLoader(
                      imgPath: ATImgStrings.hostGiftingIcon,
                      height: 20, width: 20,
                      boxFit: BoxFit.cover,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Gift",
                      style: context.textTheme.bodyMedium?.copyWith(
                        overflow: TextOverflow.fade,
                        fontSize: ATSizes.size14
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -2, right: 4,
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor: ATColors.hexECO404
                )
              )
            ],
          ),
          const SizedBox(width: 10),
          ATContainer(
            onTap: onParticipantsTap,
            padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
            radius: 30,
            color: ATColors.white.withValues(alpha: 0.1),
            child: Row(
              children: <Widget>[
                const ATImgLoader(
                  imgPath: ATImgStrings.userIcon,
                  height: 15,
                  width: 15,
                ),
                const SizedBox(width: 5),
                BlocSelector<LiveStreamCubit1, LiveStreamState1, int>(
                  selector: (LiveStreamState1 state) => state.viewerCount,
                  builder: (_, int viewerCount) {
                    return Text(
                      _formatViewerCount(viewerCount),
                      style: context.textTheme.bodyMedium?.copyWith(
                        overflow: TextOverflow.fade, fontSize: 14
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatViewerCount(int? count) {
    if (count == null) return "0";
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
