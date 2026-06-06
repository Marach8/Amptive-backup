import 'dart:ui';
import 'package:amptive/src/config/api_response_and_app_state.dart';
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
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final ValueChanged<String?> onDismissed;

  @override
  State<LiveProgramOverlay> createState() => LiveProgramOverlayState();
}

final GlobalKey<LiveProgramOverlayState> liveProgramOverlayKey
  = GlobalKey<LiveProgramOverlayState>();
class LiveProgramOverlayState extends State<LiveProgramOverlay>
    with SingleTickerProviderStateMixin {
  
  late final ValueNotifier<Offset> _dragNotifier;
  late final AnimationController _minMaxController;
  static const double _miniHeight = 100;
  Alignment _transitionCenter = const Alignment(0, 0.76);
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

    _minMaxController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
    );
    //Subtract 15 from miniHeight to bring down the mini child a close to bottom bar.
    _dragNotifier = ValueNotifier<Offset>(const Offset(0, _miniHeight - 15));
  }

  Alignment _calculateAlignment(Offset miniChildPosition) {
    const double miniChildHeight = 60;
    final double miniChildWidth = context.screenWidth - 20;

    final double centerX = (miniChildPosition.dx + (miniChildWidth / 2));

    final double centerY =
      context.screenHeight - (miniChildPosition.dy + (miniChildHeight / 2));

    final double alignX = (
      ((centerX / context.screenWidth) * 2) - 1
    );

    final double alignY = (
      ((centerY / context.screenHeight) * 2) - 1
    );

    return Alignment(alignX, alignY);
  }

  Future<void> dismissLiveProgram({String? dismissReason}) async {
    context.read<LiveStreamCubit1>().disconnect();
    widget.onDismissed(dismissReason);
  }

  void minimize() async{
    _transitionCenter = _calculateAlignment(_dragNotifier.value);
    await _minMaxController.forward();
    isMinimized = true;
  }

  void maximize()async{
    _transitionCenter = _calculateAlignment(_dragNotifier.value);
    await _minMaxController.reverse();
    isMinimized = false;
  }

  @override
  void dispose() {
    _minMaxController.dispose();
    _dragNotifier.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        AnimatedBuilder(
          animation: _minMaxController,
          builder: (_, __){
            final double t = _minMaxController.value;
    
            final bool showMiniChild = t > 0.99;
            return Offstage(
              offstage: showMiniChild,
              child: Transform.scale(
                alignment: _transitionCenter,
                //alignment: Alignment(_dragNotifier.value.dx, _dragNotifier.value.dy),
                //alignment: const Alignment(0, 0.75),
                scaleY: lerpDouble(1.0, 0.08, t),
                child: widget.fullChild,
              ),
            );
          }
        ),
    
        AnimatedBuilder(
          animation: _minMaxController,
          builder: (_, __){
            final double t = _minMaxController.value;
            final bool showMiniChild = t > 0.99;
    
            return ValueListenableBuilder<Offset>(
              valueListenable: _dragNotifier,
              child: GestureDetector(
                onTap: (){
                  liveProgramOverlayKey.currentState?.maximize();
                },
                onPanUpdate: (DragUpdateDetails dragDetails){
                  _dragNotifier.value = Offset(
                    _dragNotifier.value.dx + dragDetails.delta.dx,
                    _dragNotifier.value.dy - dragDetails.delta.dy,
                  );
                },
                child: widget.miniChild
              ),
              builder: (_, Offset value, Widget? child) {
                return Positioned(
                  left: value.dx,
                  bottom: value.dy,
                  child: Offstage(
                    offstage: !showMiniChild,
                    child: child!,
                  )
                );
              }
            );
          }
        ),
      ],
    );
  }
}



class FullLiveProgramScreen extends StatelessWidget {
  const FullLiveProgramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ParticipantRole? myRole = 
      context.read<LiveStreamCubit1>().state.myRole;
    final String myUserId = context.read<LocalUserDataCubit>()
      .currentUserData?.userId ?? '';
    return MultiBlocListener(
      listeners: <SingleChildWidget>[
        BlocListener<EndLiveProgramCubit, ATAppState<LoadingStage>>(
          listener: (_, ATAppState<LoadingStage> state)async{
            if(state is SuccessState<LoadingStage>) {
              context.read<LiveStreamCubit1>().endLiveStream();
            }
          }
        ),

        BlocListener<LiveStreamCubit1, LiveStreamState1>(
          listenWhen: (LiveStreamState1 prev, LiveStreamState1 cur) 
            => (prev.singleKickOutData != cur.singleKickOutData)
              || (prev.liveStreamEnded != cur.liveStreamEnded),
          listener: (_, LiveStreamState1 state)async{

            if(state.liveStreamEnded == true){
              await Future<void>.delayed(const Duration(seconds: 1));
              liveProgramOverlayKey.currentState?.dismissLiveProgram(
                dismissReason: 'This Live stream has ended',
              );
              return;
            }

            if((state.singleKickOutData ?? '').isNotEmpty){
              final String kickDetail = state.singleKickOutData!;
              final List<String> splittedDetail = kickDetail.split('||');
              final String kickedUserId = splittedDetail.first;
              //final String kickedByUserId = splittedDetail.last;
              final LivestreamParticipant? kickedParticipant = 
                state.allParticipants?[kickedUserId];
              
              if(kickedUserId == myUserId){
                liveProgramOverlayKey.currentState?.dismissLiveProgram(
                  dismissReason: 'You have been kicked out!',
                );
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
      child: SafeArea(
        bottom: false,
        child: Material(
          color: ATColors.transparent,
          child: switch (myRole) {
            null || ParticipantRole.audience =>
              const LiveProgramAudienceView(),
          
            ParticipantRole.cohost =>
              const LiveProgramCohostView(),
          
            ParticipantRole.host =>
              const LiveProgramHostView(),
          },
        ),
      ),
    );
  }
}
