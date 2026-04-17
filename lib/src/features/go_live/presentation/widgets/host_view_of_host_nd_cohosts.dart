import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/render_host_and_cohost.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HostViewOfHostNdCohostDisplay extends StatelessWidget {
  const HostViewOfHostNdCohostDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
      final double width = constraints.maxWidth;
      return BlocSelector<LiveStreamCubit1, 
        LiveStreamState1, Organizers?>(
        selector: (LiveStreamState1 state) => state.organizers,
        builder: (_, Organizers? organizers) {
          final LiveSessionParticipant? mainHost = organizers?.host;
          final List<LiveSessionParticipant?> cohosts = 
            organizers?.cohosts ?? <LiveSessionParticipant?>[];

          final List<LiveSessionParticipant?> paddedCohosts =
          <LiveSessionParticipant?>[
            ...cohosts.take(5),
            ...List<LiveSessionParticipant?>.filled(
                5 - (cohosts.length.clamp(0, 5)), null),
          ];

          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              RenderAHost(
                top: 6,
                host: mainHost,
                onTap: (LiveSessionParticipant? host){},
              ),

              RenderACohost(
                cohost: paddedCohosts[0],
                onTap: (LiveSessionParticipant? cohost){
                  // showFollowAndSubscribeToUserModal(
                  //   context: context, user: cohost!);
                },
                top: 35, left: 0,
              ),
              RenderACohost(
                cohost: paddedCohosts[1],
                onTap: (LiveSessionParticipant? cohost){},
                top: 35, right: 0,
              ),
              RenderACohost(
                cohost: paddedCohosts[2],
                onTap: (LiveSessionParticipant? cohost){},
                bottom: 35, right: width * 0.1,
              ),
              RenderACohost(
                cohost: paddedCohosts[3],
                onTap: (LiveSessionParticipant? cohost){},
                bottom: 35, left: width * 0.1,
              ),
              RenderACohost(
                cohost: paddedCohosts[4],
                onTap: (LiveSessionParticipant? cohost){},
                bottom: 5,
              ),
            ],
          );
        },
      );
    });
  }
}
