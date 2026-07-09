import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/home/cubits/live_users_cubit.dart';
import 'package:amptive/src/features/home/data/models/response/live_users_response_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../shared/image_loader_widget.dart';
import '../widgets/go_live_widget_in_home.dart';
import 'package:amptive/src/shared/live_user_animation.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/shared/scale_on_press_widget.dart';

class RowOfLiveUsers extends StatelessWidget {
  const RowOfLiveUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          104, // Reduced from 110 to 104: the exact mathematical minimum needed to clear the 4px animation overflow
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
          return Builder(builder: (_) {
            final LiveUsersResponseModel? liveUsersData =
                context.read<LiveUsersCubit>().currentLiveUsersData;
            final List<LiveUser> liveUsers =
                liveUsersData?.liveUsers ?? <LiveUser>[];

            if (liveUsers.isEmpty) {
              if (state is LoadingState<LiveUsersResponseModel>) {
                return const _InitialLoading();
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: GoLiveWidgetInHome(),
                  ),
                  if (state is FailureState<LiveUsersResponseModel>)
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () =>
                          context.read<LiveUsersCubit>().fetchLiveUsers(),
                    ),
                ],
              );
            }

            bool hasMore = liveUsersData?.hasMore ?? true;
            final int count =
                hasMore ? liveUsers.length + 2 : liveUsers.length + 1;

            return ListView.separated(
              padding: const EdgeInsets.only(right: 16),
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemCount: count,
              itemBuilder: (_, int index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: GoLiveWidgetInHome(),
                  );
                }

                final int adjustedIndex = index - 1;

                if (adjustedIndex < liveUsers.length) {
                  final LiveUser liveUser = liveUsers[adjustedIndex];
                  return LiveUserWidget(
                    user: liveUser,
                    key: ValueKey<String>(liveUser.userId ?? ''),
                  );
                }

                if (state is LoadingState<LiveUsersResponseModel>) {
                  return const _LiveUserShimmer();
                }

                return const SizedBox.shrink();
              },
            );
          });
        },
      ),
    );
  }
}

class LiveUserWidget extends StatelessWidget {
  const LiveUserWidget({
    super.key,
    required this.user,
  });
  final LiveUser user;

  @override
  Widget build(BuildContext context) {
    return ScaleOnPressWidget(
      scaleDownTo: 0.92,
      onTap: () {
        // TODO: Navigate to the live stream
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              LiveUserAnimationWidget(
                child: ATImgLoader(
                  imgPath: user.profileImageUrl ?? ATImgStrings.noAvatarImage,
                  boxFit: BoxFit.cover,
                  // Decode at display size — the loader's 35px default
                  // makes avatars soft on high-density screens.
                  width: 70,
                  height: 70,
                ),
              ),
              const Positioned(
                bottom: -4,
                child: _LiveIndicator(),
              )
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 68,
            child: Text(
              user.username?.trim().isNotEmpty == true
                  ? user.username!
                  : 'Live user',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveIndicator extends StatelessWidget {
  const _LiveIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(0),
      height: 22,
      width: 38,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                ATColors.hexF91880,
                ATColors.orangeGradientColorB
              ]),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: ATColors.hex0D0D0D,
            width: 2,
          )),
      child: Text(ATStrings.live.toUpperCase(),
          style: context.textTheme.titleSmall
              ?.copyWith(fontWeight: ATFontWeights.w600)),
    );
  }
}

class _InitialLoading extends StatelessWidget {
  const _InitialLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.only(right: 16),
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemCount: 10,
        itemBuilder: (_, int index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.only(left: 8),
              child: GoLiveWidgetInHome(),
            );
          }
          return const _LiveUserShimmer();
        });
  }
}

class _LiveUserShimmer extends StatelessWidget {
  const _LiveUserShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ATColors.hex2D2D2D,
      highlightColor: ATColors.hex5B5B5B,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 64,
            width: 64,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 10,
            width: 50,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
