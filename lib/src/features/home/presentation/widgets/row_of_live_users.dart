import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/home/cubits/home_feed_cubit.dart';
import 'package:amptive/src/features/home/cubits/live_users_cubit.dart';
import 'package:amptive/src/features/home/cubits/toggle_following_cubit.dart';
import 'package:amptive/src/features/home/data/models/following_status.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/features/home/data/models/response/live_users_response_model.dart';
import 'package:amptive/src/features/home/presentation/widgets/render_home_feed_item.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../shared/circular_image.dart';
import '../../../../shared/divider_widget.dart';
import '../../../../shared/image_loader_widget.dart';
import '../../../../shared/empty.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/appbar_drop_down.dart';
import '../widgets/go_live_widget_in_home.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/views/widgets/animation_widgets/other_animation_widgets/live_user_animation.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/live_indicator_widget.dart';
import 'package:flutter/material.dart';

class RowOfLiveUsers extends StatelessWidget {
  const RowOfLiveUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.red,
      height: 100,
      child: BlocConsumer<LiveUsersCubit, ATAppState<LiveUsersResponseModel>>(
        listener: (_, ATAppState<LiveUsersResponseModel> state) {
          if (state is FailureState<LiveUsersResponseModel>) {
            showAppNotification2(
              context: context,
              text: state.message,
              type: NotificationType.failure,
            );
          }
        },
        builder: (_, ATAppState<LiveUsersResponseModel> state) {
          return switch (state) {
            InitialState<LiveUsersResponseModel>() => const SizedBox.shrink(),
            LoadingState<LiveUsersResponseModel>() ||
            FailureState<LiveUsersResponseModel>() ||
            SuccessState<LiveUsersResponseModel>() =>
              Builder(builder: (_) {
                final LiveUsersResponseModel? liveUsersData =
                    context.read<LiveUsersCubit>().currentLiveUsersData;
                final List<LiveUser> liveUsers =
                    liveUsersData?.liveUsers ?? <LiveUser>[];
      
                if (liveUsers.isEmpty) {
                  if (state is LoadingState<LiveUsersResponseModel>) {
                    return _InitialLoading();
                  }
                  if(state is FailureState<LiveUsersResponseModel>) {
                    return Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 11),
                          child: GoLiveWidgetInHome(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () =>
                            context.read<LiveUsersCubit>().fetchLiveUsers()
                        ),
                      ],
                    );
                  }
                  return const Center(
                    child: Text('No feed items available'),
                  );
                }
      
                final int count = liveUsers.length;
      
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemCount: count + 1,
                  itemBuilder: (_, int index) {
                    if (index == 0) {
                      return const Padding(
                        padding: EdgeInsets.only(left: 11),
                        child: GoLiveWidgetInHome(),
                      );
                    }
                    final LiveUser liveUser = liveUsers[index - 1];
                    return LiveUserWidget(
                      // TODO: Pass liveUser data once LiveUserWidget is updated to accept LiveUser
                      key: ValueKey<String?>(
                          liveUser.userId ?? 'live_user_$index'),
                    );
                  },
                );
              })
          };
        },
      ),
    );
  }
}

class LiveUserWidget extends StatelessWidget {
  const LiveUserWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        const Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            AnimatedPicPaddingWidget(
              imagePath: ATImgStrings.jpeg3,
            ),
            Positioned(
              bottom: -4,
              child: AmptiveLiveIndicatorWidget(),
            )
          ],
        ),
        const SizedBox(height: 10),
        Text('emmanuel', style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}



class _InitialLoading extends StatelessWidget {
  const _InitialLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (_, __) => const SizedBox(width: 14),
      itemCount: 10,
      itemBuilder: (_, int index){
        if(index == 0){
          return const Padding(
            padding: EdgeInsets.only(left: 11),
            child: GoLiveWidgetInHome(),
          );
        }
        return _LiveUserShimmer();
      }
    );
  }
}


class _LiveUserShimmer extends StatelessWidget {
  const _LiveUserShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        const Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            AnimatedPicPaddingWidget(
              imagePath: ATImgStrings.jpeg3,
            ),
            Positioned(
              bottom: -4,
              child: ATShimmer(
                height: 10, width: 50,
              )
            )
          ],
        ),
        const SizedBox(height: 10),
        ATShimmer(height: 8, width: 60,)
      ],
    );
  }
}
