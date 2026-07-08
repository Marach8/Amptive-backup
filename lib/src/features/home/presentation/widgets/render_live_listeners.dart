import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/home/cubits/live_listeners_cubit.dart';
import 'package:amptive/src/shared/row_of_people_listening_widget.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/utils/colors.dart';
import '../../../../shared/overlapping_widgets.dart';

class RenderLiveListeners extends StatelessWidget {
  const RenderLiveListeners({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LiveListenersCubit, ATAppState<dynamic>>(
      listener: (_, ATAppState<dynamic> state){
        if(state is FailureState<dynamic>){
          showAppNotification2(
            text: state.message,
            type: NotificationType.failure,
          );
        }
      },
      builder: (_, ATAppState<dynamic> state) {
        return switch (state){
          InitialState<dynamic>() ||
          LoadingState<dynamic>() => const _LiveListenersLoading(),
          FailureState<dynamic>() => Center(
            child: IconButton(
              onPressed: (){
                context.read<LiveListenersCubit>().fetchLiveListeners();
              },
              icon: const Icon(Icons.refresh, size: 30),
            ),
          ),
          SuccessState<dynamic>() => Builder(
            builder: (_){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Text(
                  '${widget.homeFeedItem?.viewerCount ?? 0} Listening',
                  style: context.textTheme.bodySmall
                      ?.copyWith(fontSize: 17),
                ),
                Divider(
                  color:
                      ATColors.white.withValues(alpha: 0.1),
                ),
                const SizedBox(height: 10),
                if((widget.homeFeedItem?.avatarUrls ?? <String>[]).isNotEmpty)
                  ...<Widget>[
                    PeopleListeningWithNumberStacked(
                      images: widget.homeFeedItem!.avatarUrls!,
                      noOfListeners: widget.homeFeedItem?.viewerCount ?? 0,
                    ),
                    const SizedBox(height: 20),
                  ],
                Text(
                    'daniel, jessica, gerald, peter and 652 more',
                    style: context.textTheme.bodySmall
                        ?.copyWith(
                            color: ATColors.white
                                .withValues(alpha: 0.6)),
                  ),
                ],
              );
            },
          )
        };
      }
    );
  }
}


class _LiveListenersLoading extends StatelessWidget {
  const _LiveListenersLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Getting listeners...',
          style: context.textTheme.bodySmall
              ?.copyWith(fontSize: 17),
        ),
        Divider(
          color: ATColors.white.withValues(alpha: 0.1),
        ),
        const SizedBox(height: 10),
        const OverlappingImagesShimmer(),
        const SizedBox(height: 20),
        ATShimmer(
          height: 10, radius: 3,
          width: context.screenWidth * 0.6
        ),
      ],
    );
  }
}
