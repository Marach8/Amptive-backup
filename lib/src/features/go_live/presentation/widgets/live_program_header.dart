import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/features/home/presentation/widgets/appbar_drop_down.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'host_end_show_dialog.dart';
import 'listeners_modal.dart';
import 'gifters_modal.dart';


class LiveProgramHeader extends StatelessWidget {
  const LiveProgramHeader({
    super.key,
    this.audienceMinimizeIcon,
  });

  final Widget? audienceMinimizeIcon;

  @override
  Widget build(BuildContext context) {
    final String? title = context
      .read<LiveStreamCubit1>().state.programTitle;
    final String? programCoverUrl = context
      .read<LiveStreamCubit1>().state.programCoverUrl;
    
    return Row(
      children: <Widget>[
        audienceMinimizeIcon ?? ATStringsDropDown(
          items: const <String>['End Live', 'Minimize'],
          onSelected: (String selected){
            if(selected == 'End Live'){
              hostEndProgramModal(
                context: context,
                endLiveProgramCubit: context.read<EndLiveProgramCubit>(),
                noOfGifts: context.read<LiveStreamCubit1>().state.giftIds?.length ?? 0,
                noOfListeners: context.read<LiveStreamCubit1>().state.allParticipants?.length ?? 0,
                programCoverUrl: programCoverUrl ?? '',
                programId: context.read<LiveStreamCubit1>().state.liveStreamId ?? '',
              );
            }
            else if(selected == 'Minimize'){
              liveProgramOverlayKey.currentState?.minimize();
            }
          },
          child: Container(
            height: 35, width: 35,
            decoration: BoxDecoration(
              color: ATColors.hexECO404.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(30)
            ),
            child: Icon(
              Icons.logout,
              color: ATColors.hexECO404,
              size: 20,
            ),
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
          onGiftsTap: () async{
            final bool? shouldSendGift = await showGiftersModal(
                context: context,
                canSendGift: audienceMinimizeIcon != null,
                liveStreamCubit: context.read<LiveStreamCubit1>(),
                localUserDataCubit: context.read<LocalUserDataCubit>(),
              );
    
            if(context.mounted && shouldSendGift == true){
              final int? price = await GiftPickerDialog.show(
                context
              );
              if(context.mounted && price != null){
                context.read<LiveStreamCubit1>().sendGift(price);
              }
            }
          },
          onParticipantsTap: () {
            showListenersModal(
              context: context,
              localUserDataCubit: context.read<LocalUserDataCubit>(),
              liveStreamCubit: context.read<LiveStreamCubit1>(),
              enableKickOut: audienceMinimizeIcon == null
            );
          },
        ),
      ],
    );
  }
}

class _GiftingAndFollowingRow extends StatefulWidget {
  const _GiftingAndFollowingRow({
    required this.onGiftsTap,
    required this.onParticipantsTap,
  });

  final VoidCallback? onGiftsTap, onParticipantsTap;

  @override
  State<_GiftingAndFollowingRow> createState() => _GiftingAndFollowingRowState();
}

class _GiftingAndFollowingRowState extends State<_GiftingAndFollowingRow> {
  bool hasNewGifts = false;

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
      child: BlocListener<LiveStreamCubit1, LiveStreamState1>(
        listenWhen: (LiveStreamState1 prev, LiveStreamState1 cur)
          => prev.giftIds != cur.giftIds,
        listener: (_, LiveStreamState1 state) {
          setState(() {
            hasNewGifts = true;
          });
        },
        child: Row(
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                ATContainer(
                  onTap: () {
                    if(hasNewGifts){
                      setState(() {
                        hasNewGifts = false;
                      });
                    }
                    widget.onGiftsTap?.call();
                  },
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
                if(hasNewGifts)Positioned(
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
              onTap: widget.onParticipantsTap,
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

