import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/episodes/cubits/episode_detail_cubit.dart';
import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/features/home/presentation/screens/schedule_detailed_screen.dart';
import 'package:amptive/src/features/home/presentation/widgets/program_actions_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Opens an episode in the exact same styled modal the homepage feed cards
/// use ([ATScheduleDetailedScreen]) — but first fetches the full episode so
/// the host avatar, description and show name are all present (the episodes
/// list endpoint returns a slimmed-down record without them).
class EpisodeScheduleDetailScreen extends StatelessWidget {
  const EpisodeScheduleDetailScreen({super.key, required this.episode});

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<EpisodeDetailCubit>(
          create: (_) => EpisodeDetailCubit(initialEpisode: episode)
            ..fetchEpisodeDetails(),
        ),
        BlocProvider<LocalUserDataCubit>(
          create: (_) => LocalUserDataCubit()..initializeCachedData(),
        ),
      ],
      child: BlocBuilder<EpisodeDetailCubit, ATAppState<Episode>>(
        builder: (BuildContext context, ATAppState<Episode> state) {
          final Episode current =
              context.read<EpisodeDetailCubit>().currentEpisodeDetail ??
                  episode;
          // Still fetching and the host hasn't arrived yet — the modal shows a
          // shimmer instead of the fake placeholder avatar.
          final bool hostLoading =
              (state is InitialState<Episode> ||
                      state is LoadingState<Episode>) &&
                  (current.host?.username ?? '').isEmpty;
          return BlocBuilder<LocalUserDataCubit, ATAppState<CachedUserData>>(
            builder: (BuildContext context,
                ATAppState<CachedUserData> userState) {
              final String? localUserId =
                  context.read<LocalUserDataCubit>().currentUserData?.userId;
              final bool isOwner = localUserId != null &&
                  localUserId == current.host?.userId;

              Future<void> openEditEpisode() async {
                final Object? result = await context.pushNamed(
                  ATRoutes.editEpisodeScreen,
                  extra: current,
                );
                // The edit form pops the updated episode — push it into the
                // detail cubit so the modal reflects the change immediately.
                if (result is Episode && context.mounted) {
                  context.read<EpisodeDetailCubit>().updateEpisode(
                        result.copyWith(
                          parentShowTitle: current.parentShowTitle,
                          host: current.host,
                          community: current.community,
                        ),
                      );
                }
              }

              return ATScheduleDetailedScreen(
                homeFeedItem: _toFeedItem(current),
                hostLoading: hostLoading,
                onEditProgram: isOwner ? openEditEpisode : null,
                onOwnerMoreTapped: isOwner
                    ? () => showOwnerEpisodeOptions(
                          context: context,
                          onEditEpisode: openEditEpisode,
                        )
                    : null,
              );
            },
          );
        },
      ),
    );
  }

  // Maps the episode onto the feed-item shape the detail modal consumes.
  HomeFeedItem _toFeedItem(Episode e) => HomeFeedItem(
        id: e.episodeId,
        title: e.title,
        contentType: 'episode',
        status: e.status,
        hostId: e.host?.userId,
        hostName: e.host?.username,
        hostProfileImageUrl: e.host?.profilePicture,
        showType: e.showTypeOverride,
        price: e.priceOverride,
        viewerCount: e.viewerCount,
        goingCount: e.goingCount,
        coverUrl: e.thumbnailUrl,
        thumbnailUrl: e.thumbnailUrl,
        startedAt: e.startedAt,
        scheduledFor: e.scheduledFor,
        livestreamId: e.livestreamId,
        showId: e.showId,
        showTitle: e.parentShowTitle,
        communityName: e.community?.name,
        tags: e.tags,
        episodeNumber: e.episodeNumber,
        description: e.description,
      );
}
