import 'dart:ui';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/hand_raisers_modal.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/live_program_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import '../../../../global_export.dart';
import '../../go_live_export.dart';

class LiveProgramHostView extends StatelessWidget {
  const LiveProgramHostView({super.key});

  @override
  Widget build(BuildContext context) {
    final LiveStreamState1 state = context
      .read<LiveStreamCubit1>().state;
    final Community? community = state.community;
    final String? programCoverUrl = state.programCoverUrl;

    return Stack(
        children: <Widget>[
          // Background (cover mesh, full-bleed) is supplied by the parent
          // FullLiveProgramScreen so it reaches behind the status bar.
          ColoredBox(
            color: ATColors.transparent,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(
                        10, kToolbarHeight * 0.2, 15, 20),
                      child: LiveProgramHeader(),
                    ),
                
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ATContainer(
                            onTap: () {},
                            margin: const EdgeInsets.only(left: 15),
                            radius: 30,
                            padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                            color: ATColors.white.withValues(alpha: 0.1),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ATImgLoader(
                                  imgPath: ATImgStrings.groupIcon,
                                  height: 22, width: 22,
                                  boxFit: BoxFit.cover,
                                  color: ATColors.white.withValues(alpha: 0.7),
                                ),
                          
                                const SizedBox(width: 5),
                                Text(
                                  community?.name ?? 'General',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    overflow: TextOverflow.fade,
                                    fontSize: ATSizes.size13,
                                    color: ATColors.white.withValues(alpha: 0.7)
                                  ),
                                ),
                              ],
                            ),
                          ),
                
                          BlocSelector<LiveStreamCubit1, LiveStreamState1, 
                            List<String>?>(
                            selector: (LiveStreamState1 state) => state.raisedHandsIds,
                            builder: (_, List<String>? raisedHandsIds) {
                              final bool noRaisedHands = raisedHandsIds == null
                              || raisedHandsIds.isEmpty;
                              if(noRaisedHands) return const SizedBox.shrink();
                              return _HandRaisedIndicator(
                                  noOfHandsRaised: raisedHandsIds.length);
                            }
                          ),
                        ],
                      ),
                    ),
                
                    const SizedBox(height: 16),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (_, BoxConstraints kst) {
                          final bool isPortrait = kst.maxHeight > kst.maxWidth;
                          return Flex(
                            direction: isPortrait ? Axis.vertical : Axis.horizontal,
                            children: <Widget>[
                              if (isPortrait)
                                Container(
                                  height: 250,
                                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: const HostViewOfHostNdCohostDisplay()
                                )
                              else
                                const Expanded(
                                  child: SingleChildScrollView(
                                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    child: SizedBox(
                                        height: 250,
                                        child: HostViewOfHostNdCohostDisplay()
                                      )
                                    )
                                  ),
                              const Expanded(child: GoLiveCommentsAndNotifications()),
                            ],
                          );
                        }
                      )
                    )
                  ],
                ),

                Positioned(
                  bottom: 0, right: 0, left: 0,
                  child: BlocBuilder<GoLiveControlsVisibilityBloc, bool>(
                    builder: (BuildContext context, bool isVisible) {
                    final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;
                    final double extraSpace = bottomInset == 0 ? 10.0 : bottomInset + 10;
                  
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      // Transparent when the keyboard is down so the cover mesh
                      // shows through; solid only behind the keyboard.
                      color: bottomInset == 0
                          ? ATColors.transparent
                          : ATColors.hex2C2F33,
                      padding: EdgeInsets.fromLTRB(15, 5, 15, extraSpace),
                      child: const HostModerationControls(),
                    );
                  }),
                )
              ],
            ),
          ),
        ],
      );
  }
}


class _HandRaisedIndicator extends StatefulWidget {
  const _HandRaisedIndicator({required this.noOfHandsRaised});
  final int noOfHandsRaised;

  @override
  State<_HandRaisedIndicator> createState() => __HandRaisedIndicatorState();
}

class __HandRaisedIndicatorState extends State<_HandRaisedIndicator> {
  bool isMinimized = false;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: ()async{
        final String? userId = await showHandRaisersModal(
          context: context,
          canApproveHandRaise: true,
          localUserDataCubit: context.read<LocalUserDataCubit>(),
          liveStreamCubit: context.read<LiveStreamCubit1>(),
        );
        if(context.mounted && userId != null){
          context.read<LiveStreamCubit1>().approveHandRaise(
            userId,
          );
        }
      },
      margin: const EdgeInsets.only(right: 16),
      height: 28, width: 28,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 700),
            tween: Tween<double>(
              begin: isMinimized ? 28 : 25,
              end: isMinimized ? 25 : 28,
            ),
            onEnd: () => setState(() => isMinimized = !isMinimized),
            builder: (_, double size, __) {
              return ATImgLoader(
                imgPath: ATImgStrings.handRaiseIcon,
                height: size, width: size,
                boxFit: BoxFit.fill,
                color: ATColors.hex307FE2,
              );
            },
          ),
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
              constraints: const BoxConstraints(minWidth: 15),
              height: 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: ATColors.hexECO404,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.noOfHandsRaised.toString(),
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall
                    ?.copyWith(fontSize: 10),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
