import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/dialogs/confirmation_alert_dialog.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/render_host_and_cohost.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:amptive/src/shared/search_filter_widget.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:nested/nested.dart';
import '../../../../models/host.dart';
import '../../../../bloc/main_app/go_live_bloc/host_view/available_cohosts_bloc.dart';
import '../../../../services/create_show/create_show_service.dart';
import '../../../../livestream/models/livestream_models.dart';

Future<void> showListenersModal({
  required BuildContext context,
  required bool enableKickOut,
  required LiveStreamCubit1 liveStreamCubit,
}) async {
  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: ATColors.hex202020,
    barrierColor: ATColors.black.withValues(alpha: 0.5),
    builder: (BuildContext dContext) {
      return MultiBlocProvider(
        providers: <SingleChildWidget>[
          BlocProvider<LiveStreamCubit1>.value(value: liveStreamCubit),
          BlocProvider<SearchkeyCubit>(create: (_) => SearchkeyCubit())
        ],
        child: Stack(
          children: <Widget>[
            DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.7,
              builder: (_, ScrollController scrollController) {
                return _ListenersModal(
                  scrollController: scrollController,
                  canKickListener: enableKickOut
                );
              },
            ),
            // Positioned(
            //   bottom: 0,
            //   left: 0,
            //   right: 0,
            //   child: BlocBuilder<SelectedCohostsCubit, List<User>>(
            //       builder: (_, List<User> selectedCoHosts) {
            //     final bool activateBtn = selectedCoHosts.isNotEmpty;
            //     return ATBlurredBgBtn(
            //       onPressed:
            //           activateBtn ? () => dContext.pop(selectedCoHosts) : null,
            //       btnTitle: ATStrings.cContinue,
            //     );
            //   }),
            // )
          ],
        ),
      );
    },
  );
}


class _ListenersModal extends StatefulWidget {
  const _ListenersModal({
    required this.scrollController,
    required this.canKickListener,
  });

  final ScrollController scrollController;
  final bool canKickListener;

  @override
  State<_ListenersModal> createState() => _ListenersModalState();
}

class _ListenersModalState extends State<_ListenersModal> {
  @override 
  void initState(){
    super.initState();
    widget.scrollController.addListener(_onCohostsScrollToEnd);
  }

  void _onCohostsScrollToEnd() {
    const double threshHold = 50;
    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent + threshHold) {
      //context.read<AllUsersCubit>().fetchAllUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const ATModalDismisser(),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Row(
            spacing: 4,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ATImgLoader(
                imgPath: ATImgStrings.userIcon,
                width: 20, height: 20
              ),
              Text(ATStrings.listeners,
                  style: context.textTheme.bodyLarge),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Text(
            ATStrings.topListenersRanking,
            maxLines: 2,
            style: context.textTheme.labelSmall!
                .copyWith(color: ATColors.hexC2C2C2.withValues(alpha: 0.76)),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: BlocSelector<LiveStreamCubit1, LiveStreamState1, 
            Map<String, LivestreamParticipant>?>(
            selector: (LiveStreamState1 state) => state.participants,
              builder: (_, Map<String, LivestreamParticipant>? participants) {
            final bool disableTextfield = participants == null
              || participants.isEmpty;

            return AbsorbPointer(
              absorbing: disableTextfield,
              child: SearchFieldWithXSuffix(
                hintText: ATStrings.searchForListener,
                onClear: () {
                  context.read<SearchkeyCubit>().resetSearch();
                  //context.read<AllUsersCubit>().resetSearch();
                },
                onChanged: (String searchKey) {
                  ATHelperFuncs.callDebouncer(500, () {
                    //context.read<AllUsersCubit>().searchUsers(searchKey);
                    context.read<SearchkeyCubit>().updateSearchKey(searchKey);
                  });
                },
              ),
            );
          }),
        ),

        Expanded(
          child: _ListenersList(
            canKickListener: widget.canKickListener,
            scrollController: widget.scrollController,
          )
        ),
      ],
    );
  }
}


class _ListenersList extends StatelessWidget {
  const _ListenersList({
    required this.scrollController,
    required this.canKickListener,
  });

  final bool canKickListener;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final Map<String, LivestreamParticipant>? participants =
      context.select<LiveStreamCubit1, Map<String, LivestreamParticipant>?>(
      (LiveStreamCubit1 cubit) => cubit.state.participants);

    if (participants == null || participants.isEmpty) {
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
      controller: scrollController,
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

        final int adjustedIndex = listIndex - 1;
        final String id = participants.keys.elementAt(adjustedIndex);
        final LivestreamParticipant? participant = participants[id];

        return _ParticipantTile(
          participant: participant,
          canKickListener: canKickListener,
        );
      },
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  const _ParticipantTile({
    required this.participant,
    required this.canKickListener,
  });

  final LivestreamParticipant? participant;
  final bool canKickListener;

  @override
  Widget build(BuildContext context) {
    final bool isHost = participant?.role
      == ParticipantRole.host;

    String userName = '';
    final bool isMe = participant?.userId == context.read<LocalUserDataCubit>()
      .currentUserData?.userId;
    if(isMe){
      userName = ATStrings.you;
    }else{
      userName = participant?.name ?? participant?.username ?? '';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: ATImgLoader(
              imgPath: participant?.profilePicture ?? '',
              height: 50,
              width: 50,
              boxFit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              userName,
              style: context.textTheme.titleMedium,
            ),
          ),
          if (isHost) const HostIndicator() 
          else if(canKickListener)
            ATContainer(
              onTap: () async {
                // Kick out functionality would require integration with the
                // livestream service to properly remove the participant
                // For now, show a confirmation snackbar
                showAppNotification(
                  context: context,
                  icon: const ATImgLoader(
                    imgPath: ATImgStrings.kickUserOut,
                  ),
                  text: 'Kick out feature coming soon',
                  bgColor: ATColors.hex307FE2,
                );
              },
              height: 35,
              width: 35,
              boxShape: BoxShape.circle,
              color: ATColors.white.withValues(alpha: 0.1),
              child: const ATImgLoader(
                boxFit: BoxFit.scaleDown,
                imgPath: ATImgStrings.kickUserOut,
              ),
            ),
        ],
      ),
    );
  }
}
