import 'package:amptive/src/config/config_export.dart';
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

class GoLiveScreenHeader extends StatelessWidget {
  const GoLiveScreenHeader(
      {super.key, this.exitIcon, this.viewerCount, this.participants});
  final Widget? exitIcon;
  final int? viewerCount;
  final List<LivestreamParticipant>? participants;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        exitIcon ??
            ATContainer(
              onTap: () {
                context
                    .read<AmptiveEndShowBloc>()
                    .add(Reset2IntialStateEvent());
                showHostEndShowDialog(context: context);
              },
              color: ATColors.hexECO404.withValues(alpha: 0.3),
              height: 35,
              width: 35,
              boxShape: BoxShape.circle,
              child: Icon(
                Icons.logout,
                color: ATColors.hexECO404,
                size: 20,
              ),
            ),
        const SizedBox(width: 10),
        Expanded(
          child: LayoutBuilder(builder: (_, BoxConstraints kst) {
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
                  "Don't Forget Who you are by the perkjdkakfkdkajdkakdjakfjdkajkdajkfdjkafkdakdfjkakfakjdfkajkfafakjkjk",
                  style: context.textTheme.bodyMedium
                      ?.copyWith(overflow: TextOverflow.fade),
                )
              ],
            );
          }),
        ),
        const SizedBox(width: 10),
        _GiftingNdFollowing(
          viewerCount: viewerCount,
          participants: participants,
          onGiftTap: () {
            exitIcon != null
                ? showHostViewOfTopGiftersDialog(context)
                : showAudienceViewOfTopGiftersDialog(context);
          },
          onFollowersTap: () {
            if (exitIcon == null) {
              showListenersDialog(context: context, participants: participants);
            } else {
              showListenersDialog(
                  context: context,
                  enableKickOut: false,
                  participants: participants);
            }
          },
        ),
      ],
    );
  }
}

class _GiftingNdFollowing extends StatelessWidget {
  const _GiftingNdFollowing({
    required this.onGiftTap,
    required this.onFollowersTap,
    this.viewerCount,
    this.participants,
  });

  final VoidCallback? onGiftTap, onFollowersTap;
  final int? viewerCount;
  final List<LivestreamParticipant>? participants;

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
                onTap: onGiftTap,
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
                          fontSize: ATSizes.size14),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: -2,
                  right: 4,
                  child: ATCircleAvatar(diameter: 8, color: ATColors.hexECO404))
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          ATContainer(
            onTap: onFollowersTap,
            padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
            radius: 30,
            color: ATColors.white.withValues(alpha: 0.1),
            child: Row(
              children: <Widget>[
                const ATImgLoader(
                  imgPath: ATImgStrings.USER_ICON,
                  height: 15,
                  width: 15,
                ),
                const SizedBox(width: 5),
                Text(
                  viewerCount != null
                      ? _formatViewerCount(viewerCount!)
                      : "144k",
                  style: context.textTheme.bodyMedium?.copyWith(
                      overflow: TextOverflow.fade, fontSize: ATSizes.size14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatViewerCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
