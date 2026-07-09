import 'package:flutter/material.dart';

import 'society_all_tab_view.dart';

class SocietyShowsTabView extends StatelessWidget {
  const SocietyShowsTabView({
    super.key,
    this.communityId,
    required this.communityName,
  });

  final String? communityId;
  final String communityName;

  @override
  Widget build(BuildContext context) => CommunityFeedSections(
        communityName: communityName,
        mode: CommunityFeedMode.shows,
      );
}
