import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo_impl.dart';
import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';
import 'package:amptive/src/features/events/data/repository/events_repo_impl.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/features/shows/data/repository/shows_repo_impl.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/render_hashtags.dart';
import 'package:flutter/material.dart';

class ProgramDetailHashtags extends StatefulWidget {
  const ProgramDetailHashtags({super.key, required this.homeFeedItem});

  final HomeFeedItem? homeFeedItem;

  @override
  State<ProgramDetailHashtags> createState() => _ProgramDetailHashtagsState();
}

class _ProgramDetailHashtagsState extends State<ProgramDetailHashtags> {
  late final Future<List<HashTag>> _hashtags;

  @override
  void initState() {
    super.initState();
    _hashtags = _loadHashtags();
  }

  Future<List<HashTag>> _loadHashtags() async {
    final HomeFeedItem? item = widget.homeFeedItem;
    final List<HashTag> feedTags = item?.tags ?? <HashTag>[];
    if (feedTags.isNotEmpty || item?.id == null) return feedTags;

    final String contentType = item?.contentType?.toLowerCase() ?? '';

    if (contentType == 'standalone') {
      final ApiResponse<HostedEvent> response =
          await EventsRepoImpl().fetchEvent(eventId: item!.id!);
      return response.when(
        successful: (Successful<HostedEvent> data) =>
            data.data?.tags ?? <HashTag>[],
        unSuccessful: (Unsuccessful<HostedEvent> _) => <HashTag>[],
      );
    }

    if (contentType == 'episode' && item?.showId != null) {
      final ApiResponse<Episode> response =
          await EpisodesRepoImpl().fetchEpisodeDetail(
        showId: item!.showId!,
        episodeId: item.id!,
      );
      return response.when(
        successful: (Successful<Episode> data) =>
            data.data?.tags ?? <HashTag>[],
        unSuccessful: (Unsuccessful<Episode> _) => <HashTag>[],
      );
    }

    final String? showId = item?.showId ?? item?.id;
    if (showId == null) return <HashTag>[];

    final ApiResponse<HostedShow> response =
        await ShowsRepoImpl().fetchShow(showId: showId);
    return response.when(
      successful: (Successful<HostedShow> data) =>
          data.data?.tags ?? <HashTag>[],
      unSuccessful: (Unsuccessful<HostedShow> _) => <HashTag>[],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HashTag>>(
      future: _hashtags,
      builder: (BuildContext context, AsyncSnapshot<List<HashTag>> snapshot) {
        final List<HashTag> hashtags = snapshot.data ?? <HashTag>[];
        if (hashtags.isEmpty) return const SizedBox(height: 40);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 40),
            Text(
              ATStrings.hashtags,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontSize: ATSizes.size17),
            ),
            Divider(color: ATColors.white.withValues(alpha: 0.1)),
            const SizedBox(height: 5),
            RenderHashTags(hashtags: hashtags),
            const SizedBox(height: 30),
          ],
        );
      },
    );
  }
}
