import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/home/cubits/live_listeners_cubit.dart';
import 'package:amptive/src/features/home/data/models/response/live_listeners_response_model.dart';
import 'package:amptive/src/shared/refresh_widgets.dart';
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
    return BlocConsumer<LiveListenersCubit, ATAppState<LiveListenersResponseModel>>(
      listener: (_, ATAppState<LiveListenersResponseModel> state){
        if(state is FailureState<LiveListenersResponseModel>){
          showAppNotification2(
            text: state.message,
            type: NotificationType.failure,
          );
        }
      },
      builder: (_, ATAppState<LiveListenersResponseModel> state) {
        return switch (state){
          InitialState<LiveListenersResponseModel>() ||
          LoadingState<LiveListenersResponseModel>() => const _LiveListenersLoading(),
          FailureState<LiveListenersResponseModel>() => Center(
            child: RetryWidget(
              onRetry: (){
                context.read<LiveListenersCubit>().fetchLiveListeners();
              },
            ),
          ),
          SuccessState<LiveListenersResponseModel>(
            :final LiveListenersResponseModel? newData) => Builder(
            builder: (_){
              final bool hasListeners = (newData?.data?.participants 
                ?? <LiveParticipant>[]).isNotEmpty;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Text(
                  hasListeners ? '${newData?.data?.participants?.length} Listening'
                    : 'No Listeners yet',
                  style: context.textTheme.bodySmall
                      ?.copyWith(fontSize: 17),
                ),
                Divider(
                  color:
                      ATColors.white.withValues(alpha: 0.1),
                ),
                const SizedBox(height: 10),
                if(hasListeners) ...<Widget>[
                  const PeopleListeningWithNumberStacked(
                    images: <String>[],
                    noOfListeners: 10,
                  ),
                  const SizedBox(height: 20),
                ],
                Text(
                  hasListeners ?  'daniel, jessica, gerald, peter and 652 more'
                    : 'Be the first to join',
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
  const _LiveListenersLoading();

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
