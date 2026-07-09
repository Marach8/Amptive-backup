import 'package:amptive/src/features/home/cubits/toggle_following_cubit.dart';
import 'package:amptive/src/features/home/data/models/following_status.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/features/home/presentation/widgets/render_home_feed_item.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnifiedMockProgramCard extends StatelessWidget {
  const UnifiedMockProgramCard({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context) {
    final HomeFeedItem item = HomeFeedItem(
      id: itemId,
      title: 'Don’t Forget Who You Are ft. Jacob Scipio.',
      contentType: 'episode',
      status: 'scheduled',
      scheduledFor: '2026-07-15T17:00:00Z',
      hostName: 'glennondoyle',
      hostId: 'mock_glenn_id',
      hostProfileImageUrl: 'assets/images/png_images/center_avatar.png',
      coverUrl: 'assets/images/jpeg_images/weCanDoAllThings.jpg',
      thumbnailUrl: 'assets/images/jpeg_images/weCanDoAllThings.jpg',
      goingCount: 1,
      requesterIsGoing: false,
      coHostCount: 2,
      showType: 'paid',
      showTitle: 'We Can Do Hard Things',
      avatarUrls: <String>[
        'assets/images/png_images/dummy_avatar_a.png',
      ],
      tags: const <HashTag>[
        HashTag(name: 'SelfDiscovery'),
        HashTag(name: 'Relationships'),
        HashTag(name: 'Inspiration'),
        HashTag(name: 'Podcast'),
      ],
      description:
          'Jessica Yellin returns to walk us through what is happening right now.',
    );

    return BlocProvider<ToggleFollowingCubit>(
      create: (_) => ToggleFollowingCubit(
        initialStatus: const FollowingStatus(
          isFollowing: true,
          followerCount: 0,
        ),
      ),
      child: RenderHomeFeedItem(homeFeedItem: item),
    );
  }
}
