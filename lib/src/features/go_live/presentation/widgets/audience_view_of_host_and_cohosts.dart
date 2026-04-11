import 'package:amptive/src/features/go_live/cubits/livestream_bloc.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/livestream/livestream.dart';
import 'package:amptive/src/models/host.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/main_app/go_live_bloc/host_view/cohosts_display_bloc.dart';
import '../../../../services/go_live_service/go_live_service.dart';
import '../../go_live_export.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_host_widget_for_audience_view.dart';

class AudienceViewOfHostAndCohostWidget extends StatelessWidget {
  const AudienceViewOfHostAndCohostWidget({
    super.key,
  });
  static final GoLiveService service = GoLiveService();

  @override
  Widget build(BuildContext context) {
    return ATContainer(
        height: 250,
        width: context.screenWidth,
        child: BlocBuilder<LivestreamBloc, LivestreamState>(
          builder: (BuildContext context, LivestreamState state) {
            final List<LivestreamParticipant> participants = state.participants;

            if (participants.isEmpty) {
              return Center(
                child: Text(
                  'Waiting for host...',
                  style: TextStyle(color: ATColors.hexC2C2C2),
                ),
              );
            }

            final List<LivestreamParticipant> hosts =
                participants.where((p) => p.isHost).toList();
            final List<LivestreamParticipant> cohosts =
                participants.where((p) => !p.isHost).toList();

            return LayoutBuilder(builder: (_, BoxConstraints constraints) {
              final double width = constraints.maxWidth;
              final int totalOthers = hosts.length + cohosts.length;

              final bool onlyHost = totalOthers == 1;
              final bool hostAndACohost = totalOthers == 2;
              final bool hostAnd2Cohosts = totalOthers == 3;
              final bool hostAnd3Cohosts = totalOthers == 4;
              final bool hostAnd4Cohosts = totalOthers == 5;
              final bool hostAnd5Cohosts = totalOthers >= 6;

              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  if (hosts.isNotEmpty)
                    GoLiveHostWidget(
                      top: onlyHost ? 80 : 6,
                      hostName: hosts.first.displayName,
                      hostProfilePic: hosts.first.avatar ?? '',
                    ),
                  if (cohosts.isNotEmpty)
                    AmptiveLiveHostAndCoHostWidgetForAudienceView(
                      bottom:
                          hostAndACohost || hostAnd3Cohosts || hostAnd5Cohosts
                              ? 0
                              : hostAnd2Cohosts || hostAnd4Cohosts
                                  ? 30
                                  : null,
                      left: hostAnd2Cohosts || hostAnd4Cohosts
                          ? width * 0.1
                          : null,
                      index: 1,
                      service: service,
                      hostOrCohost: cohosts.length > 0
                          ? _convertToHost(cohosts[0])
                          : null,
                      onTap: (ObjectWithNotifier<Host>? hostOrCohost) {},
                    ),
                  if (cohosts.length > 1)
                    AmptiveLiveHostAndCoHostWidgetForAudienceView(
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
                      index: 2,
                      service: service,
                      hostOrCohost: cohosts.length > 1
                          ? _convertToHost(cohosts[1])
                          : null,
                      onTap: (ObjectWithNotifier<Host>? hostOrCohost) {},
                    ),
                  if (cohosts.length > 2)
                    AmptiveLiveHostAndCoHostWidgetForAudienceView(
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
                      index: 3,
                      service: service,
                      hostOrCohost: cohosts.length > 2
                          ? _convertToHost(cohosts[2])
                          : null,
                      onTap: (ObjectWithNotifier<Host>? hostOrCohost) {},
                    ),
                  if (cohosts.length > 3)
                    AmptiveLiveHostAndCoHostWidgetForAudienceView(
                      top: hostAnd4Cohosts || hostAnd5Cohosts ? 35 : null,
                      right: hostAnd4Cohosts || hostAnd5Cohosts ? 0 : null,
                      index: 4,
                      service: service,
                      hostOrCohost: cohosts.length > 3
                          ? _convertToHost(cohosts[3])
                          : null,
                      onTap: (ObjectWithNotifier<Host>? hostOrCohost) {},
                    ),
                  if (cohosts.length > 4)
                    AmptiveLiveHostAndCoHostWidgetForAudienceView(
                      top: hostAnd5Cohosts ? 35 : null,
                      left: hostAnd5Cohosts ? 0 : null,
                      index: 5,
                      service: service,
                      hostOrCohost: cohosts.length > 4
                          ? _convertToHost(cohosts[4])
                          : null,
                      onTap: (ObjectWithNotifier<Host>? hostOrCohost) {},
                    ),
                ],
              );
            });
          },
        ));
  }

  ObjectWithNotifier<Host>? _convertToHost(LivestreamParticipant participant) {
    final Host host = Host(
      id: null,
      username: participant.displayName,
      email: null,
      profilePicture: participant.avatar,
      name: participant.displayName,
    );
    return ObjectWithNotifier<Host>(obj: host);
  }
}
