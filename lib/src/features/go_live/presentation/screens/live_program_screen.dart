import 'dart:ui';

import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/end_live_program_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_audience_view.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_cohost_view.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_host_view.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/host_moderation_controls.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';


class FullLiveProgramScreen extends StatelessWidget {
  const FullLiveProgramScreen({super.key, this.liveProgramData});
  final LiveProgramData? liveProgramData;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<GoLiveControlsVisibilityBloc>(
          create: (_) => GoLiveControlsVisibilityBloc()
        ),
        BlocProvider<LiveStreamCubit1>(
          create: (_) => LiveStreamCubit1(
            myUserId: liveProgramData?.roomParticipantId 
              ?? context.read<LocalUserDataCubit>()
                .currentUserData?.userId ?? '',
            initialState: LiveStreamState1(
              programCoverUrl: liveProgramData?.coverUrl,
              liveStreamId: liveProgramData?.streamId,
              roomUrl: liveProgramData?.roomUrl,
              roomEntryToken: liveProgramData?.roomEntryToken,
              community: liveProgramData?.community,
              programTitle: liveProgramData?.programTitle,
              programDesc: liveProgramData?.programDesc,
            )
          ),
        ),
        BlocProvider<EndLiveProgramCubit>(
          create: (_) => EndLiveProgramCubit(),
        ),
      ],
      child: _SubWidget(
        liveScreenEntryParams: liveProgramData,
      ),
    );
  }
}

class _SubWidget extends StatefulWidget {
  const _SubWidget({
    required this.liveScreenEntryParams
  });

  final LiveProgramData? liveScreenEntryParams;

  @override
  State<_SubWidget> createState() => __SubWidgetState();
}

class __SubWidgetState extends State<_SubWidget> with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.manual,
    //   overlays: <SystemUiOverlay>[SystemUiOverlay.top],
    // );
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted){
        context.read<LiveStreamCubit1>().connect();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      //context.read<LiveStreamCubit1>().connect();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String myUserId = context.read<LocalUserDataCubit>()
      .currentUserData?.userId ?? '';
    return MultiBlocListener(
      listeners: <SingleChildWidget>[
        BlocListener<LiveStreamCubit1, LiveStreamState1>(
          listenWhen: (LiveStreamState1 prev, LiveStreamState1 cur) 
            => prev.singleKickOutData != cur.singleKickOutData,
          listener: (_, LiveStreamState1 state) {
            if((state.singleKickOutData ?? '').isNotEmpty){
              final String kickDetail = state.singleKickOutData!;
              final List<String> splittedDetail = kickDetail.split('||');
              final String kickedUserId = splittedDetail.first;
              //final String kickedByUserId = splittedDetail.last;
              final LivestreamParticipant? kickedParticipant = 
                state.allParticipants?[kickedUserId];
              
              if(kickedUserId == myUserId){
                context.read<LiveStreamCubit1>().disconnect();
                context.pop();
              }
              else{
                final String username = kickedParticipant?.name 
                  ?? kickedParticipant?.username ?? '';
                context.read<LiveStreamCubit1>().removeAParticipant(kickedUserId);
                showAppNotification(
                  context: context,
                  icon: const ATImgLoader(
                    imgPath: ATImgStrings.kickUserOut,
                    height: 20, width: 20,
                  ),
                  text: '$username has been kicked out',
                  bgColor: ATColors.textRedColor,
                  duration: 3
                );
              }
            }
          },
        ),
      ],
      child: switch (widget.liveScreenEntryParams?.role) {
        null || ParticipantRole.audience =>
          const LiveProgramAudienceView(),
      
        ParticipantRole.cohost =>
          const LiveProgramCohostView(),
      
        ParticipantRole.host =>
          const LiveProgramHostView(),
      },
    );
  }
}



class LiveProgramOverlay extends StatefulWidget {
  const LiveProgramOverlay({
    super.key,
    required this.fullChild,
    required this.miniChild,
    required this.onDismissed,
  });

  final Widget fullChild;
  final Widget miniChild;
  final VoidCallback onDismissed;

  @override
  State<LiveProgramOverlay> createState() => LiveProgramOverlayState();
}

final GlobalKey<LiveProgramOverlayState> liveProgramOverlayKey
  = GlobalKey<LiveProgramOverlayState>();
class LiveProgramOverlayState extends State<LiveProgramOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _slideController;
  late final Animation<Offset> _slideOffset;

  late final AnimationController _morphController;
  bool get isMaximized => _morphController.value == 1.0;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideOffset = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _slideController.forward();

    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
    )..value = 1.0;
  }

  Future<void> toggle() async {
    if (_morphController.isAnimating) return;
    if (isMaximized) {
      await _morphController.reverse();
    } else {
      await _morphController.forward();
    }
  }

  Future<void> dismiss() async {
    await _slideController.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _morphController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const miniHeight = 70.0;
    const miniBottomMargin = 50.0; // not needed with Align bottom
    final fullHeight = screenHeight;

    return SlideTransition(
      position: _slideOffset,
      child: AnimatedBuilder(
        animation: _morphController,
        builder: (context, child) {
          final t = _morphController.value;
          final height = lerpDouble(miniHeight, fullHeight, t)!;
          // Align moves from bottom (t=0) to top (t=1)
          final alignment = Alignment.lerp(
            Alignment.bottomCenter,
            Alignment.topCenter,
            t,
          )!;

          final fullOpacity = t;
          final miniOpacity = 1 - t;

          return Align(
            alignment: alignment,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: lerpDouble(100, 0, t)!,
              ),
              child: SizedBox(
                width: double.infinity,
                height: height,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Opacity(
                      opacity: miniOpacity,
                      child: Transform.scale(
                        scale: lerpDouble(1.0, 0.8, t),
                        alignment: Alignment.bottomCenter,
                        child: widget.miniChild,
                      ),
                    ),
                    Opacity(
                      opacity: fullOpacity,
                      child: widget.fullChild,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// class LiveProgramOverlay extends StatefulWidget {
//   const LiveProgramOverlay({
//     super.key,
//     required this.child,
//     required this.onDismissed,
//   });

//   final Widget child;
//   final VoidCallback onDismissed;

//   @override
//   State<LiveProgramOverlay> createState() => LiveProgramOverlayState();
// }

// final GlobalKey<LiveProgramOverlayState> liveProgramOverlay
//   = GlobalKey<LiveProgramOverlayState>();
// class LiveProgramOverlayState extends State<LiveProgramOverlay>
//     with SingleTickerProviderStateMixin {

//   late final AnimationController _controller;
//   late final Animation<Offset> _offset;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//       reverseDuration: const Duration(milliseconds: 2000),
//     );

//     _offset = Tween<Offset>(
//       begin: const Offset(0, 1), // 👈 bottom of screen
//       end: Offset.zero,          // 👈 full screen
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.decelerate,
//       ),
//     );

//     _controller.forward();
//   }

//   Future<void> dismiss() async {
//     await _controller.reverse();
//     widget.onDismissed();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SlideTransition(
//       position: _offset,
//       child: widget.child,
//     );
//   }
// }
