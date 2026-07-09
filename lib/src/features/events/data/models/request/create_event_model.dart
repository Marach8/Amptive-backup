class CreateEventPayload {
  CreateEventPayload({
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.category,
    required this.eventType,
    required this.price,
    this.scheduledFor,
    required this.communityId,
    required this.tagIds,
    required this.coHostIds,
    required this.handRaising,
    required this.allowWhispers,
    required this.capacity,
  });

  final String title, description, thumbnailUrl, category, eventType,
    communityId, capacity;
  final double price;
  final String? scheduledFor;
  final List<String> tagIds, coHostIds;
  final bool handRaising, allowWhispers;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'category': category,
      'show_type': eventType,
      'price': price,
      if(scheduledFor != null)'scheduled_for': scheduledFor,
      'community_id': communityId,
      'tag_ids': tagIds,
      'co_host_ids': coHostIds,
      'co_hosts': coHostIds,
      'hand_raising': handRaising,
      'allow_whispers': allowWhispers,
      'capacity': capacity,
    };
  }
}
