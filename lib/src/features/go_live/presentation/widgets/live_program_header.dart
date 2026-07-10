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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'host_end_show_dialog.dart';
import 'listeners_modal.dart';
import 'gifters_modal.dart';
import '../../../home/presentation/widgets/appbar_drop_down.dart';


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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: audienceMinimizeIcon ?? ATGlassDropDown(
            offset: const Offset(0, 50),
            items: <ATGlassDropdownItem>[
              ATGlassDropdownItem(
                title: 'Minimize',
                iconWidget: const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.white),
                onTap: () {
                  liveProgramOverlayKey.currentState?.minimize();
                },
              ),
              ATGlassDropdownItem(
                title: 'End Live',
                textColor: const Color(0xFFFF3B30),
                iconWidget: const Icon(Icons.close, size: 20, color: Color(0xFFFF3B30)),
                onTap: () {
                  hostEndProgramModal(
                    context: context,
                    endLiveProgramCubit: context.read<EndLiveProgramCubit>(),
                    noOfGifts: context.read<LiveStreamCubit1>().state.giftIds?.length ?? 0,
                    noOfListeners: context.read<LiveStreamCubit1>().state.allParticipants?.length ?? 0,
                    programCoverUrl: programCoverUrl ?? '',
                    programId: context.read<LiveStreamCubit1>().state.liveStreamId ?? '',
                  );
                },
              ),
            ],
            child: Container(
              height: 35, width: 35,
              decoration: BoxDecoration(
                color: ATColors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30)
              ),
              child: Center(
                child: SvgPicture.string(
                  ATImgStrings.liveHeaderEndLiveIconSvg,
                  height: 18,
                  width: 18,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
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
        const SizedBox(width: 4),
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

  // Shared pill metrics so both header pills stay visually identical and in
  // line with the app's other pills.
  static const EdgeInsets _pillPadding = EdgeInsets.fromLTRB(12, 7, 12, 7);
  static const double _pillIconSize = 18;
  static const double _pillRadius = 30;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
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
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if(hasNewGifts){
                  setState(() {
                    hasNewGifts = false;
                  });
                }
                widget.onGiftsTap?.call();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Stack(
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
                      radius: _pillRadius,
                      padding: _pillPadding,
                      color: ATColors.white.withValues(alpha: 0.1),
                      splashColor: ATColors.white.withValues(alpha: 0.15),
                      highlightColor: ATColors.transparent,
                      child: Row(
                        children: <Widget>[
                          ATImgLoader(
                            imgPath: ATImgStrings.liveHeaderGiftIconPngAsset,
                            height: _pillIconSize, width: _pillIconSize,
                            boxFit: BoxFit.cover,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Gift',
                            style: context.textTheme.bodyMedium?.copyWith(
                              overflow: TextOverflow.fade,
                              fontSize: ATSizes.size14,
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
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onParticipantsTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: ATContainer(
                  onTap: widget.onParticipantsTap,
                  padding: _pillPadding,
                  radius: _pillRadius,
                  color: ATColors.white.withValues(alpha: 0.1),
                  splashColor: ATColors.white.withValues(alpha: 0.15),
                  highlightColor: ATColors.transparent,
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        ATImgStrings.liveHeaderUser2IconSvgAsset,
                        height: _pillIconSize,
                        width: _pillIconSize,
                      ),
                      const SizedBox(width: 6),
                      BlocSelector<LiveStreamCubit1, LiveStreamState1, int>(
                        selector: (LiveStreamState1 state) => state.viewerCount,
                        builder: (_, int viewerCount) {
                          return Text(
                            _formatViewerCount(viewerCount),
                            style: context.textTheme.bodyMedium?.copyWith(
                              overflow: TextOverflow.fade,
                              fontSize: ATSizes.size14,
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatViewerCount(int? count) {
    if (count == null) return "0";
    return count.compactFormat;
  }
}

