import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/end_live_program_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/presentation/screens/go_live_onboarding_screen.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_audience_view.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_cohost_view.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_host_view.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/host_moderation_tools_btns.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';

enum ParticipantRole {
  audience('audience'),
  cohost('cohost'),
  host('host');

  const ParticipantRole(this.value);

  final String value;

  static ParticipantRole fromJson(String? value) {
    switch (value?.toLowerCase()) {
      case 'host':
        return ParticipantRole.host;
      case 'cohost':
        return ParticipantRole.cohost;
      default:
        return ParticipantRole.audience; // fallback
    }
  }
}



class LiveProgramScreen extends StatelessWidget {
  const LiveProgramScreen({super.key, this.liveScreenEntryParams});
  final LiveProgramEntryParams? liveScreenEntryParams;

  @override
  Widget build(BuildContext context) {
    final CachedUserData? userData = context
      .read<LocalUserDataCubit>().currentUserData;

    final LiveSessionParticipant participant = LiveSessionParticipant(
      isMuted: false,
      isSpeaking: false,
      isLocal: true,
      audioLevel: 0,
      participantType: liveScreenEntryParams?.role
        ?? ParticipantRole.audience,
      roomParticipantId: liveScreenEntryParams?.roomParticipantId ?? '',
      name: userData?.name ?? '',
      username: userData?.username ?? '',
      userId: userData?.userId ?? '',
      profilePicture: userData?.pictureUrl ?? '',
      followersCount: int.tryParse(userData?.followersCount ?? '0'),
      followingCount: int.tryParse(userData?.followingCount ?? '0'),
    );

    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<GoLiveControlsVisibilityBloc>(
          create: (_) => GoLiveControlsVisibilityBloc()
        ),
        BlocProvider<LiveStreamCubit1>(
          create: (_) => LiveStreamCubit1(
            initialState: LiveStreamState1(
              programCoverUrl: liveScreenEntryParams?.coverUrl,
              liveStreamId: liveScreenEntryParams?.streamId,
              roomUrl: liveScreenEntryParams?.roomUrl,
              roomEntryToken: liveScreenEntryParams?.roomEntryToken,
              community: liveScreenEntryParams?.community,
              programTitle: liveScreenEntryParams?.programTitle,
              programDesc: liveScreenEntryParams?.programDesc,
            )
          ),
        ),
        BlocProvider<EndLiveProgramCubit>(
          create: (_) => EndLiveProgramCubit(),
        ),
      ],
      child: _SubWidget(
        liveScreenEntryParams: liveScreenEntryParams,
      ),
    );
  }
}

class _SubWidget extends StatefulWidget {
  const _SubWidget({
    required this.liveScreenEntryParams
  });

  final LiveProgramEntryParams? liveScreenEntryParams;

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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (didPop) return;
        context.read<LiveStreamCubit1>().disconnect();
        context.pop();
      },
      child: switch (widget.liveScreenEntryParams?.role) {
        null || ParticipantRole.audience =>
          const LiveProgramAudienceView(),
      
        ParticipantRole.cohost =>
          const LiveProgramCohostView(),
      
        ParticipantRole.host =>
          const LiveProgramHostView(),
      }
    );
  }
}
