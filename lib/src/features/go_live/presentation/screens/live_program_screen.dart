import 'dart:developer' show log;
import 'dart:ui';

import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
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

  late final AnimationController _slideInController, _minMaxController;
  late final Animation<Offset> _slideInAnimation;
  static const double _miniHeight = 100;
  bool isMinimized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted){
        context.read<LiveStreamCubit1>().connect();
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      }
    });

    _slideInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 500),
    );
    _minMaxController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
    );

    _slideInAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // 👈 bottom of screen
      end: Offset.zero,          // 👈 full screen
    ).animate(
      CurvedAnimation(
        parent: _slideInController,
        curve: Curves.decelerate,
      ),
    );

    _slideInController.forward();
  }

  Future<void> dismiss() async {
    context.read<LiveStreamCubit1>().disconnect();
    await _slideInController.reverse();
    widget.onDismissed();
  }

  void minimize() async{
    await _minMaxController.forward();
    isMinimized = true;
  }

  void maximize()async{
    await _minMaxController.reverse();
    isMinimized = false;
  }

  @override
  void dispose() {
    _slideInController.dispose();
    _minMaxController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
      child: SlideTransition(
        position: _slideInAnimation,
        child: AnimatedBuilder(
          animation: _minMaxController,
          builder: (_, __){
            final double t = _minMaxController.value;
            final double height = lerpDouble(
              context.screenHeight,
              _miniHeight,
              t
            )!;
            
            final bool shouldShowMini = t > 0.7;
            return Align(
              alignment: const Alignment(0, 0.75),
              child: AnimatedCrossFade(
                alignment: const Alignment(0, 0.75),            
                crossFadeState: shouldShowMini ? 
                  CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 100),
                firstCurve: Curves.easeInOut,
                secondCurve: Curves.easeInOut,
                sizeCurve: Curves.easeInOut,
                reverseDuration: const Duration(milliseconds: 100),
                excludeBottomFocus: false,
                secondChild: widget.miniChild,
                firstChild: SizedBox(
                  height: height,
                  child: Transform.scale(
                    alignment: const Alignment(0, 0.75),
                    scaleY: lerpDouble(1.0, 0.1, t),
                    child: widget.fullChild,
                  ),
                ),
              ),
            );
          }
        )
      ),
    );
  }
}



class FullLiveProgramScreen extends StatelessWidget {
  const FullLiveProgramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ParticipantRole? myRole = 
      context.read<LiveStreamCubit1>().state.myRole;
    return switch (myRole) {
      null || ParticipantRole.audience =>
        const LiveProgramAudienceView(),
    
      ParticipantRole.cohost =>
        const LiveProgramCohostView(),
    
      ParticipantRole.host =>
        const LiveProgramHostView(),
    };
  }
}
