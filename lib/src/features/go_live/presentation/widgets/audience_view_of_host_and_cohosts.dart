import 'package:amptive/src/config/services/ws_notif_service/ws_channel_service_impl.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/follow_and_subscribe_to_user_modal.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'render_host_and_cohost.dart';

class AudienceViewOfHostAndCohosts extends StatelessWidget {
  const AudienceViewOfHostAndCohosts({
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
      WSConnectionStatus.connected => BlocSelector<LiveStreamCubit1, 
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
      
              return LayoutBuilder(builder: (_, BoxConstraints constraints) {
                final double width = constraints.maxWidth;
                final int totalOthers = 1 + cohosts.length;
      
                final bool onlyHost = totalOthers == 1;
                final bool hostAndACohost = totalOthers == 2;
                final bool hostAnd2Cohosts = totalOthers == 3;
                final bool hostAnd3Cohosts = totalOthers == 4;
                final bool hostAnd4Cohosts = totalOthers == 5;
                final bool hostAnd5Cohosts = totalOthers >= 6;
      
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    if(mainHost != null)RenderAHost(
                      top: onlyHost ? 80 : 6,
                      host: mainHost,
                      onTap: (LivestreamParticipant? mainHost){
                        showFollowAndSubscribeToUserModal(
                          context: context,
                          user: mainHost!
                        );
                      }
                    ),
                    if (cohosts.isNotEmpty)
                      RenderACohost(
                        bottom:
                            hostAndACohost || hostAnd3Cohosts || hostAnd5Cohosts
                                ? 0
                                : hostAnd2Cohosts || hostAnd4Cohosts
                                    ? 30
                                    : null,
                        left: hostAnd2Cohosts || hostAnd4Cohosts
                            ? width * 0.1
                            : null,
                        onTap: (LivestreamParticipant? host){}
                      ),
                    if (cohosts.length > 1)
                      RenderACohost(
                        bottom: hostAnd2Cohosts ||
                                hostAnd3Cohosts ||
                                hostAnd4Cohosts ||
                                hostAnd5Cohosts
                            ? 30
                            : null,
                        left: hostAnd5Cohosts ? width * 0.1 : null,
                        right:
                            hostAnd2Cohosts || hostAnd3Cohosts || hostAnd4Cohosts
                                ? width * 0.1
                                : null,
                        onTap: (LivestreamParticipant? host){}
                      ),
                    if (cohosts.length > 2)
                      RenderACohost(
                        bottom: hostAnd3Cohosts || hostAnd5Cohosts
                            ? 30
                            : hostAnd4Cohosts
                                ? 127
                                : null,
                        right: hostAnd5Cohosts ? width * 0.1 : null,
                        left: hostAnd3Cohosts
                            ? width * 0.1
                            : hostAnd4Cohosts
                                ? 0
                                : null,
                        onTap: (LivestreamParticipant? host){}
                      ),
                    if (cohosts.length > 3)
                      RenderACohost(
                        top: hostAnd4Cohosts || hostAnd5Cohosts ? 35 : null,
                        right: hostAnd4Cohosts || hostAnd5Cohosts ? 0 : null,
                        onTap: (LivestreamParticipant? host){}
                      ),
                    if (cohosts.length > 4)
                      RenderACohost(
                        top: hostAnd5Cohosts ? 35 : null,
                        left: hostAnd5Cohosts ? 0 : null,
                        onTap: (LivestreamParticipant? host){}
                      ),
                  ],
                );
              });
            },
        )
    };
  }
}
