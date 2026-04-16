import 'dart:developer';

import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/models/go_live_program_params.dart';
import 'package:amptive/src/features/go_live/presentation/screens/go_live_onboarding_screen.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_audience_view.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_cohost_view.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_host_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum LiveParticipantType { audience, cohost, host }

class LiveProgramScreen extends StatelessWidget {
  const LiveProgramScreen({super.key, this.liveScreenEntryParams});
  final LiveProgramEntryParams? liveScreenEntryParams;

  @override
  Widget build(BuildContext context) {
    log('Thisis the entry params ${liveScreenEntryParams?.coverUrl}');
    return BlocProvider<LiveStreamCubit1>(
      create: (_) => LiveStreamCubit1(
        initialState: LiveStreamState1(
          programCoverUrl: liveScreenEntryParams?.coverUrl
        )
      ),
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

class __SubWidgetState extends State<_SubWidget> {

  @override
  void initState() {
    super.initState();

    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.manual,
    //   overlays: <SystemUiOverlay>[SystemUiOverlay.top],
    // );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted){
        context.read<LiveStreamCubit1>().connect(
          roomUrl: widget.liveScreenEntryParams?.roomUrl ?? '',
          participantToken: widget.liveScreenEntryParams?.roomEntryToken ?? '',
        );
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.liveScreenEntryParams?.participantType) {
      null ||
      LiveParticipantType.audience =>
        const LiveProgramAudienceView(),
      LiveParticipantType.cohost => 
        const LiveProgramCohostView(),
      LiveParticipantType.host =>
        const LiveProgramHostView(),
    };
  }
}
