import 'package:amptive/src/config/services/ws_notif_service/ws_channel_service_impl.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/follow_and_subscribe_to_user_modal.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/render_host_and_cohost.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef CohostPosition = ({
  double? left, double? right,
  double? top, double? bottom,
});


class HostViewOfHostNdCohostDisplay extends StatelessWidget {
  const HostViewOfHostNdCohostDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final WSConnectionStatus wsConnectionStatus = 
    context.select<LiveStreamCubit1, WSConnectionStatus>(
      (LiveStreamCubit1 cubit) => cubit.state.wsConnectionStatus,
    );
    return switch(wsConnectionStatus){
      WSConnectionStatus.initial ||
      WSConnectionStatus.connecting ||
      WSConnectionStatus.reconnecting => const Center(
        child: ATLoadingIndicator(),
      ),
      WSConnectionStatus.disconnected ||
      WSConnectionStatus.failed => const Text(
        'Error occured',
      ),
      WSConnectionStatus.connected => LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          const int maxCohosts = 5;
          final double width = constraints.maxWidth;

          final Map<int, CohostPosition> positionMap = 
            <int, CohostPosition>{
              0: (top: 35, left: 0, right: null, bottom: null),
              1: (top: 35, right: 0, left: null, bottom: null),
              2: (bottom: 35, right: width * 0.1, top: null, left: null),
              3: (bottom: 35, left: width * 0.1, top: null, right: null),
              4: (bottom: 5, left: null, right: null, top: null),
            };

          return BlocSelector<LiveStreamCubit1, 
            LiveStreamState1, OrganizersIDs?>(
            selector: (LiveStreamState1 state) => state.organizersIds,
            builder: (_, OrganizersIDs? organizers) {
              final Map<String, LivestreamParticipant>? allParticipants
              = context.read<LiveStreamCubit1>().state.allParticipants;

              final LivestreamParticipant? mainHost = 
                allParticipants?[organizers?.hostId ?? ''];
              final List<LivestreamParticipant?> cohosts = 
                (organizers?.cohostsIds ?? <String>[])
                  .map((String id) => allParticipants?[id]).toList();

              final List<LivestreamParticipant?> paddedCohosts =
              <LivestreamParticipant?>[
                ...cohosts.take(maxCohosts),
                ...List<LivestreamParticipant?>.filled(
                  maxCohosts - (
                    cohosts.length.clamp(0, maxCohosts)
                  ), null
                ),
              ];

              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  RenderAHost(
                    top: 6,
                    host: mainHost,
                    onTap: (LivestreamParticipant? host){},
                  ),
                  
                  ...paddedCohosts.indexed.map(
                    ((int index, LivestreamParticipant?) cohost){
                      final CohostPosition? position = positionMap[cohost.$1];
                      return RenderACohost(
                        cohost: cohost.$2,
                        onTap: (LivestreamParticipant? cohost){
                          if(cohost != null){
                            showFollowAndSubscribeToUserModal(
                              context: context,
                              user: cohost
                            );
                          }
                        },
                        top: position?.top,
                        left: position?.left,
                        right: position?.right,
                        bottom: position?.bottom,
                      );
                    }
                  )
                ],
              );
            },
          );
        }
      )
    };
  }
}
