import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/shared/confirmation_alert_dialog.dart';
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
import 'package:nested/nested.dart';


Future<void> showListenersModal({
  required BuildContext context,
  required bool enableKickOut,
  required LiveStreamCubit1 liveStreamCubit,
  required LocalUserDataCubit localUserDataCubit,
}) async {
  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    useRootNavigator: true,
    backgroundColor: ATColors.hex202020,    
    barrierColor: ATColors.black.withValues(alpha: 0.5),
    builder: (BuildContext dContext) {
      return MultiBlocProvider(
        providers: <SingleChildWidget>[
          BlocProvider<LiveStreamCubit1>.value(value: liveStreamCubit),
          BlocProvider<LocalUserDataCubit>.value(value: localUserDataCubit),
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
            selector: (LiveStreamState1 state) => state.allParticipants,
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
    final List<String> allParticipantsIds =
      context.select<LiveStreamCubit1, List<String>>(
      (LiveStreamCubit1 cubit) => cubit.state.allParticipantsIds ?? <String>[]);


    if (allParticipantsIds.isEmpty) {
      return Center(
        child: Text(
          'No listeners yet',
          style: context.textTheme.bodyMedium?.copyWith(
            color: ATColors.hexC2C2C2,
          ),
        ),
      );
    }

    final Map<String, LivestreamParticipant>? allParticipants 
      = context.read<LiveStreamCubit1>().state.allParticipants;

    return ListView.builder(
      controller: scrollController,
      itemCount: allParticipantsIds.length + 1,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(15, 20, 10, 20),
      itemBuilder: (_, int listIndex) {
        if (listIndex == 0) {
          return Text(
            'Top Listeners (${allParticipantsIds.length})',
            style: context.textTheme.bodyMedium,
          );
        }

        final int adjustedIndex = listIndex - 1;
        final String id = allParticipantsIds[adjustedIndex];
        final LivestreamParticipant? participant = allParticipants?[id];

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
    final bool isMe = participant?.userId == context
      .read<LocalUserDataCubit>().currentUserData?.userId;
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
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 8,
              children: <Widget>[
                MuteUmuteListenerBtn(
                  participantId: participant?.userId?? ''),
                ATContainer(
                  onTap: () async {
                    final bool? shouldKickOut = await showKickOutConfirmationDialog(
                      context: context,
                      title: 'Are you kicking out $userName?',
                      content: '$userName will be unable to join this current live program but can join your future live sessions',
                      listenerPic: participant?.profilePicture ?? ATImgStrings.jpeg1,
                    );
                    if(context.mounted && shouldKickOut == true){
                      context.read<LiveStreamCubit1>()
                        .kickOutListener(participant?.userId?? '');
                    }
                  },
                  height: 35, width: 35, radius: 20,
                  color: ATColors.white.withValues(alpha: 0.1),
                  child: const ATImgLoader(
                    boxFit: BoxFit.scaleDown,
                    imgPath: ATImgStrings.kickUserOut,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}


class MuteUmuteListenerBtn extends StatelessWidget {
  const MuteUmuteListenerBtn({
    super.key,
    required this.participantId,
  });

  final String participantId;

  @override
  Widget build(BuildContext context) {
    final List<String> unMutedParticipantIds = context.select(
      (LiveStreamCubit1 cubit) => cubit.state.unMutedParticipantIds
    ) ?? <String>[];

    final bool micIsActive = unMutedParticipantIds.contains(participantId);

    return ATContainer(
      onTap: () async {
        if(micIsActive){
          context.read<LiveStreamCubit1>().muteListener(participantId);
        }
        else{
          context.read<LiveStreamCubit1>().unMuteListener(participantId);
        }
      },
      height: 35, width: 35, radius: 20,
      color: ATColors.white.withValues(alpha: micIsActive ? 0.3 : 0.1),
      child: Icon(
        micIsActive ? Icons.mic : Icons.mic_off,
        size: 22
      ),
    );
  }
}
