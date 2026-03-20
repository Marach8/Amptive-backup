class CreateShowPayload {
  CreateShowPayload({
    required this.title,
    required this.description,
    required this.coverUrl,
    required this.category,
    required this.showType,
    required this.price,
    required this.tagIds,
    required this.coHostIds,
    required this.communityId,
    required this.allowHandRaising,
  });

  final String title, description, coverUrl, 
    category, showType, communityId;
  final double price;
  final List<String> tagIds, coHostIds;
  final bool allowHandRaising;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'cover_url': coverUrl,
      'category': category,
      'show_type': showType,
      'price': price,
      'tag_ids': tagIds,
      'co_host_ids': coHostIds,
      "community_id": communityId,
      'hand_raising': allowHandRaising,
    };
  }
}
