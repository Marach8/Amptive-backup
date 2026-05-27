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
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';


Future<String?> showHandRaisersModal({
  required BuildContext context,
  required bool canApproveHandRaise,
  required LiveStreamCubit1 liveStreamCubit,
}) async {
  return await showModalBottomSheet<String>(
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
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          builder: (_, ScrollController scrollController) {
            return _HandRaisersModal(
              scrollController: scrollController,
              canKickListener: canApproveHandRaise
            );
          },
        ),
      );
    },
  );
}


class _HandRaisersModal extends StatefulWidget {
  const _HandRaisersModal({
    required this.scrollController,
    required this.canKickListener,
  });

  final ScrollController scrollController;
  final bool canKickListener;

  @override
  State<_HandRaisersModal> createState() => _HandRaisersModalState();
}

class _HandRaisersModalState extends State<_HandRaisersModal> {
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
                imgPath: ATImgStrings.handRaiseIcon,
                width: 20, height: 20
              ),
              Text('Hand Raise',
                  style: context.textTheme.bodyLarge),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Text(
            'Your listeners who raised their hand to speak appears here. You can permit any of them to speak.',
            maxLines: 2,
            style: context.textTheme.labelSmall!
                .copyWith(color: ATColors.hexC2C2C2.withValues(alpha: 0.76)),
          ),
        ),
        //const SizedBox(height: 20),
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
        //   child: BlocSelector<LiveStreamCubit1, LiveStreamState1, 
        //     List<String>?>(
        //     selector: (LiveStreamState1 state) => state.raisedHandsIds,
        //       builder: (_, List<String>? raisedHandsIds) {
        //     final bool disableTextfield = raisedHandsIds == null
        //       || raisedHandsIds.isEmpty;

        //     return AbsorbPointer(
        //       absorbing: disableTextfield,
        //       child: SearchFieldWithXSuffix(
        //         hintText: ATStrings.searchForListener,
        //         onClear: () {
        //           context.read<SearchkeyCubit>().resetSearch();
        //           //context.read<AllUsersCubit>().resetSearch();
        //         },
        //         onChanged: (String searchKey) {
        //           ATHelperFuncs.callDebouncer(500, () {
        //             //context.read<AllUsersCubit>().searchUsers(searchKey);
        //             context.read<SearchkeyCubit>().updateSearchKey(searchKey);
        //           });
        //         },
        //       ),
        //     );
        //   }),
        // ),

        Expanded(
          child: _HandRaisersList(
            canKickListener: widget.canKickListener,
            scrollController: widget.scrollController,
          )
        ),
      ],
    );
  }
}


class _HandRaisersList extends StatelessWidget {
  const _HandRaisersList({
    required this.scrollController,
    required this.canKickListener,
  });

  final bool canKickListener;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final List<String>? raisedHandsIds =
      context.select<LiveStreamCubit1, List<String>?>(
      (LiveStreamCubit1 cubit) => cubit.state.raisedHandsIds);
    final Map<String, LivestreamParticipant>? participants = 
      context.read<LiveStreamCubit1>().state.participants;

    if (raisedHandsIds == null || raisedHandsIds.isEmpty) {
      return Center(
        child: Text(
          'No hand raisers yet',
          style: context.textTheme.bodyMedium?.copyWith(
            color: ATColors.hexC2C2C2,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: raisedHandsIds.length + 1,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(15, 20, 10, 20),
      itemBuilder: (_, int listIndex) {
        if (listIndex == 0) {
          final int raisedHands = raisedHandsIds.length;
          final String text = raisedHands == 1
            ? '1 hand raised'
            : '$raisedHands hands raised';
          return Text(
            text,
            style: context.textTheme.bodyMedium,
          );
        }

        final int adjustedIndex = listIndex - 1;
        final String id = raisedHandsIds[adjustedIndex];
        final LivestreamParticipant? participant = participants?[id];

        return _HandRaiserTile(
          participant: participant,
          canPermitHandRaise: canKickListener,
        );
      },
    );
  }
}

class _HandRaiserTile extends StatelessWidget {
  const _HandRaiserTile({
    required this.participant,
    required this.canPermitHandRaise,
  });

  final LivestreamParticipant? participant;
  final bool canPermitHandRaise;

  @override
  Widget build(BuildContext context) {
    final bool isHost = participant?.role
      == ParticipantRole.host;

    String userName = '';
    final bool isMe = participant?.userId == context.read<LocalUserDataCubit>()
      .currentUserData?.userId;
    if(isMe){
      userName = ATStrings.you;
    } else{
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
          else if(canPermitHandRaise)
            ATContainer(
              onTap: () async {
                context.pop(participant?.userId);
              },
              height: 35,
              width: 35, radius: 20,
              boxShape: BoxShape.circle,
              color: ATColors.white.withValues(alpha: 0.1),
              child: Icon(
                Icons.check,
                size: 20,
                color: ATColors.white,
              ),
            ),
        ],
      ),
    );
  }
}
