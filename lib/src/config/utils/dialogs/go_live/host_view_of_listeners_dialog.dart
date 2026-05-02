import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/dialogs/confirmation_alert_dialog.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:amptive/src/shared/search_filter_widget.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import '../../../../models/host.dart';
import '../../../../bloc/main_app/go_live_bloc/host_view/available_cohosts_bloc.dart';
import '../../../../services/create_show/create_show_service.dart';
import '../../../../livestream/models/livestream_models.dart';

Future<ATCohost<bool>?> showListenersDialog(
    {required BuildContext context,
    bool? enableKickOut,
    List<LivestreamParticipant>? participants}) async {
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();

  final ValueNotifier<bool> showSuffixIconNotifier = ValueNotifier(false);
  focusNode.addListener(() => focusNode.hasFocus
      ? showSuffixIconNotifier.value = true
      : showSuffixIconNotifier.value = false);

  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: ATColors.hex202020,
    builder: (BuildContext dContext) {
      return BlocProvider<SearchkeyCubit>(
        create: (_) => SearchkeyCubit(),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          builder: (BuildContext bContext, ScrollController scrollController) {
            return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Align(
                        alignment: Alignment.center, child: ATModalDismisser()),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ATImgLoader(imgPath: ATImgStrings.userIcon),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(ATStrings.LISTENERS,
                              style: context.textTheme.bodyLarge),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Text(
                        ATStrings.TOP_LISTENERS_DESC,
                        maxLines: 2,
                        style: context.textTheme.labelSmall!.copyWith(
                            color: ATColors.hexC2C2C2.withValues(alpha: 0.76)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                      child: SearchFieldWithXSuffix(
                        hintText: ATStrings.SEARCH_4_LISTENERS,
                        onClear: () {
                          // bContext.read<SearchkeyBloc>().resetSearch();
                          // dContext.read<CohostServiceBloc>().resetCohostSearch();
                        },
                        onChanged: (String searchKey) =>
                            ATHelperFuncs.callDebouncer(
                          200,
                          () => context
                              .read<AmptiveGoLiveAvailableCoHostsBloc>()
                              .add(SearchCohostEvent(searchKey: searchKey)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ATScrollBar(
                        extScrollCntrl: scrollController,
                        child: _ListenersList(
                          participants: participants ?? [],
                          enableKickOut: enableKickOut,
                        ),
                      ),
                    ),
                  ],
                ));
          },
        ),
      );
    },
  );
}

// Keep old _ListenerWidget for backwards compatibility or remove if not needed
// The new _ListenersList and _ParticipantTile handle the participant list

class _ListenersList extends StatelessWidget {
  const _ListenersList({
    required this.participants,
    this.enableKickOut,
  });

  final List<LivestreamParticipant> participants;
  final bool? enableKickOut;

  @override
  Widget build(BuildContext context) {
    if (participants.isEmpty) {
      return Center(
        child: Text(
          'No participants yet',
          style: context.textTheme.bodyMedium?.copyWith(
            color: ATColors.hexC2C2C2,
          ),
        ),
      );
    }

    return ListView.builder(
      primary: true,
      itemCount: participants.length + 1,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(15, 20, 10, 20),
      itemBuilder: (_, int listIndex) {
        if (listIndex == 0) {
          return Text(
            'Participants (${participants.length})',
            style: context.textTheme.bodyMedium,
          );
        }
        return const SizedBox();
        // final LivestreamParticipant participant = participants[listIndex - 1];
        // return _ParticipantTile(
        //   participant: participant,
        //   index: listIndex,
        //   enableKickOut: enableKickOut,
        // );
      },
    );
  }
}

// class _ParticipantTile extends StatelessWidget {
//   const _ParticipantTile({
//     required this.participant,
//     required this.index,
//     this.enableKickOut,
//   });

//   final LivestreamParticipant participant;
//   final int index;
//   final bool? enableKickOut;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 15),
//       child: Row(
//         children: <Widget>[
//           ATImgLoader(
//             imgPath: participant.profilePicture ?? '',
//             height: 50,
//             width: 50,
//             boxFit: BoxFit.cover,
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   participant.displayName,
//                   style: context.textTheme.titleMedium,
//                 ),
//                 if (participant.isHost)
//                   Text(
//                     'Host',
//                     style: context.textTheme.bodySmall?.copyWith(
//                       color: ATColors.hex307FE2,
//                     ),
//                   ),
//                 if (participant.isSpeaker && !participant.isHost)
//                   Text(
//                     'Speaker',
//                     style: context.textTheme.bodySmall?.copyWith(
//                       color: ATColors.hex009C80,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           if (enableKickOut ?? true)
//             ATContainer(
//               onTap: () async {
//                 // Kick out functionality would require integration with the
//                 // livestream service to properly remove the participant
//                 // For now, show a confirmation snackbar
//                 showAppNotification(
//                   context: context,
//                   icon: const ATImgLoader(
//                     imgPath: ATImgStrings.KICK_USER_OUT,
//                   ),
//                   text: 'Kick out feature coming soon',
//                   bgColor: ATColors.hex307FE2,
//                 );
//               },
//               height: 35,
//               width: 35,
//               boxShape: BoxShape.circle,
//               color: ATColors.white.withOpacity(0.1),
//               child: const ATImgLoader(
//                 boxFit: BoxFit.scaleDown,
//                 imgPath: ATImgStrings.KICK_USER_OUT,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
