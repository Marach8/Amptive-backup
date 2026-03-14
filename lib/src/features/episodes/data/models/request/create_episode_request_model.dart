class CreateEpisodePayload {
  CreateEpisodePayload({
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.category,
    required this.showTypeOverride,
    required this.priceOverride,
    required this.tagIds,
    required this.coHostIds,
    required this.communityId,
    required this.allowHandRaising,
    required this.allowWhispers,
    this.scheduledFor
  });

  final String title, description, thumbnailUrl, 
    category, showTypeOverride, communityId;
  final double priceOverride;
  final String? scheduledFor;
  final List<String> tagIds, coHostIds;
  final bool allowHandRaising, allowWhispers;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      if (scheduledFor != null)'scheduled_for': scheduledFor,
      'category': category,
      'show_type_override': showTypeOverride,
      'price_override': priceOverride,
      'tag_ids': tagIds,
      'co_host_ids': coHostIds,
      "community_id": communityId,
      'hand_raising': allowHandRaising,
      'whispers': allowWhispers,
    };
  }
}
