import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/global_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../go_live_export.dart';
import 'render_host_and_cohost.dart';

class RenderAudienceViewOfHostAndCohosts extends StatelessWidget {
  const RenderAudienceViewOfHostAndCohosts({
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 250,
        width: context.screenWidth,
        child: BlocSelector<LiveStreamCubit1, 
        LiveStreamState1, Organizers?>(
          selector: (LiveStreamState1 state) => state.organizers,
          builder: (_, Organizers? organizers) {
            final LiveSessionParticipant? mainHost = organizers?.host;
            final List<LiveSessionParticipant?> cohosts = 
              organizers?.cohosts ?? <LiveSessionParticipant?>[];
              final List<LiveSessionParticipant> hosts = [];

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
                      // RenderAHost(
                      //   top: onlyHost ? 80 : 6,
                      //   onTap: (Host? host){}
                      // ),
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
                        onTap: (host){}
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
                        onTap: ( host){}
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
                        onTap: ( host){}
                      ),
                    if (cohosts.length > 3)
                      RenderACohost(
                        top: hostAnd4Cohosts || hostAnd5Cohosts ? 35 : null,
                        right: hostAnd4Cohosts || hostAnd5Cohosts ? 0 : null,
                        onTap: ( host){}
                      ),
                    if (cohosts.length > 4)
                      RenderACohost(
                        top: hostAnd5Cohosts ? 35 : null,
                        left: hostAnd5Cohosts ? 0 : null,
                        onTap: ( host){}
                      ),
                  ],
                );
              });
            },
        )
    );
  }
}
