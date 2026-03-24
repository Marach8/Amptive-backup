class CreateEventPayload {
  CreateEventPayload({
    required this.title,
    required this.description,
    required this.coverUrl,
    required this.category,
    required this.eventType,
    required this.price,
    required this.tagIds,
    required this.coHostIds,
    required this.communityId,
    required this.startTime,
    required this.endTime,
    required this.location,
  });

  final String title, description, coverUrl, 
    category, eventType, communityId, startTime, endTime, location;
  final double price;
  final List<String> tagIds, coHostIds;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'cover_url': coverUrl,
      'category': category,
      'event_type': eventType,
      'price': price,
      'tag_ids': tagIds,
      'co_host_ids': coHostIds,
      'community_id': communityId,
      'start_time': startTime,
      'end_time': endTime,
      'location': location,
    };
  }
}
