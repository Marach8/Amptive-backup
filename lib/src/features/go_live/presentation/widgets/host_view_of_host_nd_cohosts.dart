import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_bloc.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/livestream/livestream.dart';
import 'package:amptive/src/models/host.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/main_app/go_live_bloc/host_view/cohosts_display_bloc.dart';
import '../../go_live_export.dart';

class HostViewOfHostNdCohostDisplay extends StatelessWidget {
  const HostViewOfHostNdCohostDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      final double width = constraints.maxWidth;
      return BlocBuilder<LiveStreamCubit1, LiveStreamState1>(
        builder: (BuildContext context, LiveStreamState1 state) {
          final List<LivestreamParticipant> participants = [];

          if (participants.isEmpty) {
            return Center(
              child: Text(
                'Waiting for participants...',
                style: TextStyle(color: ATColors.hexC2C2C2),
              ),
            );
          }

          final List<LivestreamParticipant> hosts =
              participants.where((p) => p.isHost).toList();
          final List<LivestreamParticipant> cohosts =
              participants.where((p) => !p.isHost).toList();

          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              if (hosts.isNotEmpty)
                // GoLiveHostWidget(
                //   top: cohosts.isEmpty ? 80 : 6,
                //   hostName: hosts.first.displayName,
                //   hostProfilePic: hosts.first.avatar ?? '',
                // ),
              if (cohosts.isNotEmpty)
                CohostWidget4HostView(
                  top: 35,
                  left: 0,
                  index: 0,
                  coHostName: cohosts[0].displayName,
                  coHostProfilePicture: cohosts[0].avatar,
                  onTap: () {},
                ),
              if (cohosts.length > 1)
                CohostWidget4HostView(
                  top: 35,
                  right: 0,
                  index: 1,
                  coHostName: cohosts[1].displayName,
                  coHostProfilePicture: cohosts[1].avatar,
                  onTap: () {},
                ),
              if (cohosts.length > 2)
                CohostWidget4HostView(
                  bottom: 35,
                  right: width * 0.1,
                  index: 2,
                  coHostName: cohosts[2].displayName,
                  coHostProfilePicture: cohosts[2].avatar,
                  onTap: () {},
                ),
              if (cohosts.length > 3)
                CohostWidget4HostView(
                  bottom: 35,
                  left: width * 0.1,
                  index: 3,
                  coHostName: cohosts[3].displayName,
                  coHostProfilePicture: cohosts[3].avatar,
                  onTap: () {},
                ),
              if (cohosts.length > 4)
                CohostWidget4HostView(
                  bottom: 5,
                  index: 4,
                  coHostName: cohosts[4].displayName,
                  coHostProfilePicture: cohosts[4].avatar,
                  onTap: () {},
                ),
            ],
          );
        },
      );
    });
  }
}
