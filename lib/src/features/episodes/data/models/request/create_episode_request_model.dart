/// Request model for creating an episode
/// Endpoint: POST /api/v1/shows/{show_id}/episodes
class CreateEpisodeRequestModel {
  CreateEpisodeRequestModel({
    this.title,
    this.description,
    this.thumbnailUrl,
    this.scheduledFor,
    this.communityId,
    this.tagIds,
    this.coHostIds,
    this.showTypeOverride,
    this.priceOverride,
  });

  /// Title of the episode
  final String? title;

  /// Description of the episode
  final String? description;

  /// URL of the thumbnail image
  final String? thumbnailUrl;

  /// Scheduled date and time for the episode (ISO 8601 format)
  final DateTime? scheduledFor;

  /// ID of the community
  final String? communityId;

  /// List of tag IDs
  final List<String>? tagIds;

  /// List of co-host IDs
  final List<String>? coHostIds;

  /// Override for show type (e.g., 'free')
  final String? showTypeOverride;

  /// Override for price
  final double? priceOverride;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (scheduledFor != null)
        'scheduled_for': scheduledFor!.toIso8601String(),
      if (communityId != null) 'community_id': communityId,
      if (tagIds != null) 'tag_ids': tagIds,
      if (coHostIds != null) 'co_host_ids': coHostIds,
      if (showTypeOverride != null) 'show_type_override': showTypeOverride,
      if (priceOverride != null) 'price_override': priceOverride,
    };
  }

  /// Create a copy with updated fields
  CreateEpisodeRequestModel copyWith({
    String? title,
    String? description,
    String? thumbnailUrl,
    DateTime? scheduledFor,
    String? communityId,
    List<String>? tagIds,
    List<String>? coHostIds,
    String? showTypeOverride,
    double? priceOverride,
  }) {
    return CreateEpisodeRequestModel(
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      communityId: communityId ?? this.communityId,
      tagIds: tagIds ?? this.tagIds,
      coHostIds: coHostIds ?? this.coHostIds,
      showTypeOverride: showTypeOverride ?? this.showTypeOverride,
      priceOverride: priceOverride ?? this.priceOverride,
    );
  }
}
